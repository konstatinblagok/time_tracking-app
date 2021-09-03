import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:provider/provider.dart';
import 'package:timetrack/Screen/SelectionPage.dart';
import 'package:timetrack/blocs/application_bloc.dart';
import 'package:timetrack/blocs/shippingdata_bloc.dart';
import 'package:timetrack/blocs/user_bloc.dart';
import 'package:timetrack/constants/constants.dart';
import 'package:timetrack/models/User.dart' as modelUser;
import 'package:timetrack/services/userpreference_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OtpPage extends StatefulWidget {

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {

var loading = false;
  Color colorConvert(String color) {
    color = color.replaceAll("#", "");
    if (color.length == 6) {
      return Color(int.parse("0xFF"+color));
    } else if (color.length == 8) {
      return Color(int.parse("0x"+color));
    }
    return Color(0xfff3f3f4);
  }

  final _otpformKey = GlobalKey<FormState>();

  var token;

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> saveTokenToDatabase(String token) async {
    // Assume user is logged in for this example
    String userId = Provider.of<UserProvider>(context, listen: false).user.phone_number;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({
      'tokens': FieldValue.arrayUnion([token]),
    });
  }

  @override
  void initState() {

    UserPreferences().getToken().then((value) {

        setState(() {
          token = value!;
        });

    });

    print("token===>$token");
    if(token != null){
      Navigator.pushNamedAndRemoveUntil(context, '/selectionpage', (route) => false);
    }
   verifyPhone();

  }


  String? verificationCompleted;
  String? verificationFailed;
  String? codeAutoRetrievalTimeout;
  var _verificationCode;
  var _verificationID;

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
 late String _verificationId;



  verifyPhone() async{
    var phone_no = Provider.of<UserProvider>(context, listen: false).phone_number;
    print("sadfasdfasd");
    print(phone_no.toString());
    await FirebaseAuth.instance.verifyPhoneNumber(
     phoneNumber: phone_no.toString(),
      // phoneNumber: "+917654321097",
      verificationCompleted: (PhoneAuthCredential credential) {
          print('complete verified');
          var data= {
                  "phone_number" : phone_no.toString(),
                };
          final Future<Map<String, dynamic>> successfulMessage =  Provider.of<Applicationbloc>(context, listen: false).verifyotp(data, 'verify-phone');
          successfulMessage.then((response) {

            if (response['status']) {
              var user = response['user'];
              print("in if part");
              Provider.of<UserProvider>(context, listen: false).setUser(user);
                    // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SelectionPage()), (route) => false);
                  } else {
              print("in else part");
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message']), backgroundColor: Colors.red));
                  }
          });
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Error verified');
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        print('Code Sent');
        print("code ${verificationId} " );
        print("ver code " +_verificationCode.toString());
        setState(() {
          _verificationID = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('Code Retrieed ${_verificationID}');
        setState(() {
          verificationId = verificationId;
        });
      },

    );
  }


  @override
  Widget build(BuildContext context) {
    final BoxDecoration pinPutDecoration = BoxDecoration(
      color: const Color.fromRGBO(43, 46, 66, 1),
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(
        color: const Color.fromRGBO(126, 203, 224, 1),
      ),
    );

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final applicationbloc= Provider.of<Applicationbloc>(context, listen: false);
    final _pinPutController = TextEditingController();
    final _pinPutFocusNode = FocusNode();

    verify() async{
      print("iin verify...");
      setState(() {
        loading = true;
      });
      var data;
      late FormData d;
      var phone_no = Provider.of<UserProvider>(context, listen: false).phone_number;
      if(Provider.of<Applicationbloc>(context, listen: false).registeredInStatus == Status.Registering || Provider.of<Applicationbloc>(context, listen: false).registeredInStatus == Status.NotRegistered)
      {
        print("in if condition");
        String? fcmToken = await _fcm.getToken(vapidKey: VAPIDKEY);
        // d = FormData.fromMap({
        //   "phone_number" : phone_no.toString(),
        //   "fcmToken": fcmToken.toString()
        // });
           data= {
            "phone_number" : phone_no.toString(),
            "fcmToken": fcmToken.toString()
          };
      }else{
        print("in else condition");
        // d = FormData.fromMap({
        //   "phone_number" : phone_no.toString(),
        // });
         data = {
          "phone_number" : phone_no.toString(),
        };
      }
      final Future<Map<String, dynamic>> successfulMessage =  Provider.of<Applicationbloc>(context, listen: false).verifyotp(data, 'verify-phone');
      successfulMessage.then((response) {
      print("message is success -- ${response}");
        setState(() {
          loading=false;
        });
        if (response['status']) {
          var user = response['user'];
          final shippingProvider = Provider.of<ShippingDetailsProvider>(context, listen: false);
          if(shippingProvider.trackingId != null){
            var screen = shippingProvider.screen;
            if(screen != null){
              Navigator.pushNamedAndRemoveUntil(context, "${screen}", (route) => false);
            }
          }
          Provider.of<UserProvider>(context, listen: false).setUser(user);
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SelectionPage()), (route) => false);

        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message']), backgroundColor: Colors.red));
        }
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: height,
          color: colorConvert('#e1f6ff'),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _otpformKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: height * 0.15),
                    Image.asset('assets/images/120.png'),
                    SizedBox(height: height * 0.1),
                    SizedBox(height: 15,),

                     Text("Please enter the OTP sent to your mobile",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: PinPut(
                    fieldsCount: 6,
                    withCursor: true,
                    textStyle: const TextStyle(fontSize: 25.0, color: Colors.white),
                    eachFieldWidth: 40.0,
                    eachFieldHeight: 55.0,

                    focusNode: _pinPutFocusNode,
                    controller: _pinPutController,
                    submittedFieldDecoration: pinPutDecoration,
                    selectedFieldDecoration: pinPutDecoration,
                    followingFieldDecoration: pinPutDecoration,
                    pinAnimationType: PinAnimationType.fade,
                    onSubmit: (String pin) async {
                      print('sdafds');
                      print(_verificationID);
                      print(pin);
                      try {
                        await FirebaseAuth.instance.signInWithCredential(
                          PhoneAuthProvider.credential(verificationId: _verificationID, smsCode: pin),
                          // PhoneAuthProvider.credential(verificationId: 'AJOnW4SELGjV8YcrdnY3Htk2dlE9-_KdXnFiDYa39jo8jRFgzJemYm2dyCshztRgMDZMXjMUBsOco9MB5IWiWK_pTcnkjtlp6Fs-daKEhIOSUNxVbSPbTW2jeqqDDOJ9AWxjrpt0aaPgNoNdnnoT5kdeFsmSvuTLVg', smsCode: pin),
                        )
                            .then((value) async {
                              print('12321324234112344234');
                              print('check');
                              print(value.user);
                          if (value.user != null) {
                            verify();
                          }
                        });
                      } catch (e) {
                        FocusScope.of(context).unfocus();
                        print('error is --${e}');
                        showSnackBar('error mess -- ${e}');
                        // showSnackBar("Invalid OTP 123");
                      }
                    },
                  ),
                ),




                    // Container(
                    //   child: loading ? Center(child: CircularProgressIndicator(),):  Column(
                    //     children: [
                    //       Text('Please enter the OTP sent to your mobile',
                    //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    //       ),
                    //
                    //       SizedBox(height: 10,),
                    //
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //         children: [
                    //           Container(
                    //             width: width * 0.2,
                    //             child: TextField(
                    //               controller: _otp1,
                    //               focusNode: _otp1FocusNode,
                    //               maxLength: 1,
                    //               keyboardType: TextInputType.number,
                    //               decoration: InputDecoration(
                    //                   counterText: "",
                    //                   border: OutlineInputBorder(
                    //                       borderSide : BorderSide(color: colorConvert('#adb0ae'))
                    //                   ),
                    //                   fillColor: Color(0xffffffff),
                    //                   filled: true
                    //               ),
                    //               onChanged: (value) {
                    //                 FocusScope.of(context).requestFocus(_otp2FocusNode);
                    //               },
                    //             ),
                    //           ),
                    //           Container(
                    //             width: width * 0.2,
                    //             child: TextField(
                    //               controller: _otp2,
                    //               focusNode: _otp2FocusNode,
                    //               maxLength: 1,
                    //               keyboardType: TextInputType.number,
                    //               decoration: InputDecoration(
                    //                   counterText: "",
                    //                   border: OutlineInputBorder(
                    //                       borderSide : BorderSide(color: colorConvert('#adb0ae'))
                    //                   ),
                    //                   fillColor: Color(0xffffffff),
                    //                   filled: true
                    //               ),
                    //               onChanged: (value) {
                    //                 FocusScope.of(context).requestFocus(_otp3FocusNode);
                    //               },
                    //             ),
                    //           ),
                    //           Container(
                    //             width: width * 0.2,
                    //             child: TextField(
                    //               controller: _otp3,
                    //               focusNode: _otp3FocusNode,
                    //               maxLength: 1,
                    //               keyboardType: TextInputType.number,
                    //               decoration: InputDecoration(
                    //                   counterText: "",
                    //                   border: OutlineInputBorder(
                    //                       borderSide : BorderSide(color: colorConvert('#adb0ae'))
                    //                   ),
                    //                   fillColor: Color(0xffffffff),
                    //                   filled: true
                    //               ),
                    //               onChanged: (value) {
                    //                 // if(_otp1.text.isNotEmpty && _otp2.text.isNotEmpty && _otp3.text.isNotEmpty && _otp4.text.isNotEmpty ){
                    //                 //   verify();
                    //                 //   if(applicationbloc.otpStatus == Status.OtpVerified){
                    //                 //     Navigator.pushNamed(context, '/selectionpage');
                    //                 //   };
                    //                 // }else{
                    //                 //   SnackBar(content: Text('asfdsa'),);
                    //                 // }
                    //                 FocusScope.of(context).requestFocus(_otp4FocusNode);
                    //               },
                    //             ),
                    //           ),
                    //           Container(
                    //             width: width * 0.2,
                    //             child: TextField(
                    //               controller: _otp4,
                    //               focusNode: _otp4FocusNode,
                    //               maxLength: 1,
                    //               keyboardType: TextInputType.number,
                    //               decoration: InputDecoration(
                    //                   counterText: "",
                    //                   border: OutlineInputBorder(
                    //                       borderSide : BorderSide(color: colorConvert('#adb0ae'))
                    //                   ),
                    //                   fillColor: Color(0xffffffff),
                    //                   filled: true
                    //               ),
                    //               // onChanged: (value) {
                    //               //   if(_otp1.text.isNotEmpty && _otp2.text.isNotEmpty && _otp3.text.isNotEmpty && _otp4.text.isNotEmpty ){
                    //               //     verify();
                    //               //   }
                    //               // },
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //
                    //       SizedBox(
                    //         height: 10,
                    //       ),
                    //       InkWell(
                    //         child: Align(
                    //           alignment: Alignment.centerRight,
                    //           child: Text('Resend OTP',
                    //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    //           ),
                    //         ),
                    //         onTap: () async {
                    //           var phone_number = Provider.of<UserProvider>(context, listen: false).phone_number;
                    //           var data= {
                    //             "phone_number" : phone_number.toString(),
                    //           };
                    //           await Provider.of<Applicationbloc>(context, listen: false).signIn(data, 'login');
                    //         },
                    //       ),
                    //
                    //       Container(
                    //         width: MediaQuery.of(context).size.width,
                    //         padding: EdgeInsets.symmetric(vertical: 15),
                    //         child: TextButton(
                    //           child: Text('Verify', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300),),
                    //           style: TextButton.styleFrom(
                    //             primary: Colors.white,
                    //             backgroundColor: colorConvert('#ec2761'),
                    //           ),
                    //           onPressed: () {
                    //               verify();
                    //           },
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showSnackBar(message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message.toString()), backgroundColor: Colors.red));
  }
}

