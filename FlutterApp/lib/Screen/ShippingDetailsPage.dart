import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart';
import 'package:timetrack/blocs/application_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetrack/blocs/shippingdata_bloc.dart';
import 'package:timetrack/blocs/user_bloc.dart';
import 'package:timetrack/constants/constants.dart';
import 'package:timetrack/models/User.dart';
import 'package:timetrack/models/shipping_details.dart';
import 'package:timetrack/services/auth_service.dart';
import 'package:timetrack/services/places_service.dart';

class ShippingDetailsPage extends StatefulWidget {
  @override
  _ShippingDetailsPageState createState() => _ShippingDetailsPageState();
}

class _ShippingDetailsPageState extends State<ShippingDetailsPage> {
  var _time = TimeOfDay.now();
  final fb = FirebaseDatabase.instance;
  var ref;
  final plugin = PaystackPlugin();

  var showLoading = false;


  bool showLocation = false;
  bool showUser = false;
  bool locationloading = false;
  bool viewnamefield = false;

  TextEditingController _receivername     = TextEditingController();
  TextEditingController _receivernumber   = TextEditingController();
  TextEditingController _receiverlocation = TextEditingController();
  TextEditingController _note = TextEditingController();
  Location location = Location();
  late LocationData currentLocation;
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
  void initState(){
    super.initState();
    setInitialLocation();
    _time=TimeOfDay.now();
    plugin.initialize(publicKey: paystackPublicKey);
  }

  void setInitialLocation() async {
    currentLocation = await location.getLocation();
  }

  Future<Null> selectTime(BuildContext context) async{
    var time = (await showTimePicker(context: context, initialTime: _time,))!;
    if(_time != null){
      setState(() {
        print('adsf');
        print(time.period);
        _time = time.replacing(hour: time.hourOfPeriod);
      });
    }
  }

  String getText(){
    return MaterialLocalizations.of(context).formatTimeOfDay(_time).toString();
  }

  final _receiverformKey = GlobalKey<FormState>();

