import 'dart:convert';
import 'package:timetrack/constants/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetrack/blocs/user_bloc.dart';
import 'package:timetrack/blocs/shippingdata_bloc.dart';
import 'dart:async';
import 'package:timetrack/components/map_pin_pill.dart';
import 'package:timetrack/models/directions.dart';
import 'package:timetrack/models/pin_pill_info.dart';
import 'package:timetrack/models/shipping_details.dart';
import 'package:timetrack/models/static_tracking.dart';
import 'package:timetrack/services/places_service.dart';
import 'package:url_launcher/url_launcher.dart';


const double CAMERA_ZOOM = 12;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(20.7002, 77.0082);
const LatLng DEST_LOCATION = LatLng(20.9320, 77.5523);

class ReceiverTrackingPage extends StatefulWidget {

  @override
  _ReceiverTrackingPageState createState() => _ReceiverTrackingPageState();
}

class _ReceiverTrackingPageState extends State<ReceiverTrackingPage> {
  final fb = FirebaseDatabase.instance;
  var rphone_number;

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
  var trackingLat, trackingLong;
// the user's initial location and current location
// as it moves
  var receiverlocation = null;
// a reference to the destination location
  late LocationData livetrackinlocation;
// wrapper around the location API
  Location location = Location();
  double pinPillPosition = -100;
  PinInformation currentlySelectedPin = PinInformation(
      pinPath: '',
      avatarPath: '',
      location: LatLng(0, 0),
      locationName: '',
      labelColor: Colors.grey);
  late PinInformation sourcePinInfo;
  late PinInformation destinationPinInfo;
  bool isLocationLoaded=false;
  bool isNotifiedData =false;
  Directions? _info;
  TextEditingController _tracking = TextEditingController();

  @override
  void initState() {
    super.initState();
    print('TrackingId.trackingId');
    print(TrackingId.trackingId);
    // create an instance of Location
    location = new Location();
    location.enableBackgroundMode(enable: true);
    polylinePoints = PolylinePoints();
    // set custom marker pins
    setSourceAndDestinationIcons();
    // set the initial location
    setInitialLocation();

    String? trackid = TrackingId.trackingId;
    if(trackid != null){
      searchByTrackingId(trackid);
    }
  }

  void updatePinOnMap() async {
    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation
    print(livetrackinlocation);
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(livetrackinlocation.latitude!, livetrackinlocation.longitude!),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    if(mounted) {
      setState(() {
        // updated position
        var pinPosition =
        LatLng(livetrackinlocation.latitude!, livetrackinlocation.longitude!);
        destinationPinInfo.location = pinPosition;

        // the trick is to remove the marker (by id)
        // and add it again at the updated location
        _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
        _markers.add(Marker(
            markerId: MarkerId('sourcePin'),
            onTap: () {
              setState(() {
                currentlySelectedPin = destinationPinInfo;
                pinPillPosition = 0;
              });
            },
            position: pinPosition, // updated position
            icon: sourceIcon));
      });
    }
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
    receiverlocation = await location.getLocation();

    // receiverlocation = await location.getLocation();
    receiverlocation = LocationData.fromMap({
      "latitude": receiverlocation.latitude,
      "longitude": receiverlocation.longitude
    });
    // hard-coded destination for this example
    livetrackinlocation = LocationData.fromMap({
      "latitude": DEST_LOCATION.latitude,
      "longitude": DEST_LOCATION.longitude
    });
    var trackingId = Provider.of<ShippingDetailsProvider>(context, listen: false).trackingId??null;
    if(trackingId != null){
      searchByTrackingId(trackingId);
      _tracking.text = trackingId;
    }
    setState(() {
      isLocationLoaded = true;
    });
  }

  void showPinsOnMap() {
    // get a LatLng for the source location
    // from the LocationData receiverlocation object
    var pinPosition =
    LatLng(livetrackinlocation.latitude!, livetrackinlocation.longitude!);
    // get a LatLng out of the LocationData object

    sourcePinInfo = PinInformation(
        locationName: "Start Location",
        location: pinPosition,
        pinPath: "assets/images/driving_pin.png",
        avatarPath: "assets/images/friend1.jpg",
        labelColor: Colors.blueAccent);

    var desPosition =
    LatLng(receiverlocation.latitude!, receiverlocation.longitude!);
    destinationPinInfo = PinInformation(
        locationName: "End Location",
        location: desPosition,
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
        icon: BitmapDescriptor.defaultMarker));
    // destination pin



