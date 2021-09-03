import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetrack/blocs/shippingdata_bloc.dart';
import 'package:timetrack/blocs/user_bloc.dart';
import 'dart:async';
import 'package:timetrack/components/map_pin_pill.dart';
import 'package:timetrack/models/directions.dart';
import 'package:timetrack/models/pin_pill_info.dart';
import 'package:timetrack/services/places_service.dart';


const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(20.7002, 77.0082);
const LatLng DEST_LOCATION = LatLng(20.9320, 77.7523);

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final fb = FirebaseDatabase.instance;
  var ref;
  var isLocationLoaded = false;
  var trackingId;

  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();
  // for my drawn routes on the map
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;
  String googleAPIKey = 'AIzaSyCzKSXNFa6SVglo8rEf00ok5ION6tapdYg';
  // for my custom marker pins
  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor destinationIcon;
  // the user's initial location and current location
  // as it moves
  // a reference to the destination location
  // wrapper around the location API
  Location location = Location();
  late LocationData currentLocation;
  late LocationData destinationLocation;
  late LatLng destLocations;
  double pinPillPosition = -100;
  PinInformation currentlySelectedPin = PinInformation(
      pinPath: '',
      avatarPath: '',
      location: LatLng(0, 0),
      locationName: '',
      labelColor: Colors.grey);
  late PinInformation sourcePinInfo;
  late PinInformation destinationPinInfo;
  Directions? _info;

  @override
  void initState() {
    super.initState();
    // create an instance of Location
    location = Location();
    location.enableBackgroundMode(enable: true);
    polylinePoints = PolylinePoints();
    ref = fb.reference();
    // set custom marker pins
    setSourceAndDestinationIcons();
    // set the initial location
    setInitialLocation();
    // var lat = Provider.of<ShippingDetailsProvider>(context).trackingDetails.latitude;
    // var long = Provider.of<ShippingDetailsProvider>(context).trackingDetails.longitude;
    //  destLocations = LatLng(lat!, long!);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    var lat = Provider.of<ShippingDetailsProvider>(context).trackingDetails.latitude;
    var long = Provider.of<ShippingDetailsProvider>(context).trackingDetails.longitude;
    trackingId = Provider.of<ShippingDetailsProvider>(context).trackingDetails.trackingId;
    destLocations = LatLng(lat??0.0, long??0.0);
    super.didChangeDependencies();
  }

  void updatePinOnMap() async {
    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    setState(() {
      // updated position
      var pinPosition =
      LatLng(currentLocation.latitude!, currentLocation.longitude!);

      sourcePinInfo.location = pinPosition;

      // the trick is to remove the marker (by id)
      // and add it again at the updated location
      _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          onTap: () {
            setState(() {
              currentlySelectedPin = sourcePinInfo;
              pinPillPosition = 0;
            });
          },
          position: pinPosition, // updated position
          icon: sourceIcon));
    });
  }

  void setSourceAndDestinationIcons() async {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.0), 'assets/images/driving_pin.png')
        .then((onValue) {
      sourceIcon = onValue;
    });

    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.0),
        'assets/images/destination_map_marker.png')
        .then((onValue) {
      destinationIcon = onValue;
    });
  }

  void setInitialLocation() async {
    // set the initial location by pulling the user's
    // current location from the location's getLocation()

    currentLocation = await location.getLocation();
    currentLocation = LocationData.fromMap({
      "latitude": currentLocation.latitude,
      "longitude": currentLocation.longitude
    });
    // hard-coded destination for this example
    destinationLocation = LocationData.fromMap({
      "latitude": destLocations.latitude,
      "longitude": destLocations.longitude
    });
    final directions = await PlacesService()
        .getDirections(origin: LatLng(currentLocation.latitude!, currentLocation.longitude!), destination: LatLng(destLocations.latitude, destLocations.longitude));
    setState(() => _info = directions);
    // ref.child(trackingId).set({"location" : currentLocation});
    setState(() {
      isLocationLoaded = true;
    });
  }

  void showPinsOnMap() async{
    // get a LatLng for the source location
    // from the LocationData currentLocation object
    var pinPosition =
    LatLng(currentLocation.latitude!, currentLocation.longitude!);
    // get a LatLng out of the LocationData object
    var destPosition =
    LatLng(destinationLocation.latitude!, destinationLocation.longitude!);

    sourcePinInfo = PinInformation(
        locationName: "Start Location",
        location: pinPosition,
        pinPath: "assets/images/driving_pin.png",
        avatarPath: "assets/images/friend1.jpg",
        labelColor: Colors.blueAccent);

    destinationPinInfo = PinInformation(
        locationName: "End Location",
        location: destLocations,
        pinPath: "assets/images/destination_map_marker.png",
        avatarPath: "assets/images/friend2.jpg",
        labelColor: Colors.purple);

    // add the initial source location pin
    _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: pinPosition,
        onTap: () {
          setState(() {
            currentlySelectedPin = sourcePinInfo;
            pinPillPosition = 0;
          });
        },
        icon: sourceIcon));
    // destination pin
    _markers.add(Marker(
        markerId: MarkerId('destPin'),
        position: destPosition,
        onTap: () {
          setState(() {
            currentlySelectedPin = destinationPinInfo;
            pinPillPosition = 0;
          });
        },
        icon: destinationIcon));
    // set the route lines on the map from source to destination
    // for more info follow this tutorial
    setPolylines();
  }

  void setPolylines() async {
    PointLatLng sourceLocation = PointLatLng(currentLocation.latitude!, currentLocation.longitude!);
    PointLatLng destLocation = PointLatLng(destinationLocation.latitude!, destinationLocation.longitude!);


    PolylineResult result = (await polylinePoints.getRouteBetweenCoordinates(
        googleAPIKey,
        sourceLocation,
        destLocation));

    if ((result.points).isNotEmpty) {
      // (result.points).forEach((PointLatLng point) {
      //   polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      // });



      // (result.points).forEach((PointLatLng point) {
      //   polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      // });
print('here');
      setState(() {
        _polylines.add(Polyline(
            width: 2, // set the width of the polylines
            polylineId: PolylineId("poly"),
            color: Color.fromARGB(255, 40, 122, 198),
            points: _info!.polylinePoints!
                .map((e) => LatLng(e.latitude, e.longitude))
                .toList(),));
      });
    }
  }

  Color colorConvert(String color) {
    color = color.replaceAll("#", "");
    if (color.length == 6) {
      return Color(int.parse("0xFF"+color));
    } else if (color.length == 8) {
      return Color(int.parse("0x"+color));
    }
    return Color(0xfff3f3f4);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    print('get user details');
    print(Provider.of<ShippingDetailsProvider>(context).trackingDetails);

    return Scaffold(
      body: SafeArea(
        child: !isLocationLoaded ? Center(child: CircularProgressIndicator(),) : Stack(
          children: <Widget>[
            GoogleMap(
                myLocationEnabled: true,
                compassEnabled: true,
                tiltGesturesEnabled: false,
                markers: _markers,
                polylines: {
                  if(_info != null)
                    Polyline(
                       points: _info!.polylinePoints!.map((e) => LatLng(e.latitude, e.longitude)).toList(),
                        width:2,
                        polylineId: PolylineId('overview')
                    )

                },
                mapType: MapType.terrain,
                initialCameraPosition: CameraPosition(
                    zoom: CAMERA_ZOOM,
                    tilt: CAMERA_TILT,
                    bearing: CAMERA_BEARING,
                    target: LatLng(
                        currentLocation.latitude!, currentLocation.longitude!)),
                onTap: (LatLng loc) {
                  pinPillPosition = -100;
                },
                onMapCreated: (GoogleMapController controller) {
                  // controller.setMapStyle(Utils.mapStyles);
                  _controller.complete(controller);
                  // my map has completed being created;
                  // i'm ready to show the pins on the map
                  showPinsOnMap();
                }),
            MapPinPillComponent(
                pinPillPosition: pinPillPosition,
                currentlySelectedPin: currentlySelectedPin),
            Positioned(
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: width,
                  height: height * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [


                      Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: TextButton(
                          child: Text('Home', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300),),
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: colorConvert('#ec2761'),
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/deliveryqueuepage');
                          },
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: TextButton(
                          child: Text('Start', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300),),
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: colorConvert('#ec2761'),
                          ),
                          onPressed: () {
                            location.onLocationChanged.listen((LocationData cLoc) {
                              currentLocation = cLoc;
                              ref.child(trackingId).set({"location" : {'lat':currentLocation.latitude, 'long':currentLocation.longitude}});
                              updatePinOnMap();
                            });
                          },
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


// class Utils {
//   static String mapStyles = '''[
//   {
//     "elementType": "geometry",
//     "stylers": [
//       {
//         "color": "#f5f5f5"
//       }
//     ]
//   },
//   {
//     "elementType": "labels.icon",
//     "stylers": [
//       {
//         "visibility": "off"
//       }
//     ]
//   },
//   {
//     "elementType": "labels.text.fill",
//     "stylers": [
//       {
//         "color": "#616161"
//       }
//     ]
//   },
//   {
//     "elementType": "labels.text.stroke",
//     "stylers": [
//       {
//         "color": "#f5f5f5"
//       }
//     ]
//   },
//   {
//     "featureType": "administrative.land_parcel",
//     "elementType": "labels.text.fill",
//     "stylers": [
//       {
//         "color": "#bdbdbd"
//       }
//     ]
//   },
//   {
//     "featureType": "poi",
//     "elementType": "geometry",
//     "stylers": [
//       {
//         "color": "#eeeeee"
//       }
//     ]
//   },
//   {
//     "featureType": "poi",
//     "elementType": "labels.text.fill",
//     "stylers": [
//       {
//         "color": "#757575"
//       }
//     ]
//   },
//   {
//     "featureType": "poi.park",
//     "elementType": "geometry",
//     "stylers": [
//       {
//         "color": "#e5e5e5"
//       }
//     ]
//   },
//   {
//     "featureType": "poi.park",
//     "elementType": "labels.text.fill",
//     "stylers": [
//       {
//         "color": "#9e9e9e"
//       }
//     ]
//   },
//   {
//     "featureType": "road",
//     "elementType": "geometry",
//     "stylers": [
//       {
//         "color": "#ffffff"
//       }
//     ]
//   },
//   {
//     "featureType": "road.arterial",
//     "elementType": "labels.text.fill",
//     "stylers": [
//       {
//         "color": "#757575"
//       }
//     ]
//   },
//   {
//     "featureType": "road.highway",
//     "elementType": "geometry",
//     "stylers": [
//       {
//         "color": "#dadada"
//       }
//     ]
//   },
//   {
//     "featureType": "road.highway",
//     "elementType": "labels.text.fill",
//     "stylers": [
//       {
//         "color": "#616161"
//       }
//     ]
//   },
//   {
//     "featureType": "road.local",
//     "elementType": "labels.text.fill",
//     "stylers": [
//       {
//         "color": "#9e9e9e"
//       }
//     ]
//   },
//   {
//     "featureType": "transit.line",
//     "elementType": "geometry",
//     "stylers": [
//       {
//         "color": "#e5e5e5"
//       }
//     ]
//   },
//   {
//     "featureType": "transit.station",
//     "elementType": "geometry",
//     "stylers": [
//       {
//         "color": "#eeeeee"
//       }
//     ]
//   },
//   {
//     "featureType": "water",
//     "elementType": "geometry",
//     "stylers": [
//       {
//         "color": "#c9c9c9"
//       }
//     ]
//   },
//   {
//     "featureType": "water",
//     "elementType": "labels.text.fill",
//     "stylers": [
//       {
//         "color": "#9e9e9e"
//       }
//     ]
//   }
// ]''';
// }