  postShippingDetail() async{
    setState(() {
      showLoading =true;
    });
    var lat, long;
    var result = await PlacesService().getLatLong(_receiverlocation.text);

    lat = result.results!.first.geometry!.location!.lat;
    // lat =18.5667;
    long = result.results!.first.geometry!.location!.lng;
    // long = 73.7822352;

    if(result.results!.isNotEmpty) {
      var data = {
        "receivername": _receivername.text,
        "receivernumber": _receivernumber.text,
        "receiverlocation": _receiverlocation.text,
        "eta": _time.format(context),
        'latitude': lat,
        'longitude': long,
        'note': _note.text
      };

      final Future<Map<String, dynamic>> successfulMessage = Provider.of<
          Applicationbloc>(context, listen: false).postShippingDetails(
          data, 'postshipping');
      successfulMessage.then((response) {
        setState(() {
          showLoading = true;
        });
        if (response['status']) {
          ShippingData trackingDetails = response['trackingDetails'];
          if (Provider
              .of<Applicationbloc>(context, listen: false)
              .shippingStatus == Shipping.ShippingSubmitted) {
            ref = fb.reference();
            print('trackingDetails.trackingId');
            print(trackingDetails.trackingId);
            ref.child(trackingDetails.trackingId).set({
              "location": {
                'latitude': currentLocation.latitude,
                'longitude': currentLocation.longitude
              }
            });
            Provider.of<ShippingDetailsProvider>(context, listen: false)
                .setShippingData(trackingDetails);
            Navigator.pushReplacementNamed(context, '/navigationpage');
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(response['message']),
              backgroundColor: Colors.red));
        }
      });
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter valid location"), backgroundColor: Colors.red));
    }
  }

  _showMessage(message){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message.toString())));
  }

  makePayAsYouGoPayment() async {
    AuthService authService = AuthService();
    var userProvider = Provider.of<UserProvider>(context, listen: false).user;

    var _cvv = userProvider.cardDetails.cvv;
    var expiryMonth = userProvider.cardDetails.expiry_month;
    var expiryYear = userProvider.cardDetails.expiry_year;
    var _last4Digits = 4081;
    var card_number = userProvider.cardDetails.card_no;
    var cardUi = PaymentCard(expiryMonth: expiryMonth, expiryYear: expiryYear, number: card_number, cvc: _cvv.toString() );
    var amount = int.parse(userProvider.payasyougo)*100;
    var email = userProvider.email;
    var tracking_codes = 1;

    Charge charge = Charge()
      ..amount = amount // In base currency
      ..email = email
      ..card = cardUi ;
    charge.reference = _getReference();

    try {
      CheckoutResponse response = await plugin.checkout(
        context,
        method: CheckoutMethod.card,
        charge: charge,
        fullscreen: false,
        // logo: MyLogo(),
      );
      // response.card!.number = _cardNumber;
      print('Response = $response');
      if(response.message == 'Success'){

        var data={
          "_cvc":response.card!.cvc.toString(),
          "expiryMonth":response.card!.expiryMonth.toString(),
          "expiryYear":response.card!.expiryYear.toString(),
          "_type":response.card!.type.toString(),
          "_last4Digits":response.card!.last4Digits.toString(),
          "reference":response.reference.toString(),
          "status":response.reference.toString(),
          "payment_method":response.method.toString(),
          "verify":response.verify.toString(),
          "amount":amount.toString(),
          "tracking_codes":tracking_codes.toString(),
          "card_number":card_number.toString(),
        };
        authService.saveCheckout(data, 'saveCheckout').then((value) {
          if(value.statusCode == 200){
            final user = (json.decode(value.body)['user']);
            User authUser = User.fromJson(user);
            Provider.of<UserProvider>(context, listen: false).setUser(authUser);
            _showMessage("Payment Successfully completed");
            postShippingDetail();
          }else{
            _showMessage("Payment Unsuccessful");
          }
        }
        );
      }
      // _updateStatus(response.reference, '$response');
    } catch (e) {
      // _showMessage("Check console for error");
      rethrow;
    }
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                postShippingDetail();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _showErrorDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Insufficient credit. Go to Payment setting on your profile to add credit/payment card to proceed'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final applicationbloc= Provider.of<Applicationbloc>(context, listen: false);
    final user = Provider.of<UserProvider>(context, listen: false).user;

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: height,
          color: colorConvert('#e1f6ff'),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _receiverformKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                            child: Icon(Icons.arrow_back, size: 40,),
                          onTap: (){
                              Navigator.pop(context);
                          },
                        ),
                        SizedBox(width: width * 0.2,),
                        Text('Shipping Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color:colorConvert('#ec2761')),),
                      ],
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                    SizedBox(height: 8),
                    Align(alignment: Alignment.centerLeft,child: Text('*RECEIVER DETAILS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: colorConvert('#909395')),)),
                    Divider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                    if(viewnamefield)
                    TextFormField(
                      controller:_receivername,
                      enabled: false,
                      textAlignVertical: TextAlignVertical.bottom,
                      textAlign:TextAlign.left,
                        decoration: InputDecoration(
                          hintText: "Receiver's name",
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w400
                          ),
                          suffixIcon: Icon(Icons.account_circle)
                        ),
                      validator: (value) {
                        if (_receivername.text.isEmpty) {
                          return 'Please enter receiver name.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller:_receivernumber,
                      textAlignVertical: TextAlignVertical.bottom,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w400
                          ),
                        hintText: "Mobile number",
                          suffixIcon: FaIcon(FontAwesomeIcons.phoneSquareAlt)
                      ),
                      onChanged: (value) {
                        print('sadf');
                        print(value);
                        applicationbloc.searchUsers(value);
                        setState(() {
                          showUser = true;
                        });
                      },
                      validator: (value) {
                        if (_receivernumber.text.isEmpty) {
                          return 'Please enter receiver number.';
                        }
                        return null;
                      },

                    ),
                    if(applicationbloc.searchuserresults != null && applicationbloc.searchuserresults.length != 0 && showUser)
                      Stack(
                        children:[
                          Container(
                              height:300,
                              width:double.infinity,
                              decoration:BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  backgroundBlendMode: BlendMode.darken
                              )
                          ),
                           Container(
                            height: 300,
                            child: ListView.builder(
                                itemCount: applicationbloc.searchuserresults.length,
                                itemBuilder: (context, index){
                                  return InkWell(
                                    child: ListTile(
                                      title: Text(applicationbloc.searchuserresults[index].username!, style: TextStyle(color: Colors.white),),
                                      subtitle: Text(applicationbloc.searchuserresults[index].phone_number!, style: TextStyle(color: Colors.white),),
                                    ),
                                    onTap: (){
                                      _receivername.text = applicationbloc.searchuserresults[index].username!;
                                      _receivernumber.text = applicationbloc.searchuserresults[index].phone_number!;
                                      setState(() {
                                        viewnamefield = true;
                                        showUser = false;
                                      });
                                    },
                                  );
                                }
                            ),
                          ),
                        ]),

                    SizedBox(height: 25),
                    Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        controller:_receiverlocation,
                        textAlignVertical: TextAlignVertical.bottom,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w400
                          ),
                          hintText: "Drop off location",
                          suffixIcon: Icon(Icons.search)
                      ),
                        validator: (value) {
                          if (_receiverlocation.text.isEmpty) {
                            return 'Please enter drop-off location.';
                          }
                          return null;
                        },

                      onChanged: (value){
                        setState(() {
                          locationloading = true;
                        });
                        applicationbloc.searchPlaces(value).then((value){
                            setState(() {
                              showLocation=true;
                              locationloading = false;
                            });
                        }
                        );
                      }
                    ),
                   ),
                    if(applicationbloc.searchresults != null && applicationbloc.searchresults.length > 0  && showLocation)
                    Stack(
                      children:[
                        Container(
                          height:300,
                          width:double.infinity,
                          decoration:BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              backgroundBlendMode: BlendMode.darken
                          )
                      ),
                        locationloading ? Center(child: CircularProgressIndicator()):Container(
                        height: 300,
                        child: ListView.builder(
                          itemCount: applicationbloc.searchresults.length,
                          itemBuilder: (context, index){
                            return InkWell(
                              child: ListTile(
                                title: Text(applicationbloc.searchresults[index].formattedAddress!, style: TextStyle(color: Colors.white),),
                              ),
                              onTap: (){
                                _receiverlocation.text = applicationbloc.searchresults[index].formattedAddress!;
                                setState(() {
                                  showLocation = false;
                                });
                              },
                            );
                          }
                      ),
                    ),
                ]),
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                    Text('ETA for this delivery'),
                    TextButton(child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(getText(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),),
                      ),
                    ), onPressed: () {
                      selectTime(context);
                    }
    )
                      ],
                    ),
                    SizedBox(height: 15,),
                    Divider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                    SizedBox(height: 10,),
                    Align(alignment: Alignment.centerLeft,child: Text('Additional notes', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20, color: colorConvert('#909395')),)),
                    SizedBox(height: 15,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                    children: [
                      TextFormField(
                        controller:_note,
                        textAlignVertical: TextAlignVertical.bottom,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12
                            ),
                            hintText: "enter additional notes here",
                        ),
                      ),
                      SizedBox(height: height * 0.05,),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: TextButton(
                          child: Text('CONFIRM DETAILS', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300),),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            primary: Colors.white,
                            backgroundColor: colorConvert('#ec2761'),
                          ),
                          onPressed: () {
                            if(_receiverformKey.currentState!.validate()) {
                              var userProvider = Provider
                                  .of<UserProvider>(context, listen: false)
                                  .user;

                              log("==================> ${userProvider.payasyougo}");
                              log("==================> ${userProvider.tracking_codes}");
                              if(userProvider.payasyougo != null){
                              makePayAsYouGoPayment();
                              }else if (
                              userProvider.tracking_codes == null || userProvider
                                  .tracking_codes < 1) {
                                _showErrorDialog();
                              } else {
                                _showMyDialog();
                              }
                            }
                          },
                        ),
                      ),
                    ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