    // set the route lines on the map from source to destination
    // for more info follow this tutorial
    // setPolylines();
  }

  void setPolylines() async {

    PointLatLng sourceLocation = PointLatLng(receiverlocation.latitude!, receiverlocation.longitude!);
    // PointLatLng sourceLocation = PointLatLng(20.7230215, 77.02101);
    PointLatLng liveLocation = PointLatLng(livetrackinlocation.latitude!, livetrackinlocation.longitude!);
    // PointLatLng destLocation = PointLatLng(20.932, 77.75229999999999);
    PolylineResult result = (await polylinePoints.getRouteBetweenCoordinates(
        googleAPIKey,
        sourceLocation,
        liveLocation));

    polylineCoordinates =[];
    print('sadf');
    print(_info!.polylinePoints);
    setState(() {
    _polylines.add(Polyline(
      width: 2, // set the width of the polylines
      polylineId: PolylineId("poly"),
      color: Color.fromARGB(255, 40, 122, 198),
      points: _info!.polylinePoints!
          .map((e) => LatLng(e.latitude, e.longitude))
          .toList(),));
    });
    // }

  }

  void searchByTrackingId(trackingID) async{
    var data= {
      "tracking_id" : trackingID.toString(),
    };
    final Future<Map<String, dynamic>> successfulMessage =  Provider.of<ShippingDetailsProvider>(context, listen: false).searchByTracking(data, 'searchByTracking');
    successfulMessage.then((response) async {
      if (response['status']) {

          var  destLat  = Provider.of<ShippingDetailsProvider>(context, listen: false).trackingDetails.latitude;
          var  destLong = Provider.of<ShippingDetailsProvider>(context, listen: false).trackingDetails.longitude;
          ShippingData trackingDetails = Provider.of<ShippingDetailsProvider>(context, listen: false).trackingDetails;

          receiverlocation = LocationData.fromMap({
            "latitude": destLat,
            "longitude": destLong
          });

          fb.reference().child(trackingDetails.trackingId!).once().then((value)  async {
            // LocationData locationData = (json.decode(value.value)['location']);
            final location = value.value['location'];
            final trackingLat = location['latitude'];
            final trackingLong = location['longitude'];

            livetrackinlocation = LocationData.fromMap({
              "latitude": trackingLat,
              "longitude": trackingLong
            });
            var destPosition =
            LatLng(receiverlocation.latitude!, receiverlocation.longitude!);
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

            final directions = await PlacesService()
                .getDirections(origin: LatLng(receiverlocation.latitude!, receiverlocation.longitude!), destination: LatLng(livetrackinlocation.latitude!, livetrackinlocation.longitude!));
            setState(() => _info = directions);
            showPinsOnMap();
            setPolylines();
          });
         
           fb.reference().child(trackingDetails.trackingId!).onValue.listen((event) {
            var snapshot = event.snapshot;
            final location = snapshot.value['location'];
            final trackingLat = location['latitude'];
            final trackingLong = location['longitude'];
            livetrackinlocation = LocationData.fromMap({
              "latitude": trackingLat,
              "longitude": trackingLong
            });
            updatePinOnMap();
          });

      } else {
        SnackBar(
          content: Text("Failed"),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final phone_number = Provider.of<ShippingDetailsProvider>(context, listen: false).trackingDetails.phoneNumber;
    final note = Provider.of<ShippingDetailsProvider>(context, listen: false).trackingDetails.note;
    final ETA = Provider.of<ShippingDetailsProvider>(context, listen: false).trackingDetails.eTA;
    final user = Provider.of<UserProvider>(context, listen: false).user;
    Color colorConvert(String color) {
      color = color.replaceAll("#", "");
      if (color.length == 6) {
        return Color(int.parse("0xFF"+color));
      } else if (color.length == 8) {
        return Color(int.parse("0x"+color));
      }
      return Color(0xfff3f3f4);
    }



    return Scaffold(
      body: SafeArea(
        child: Container(
          color: colorConvert('#e1f6ff'),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if(user.avatar_name != null)
                        InkWell(
                          child: CircleAvatar(
                            radius: 25.0,
                            backgroundImage:NetworkImage("${BASE_URL}profile/profile/${user.avatar_name}"),
                            backgroundColor: Colors.transparent,
                          ),
                          onTap: (){
                            Navigator.pushNamed(context, '/profilepage');
                          },
                        ),

                      if(user.avatar_name == null)
                        InkWell(
                          child: Icon(Icons.account_circle_rounded, size: 45,),
                          onTap: (){
                            Navigator.pushNamed(context, '/profilepage');
                          },
                        ),

                      Text('Shipping Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color:colorConvert('#ec2761')),),
                      InkWell(
                          child: Icon(Icons.close, size: 45,),
                        onTap: (){
                            Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                receiverlocation == null ? Center(child: CircularProgressIndicator(),) : Container(
                  width: width,
                  height: height * 0.7,
                  child: Stack(
                    children:[ GoogleMap(
                        myLocationEnabled: true,
                        compassEnabled: true,
                        scrollGesturesEnabled: true,
                        markers: _markers,
                        zoomControlsEnabled: true,
                        tiltGesturesEnabled: false,
                        zoomGesturesEnabled: true,
                        polylines: _polylines,
                        initialCameraPosition: CameraPosition(
                            zoom: CAMERA_ZOOM,
                            tilt: CAMERA_TILT,
                            bearing: CAMERA_BEARING,
                            target: LatLng(receiverlocation.latitude!, receiverlocation.longitude!)),
                        onTap: (LatLng loc) {
                          pinPillPosition = -100;
                        },
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                          // my map has completed being created;
                          // i'm ready to show the pins on the map
                          showPinsOnMap();
                        }),
                      MapPinPillComponent(
                          pinPillPosition: pinPillPosition,
                          currentlySelectedPin: currentlySelectedPin),
                      Positioned(
                          top: height*0.01,
                          width: width,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: width,
                              child: Container(
                                width: width,
                                color: Colors.white,
                                child: TextFormField(
                                  controller: _tracking,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.search, size: 30,),
                                    hintText: "Enter Tracking ID"
                                  ),
                                 onEditingComplete: (){
                                   searchByTrackingId(_tracking.text);
                                 },
                      ),
                              ),
                            ),)),

                      // if(ETA != null)
                      // Positioned(
                      //     bottom: height*0.03,
                      //     width: width,
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: SizedBox(
                      //         width: width * 0.8 ,
                      //         child: Container(
                      //           width: width,
                      //           color: Colors.white,
                      //           child:Padding(
                      //             padding: const EdgeInsets.all(16.0),
                      //             child: Column(
                      //               mainAxisAlignment: MainAxisAlignment.start,
                      //               children: [
                      //                 Text("ETA For This Delivery By Dispatcher", style: TextStyle(fontWeight: FontWeight.w300, color: Colors.grey, fontSize: 18),),
                      //                 Center(child: Text("$ETA", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize:18), ),),
                      //                 Text("Note:$note")
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //       ),))
                  ]),
                ),
                SizedBox(height: height*0.04,),
                Container(
                  height: height * 0.2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        child: Column(
                          children: [
                            Container(
                              width: width * 0.3,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colorConvert('#FAD4E0')),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.call, size: 50, color:colorConvert('#ec2761')),
                              ) ,
                            ),
                            Text("Call Courier"),
                          ],
                        ),
                        onTap: (){
                          launch("tel:${phone_number}");

                        },
                      ),
                      InkWell(
                        child: Column(
                          children: [
                            Container(
                                width: width * 0.3,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colorConvert('#FAD4E0')),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.message, size: 50, color:colorConvert('#ec2761'),),
                                )

                            ),
                            Text("Message"),
                          ],
                        ),
                        onTap: (){
                          launch('sms:${phone_number}');
                        },
                      )
                    ],
                  ),
                )

              ],
            ),
          ),
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