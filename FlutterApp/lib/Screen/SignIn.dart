import 'dart:developer';

import 'package:country_codes/country_codes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:timetrack/blocs/application_bloc.dart';
import 'package:timetrack/blocs/user_bloc.dart';
import 'package:timetrack/constants/constants.dart';


class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {


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
    fcm();
    initializeContryCodes();

  }
fcm ()async{
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  String? fcmToken = await _fcm.getToken(vapidKey: VAPIDKEY);

  log("FCM=============== $fcmToken");
}
  initializeContryCodes() async{
    await CountryCodes.init();
  }

  var loading = false;

  signInUser() async{
    var data= {
      "phone_number" : _phoneno.text.toString(),
    };
  print("data is -- ${data.values}");
    setState(() {
      loading =true;
    });
    await Provider.of<Applicationbloc>(context, listen: false).signIn(data, 'login').then((response){
      print('check');
      setState(() {
        loading =false;
      });
      print('response -- ${response.values}');
      if (response['status'] && Provider.of<Applicationbloc>(context, listen: false).loggedInStatus == Status.LoggedIn) {
        Provider.of<UserProvider>(context, listen: false).setPhoneNumber(_phoneno.text.toString());
        Navigator.pushNamed(context, '/otppage');
      }else{
        print(response);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message']), backgroundColor: Colors.red));
      }
    }).catchError((response){
      setState(() {
        loading =false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Something went wrong'), backgroundColor: Colors.red));
    });
  
  }


  @override
  void dispose() {
    _phoneno.dispose();
    super.dispose();
  }

  TextEditingController _phoneno = TextEditingController();

  final _signInformkey = GlobalKey<FormState>();
  var token;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final applicationProvider = Provider.of<Applicationbloc>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        body:  Container(
          height: height,
          color: colorConvert('#e1f6ff'),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: loading ? Center(child: CircularProgressIndicator(),): SingleChildScrollView(
              child:  Column(
                children:<Widget>[
                  SizedBox(height: height * 0.2),
                  Image.asset('assets/images/120.png'),
                  SizedBox(height: height * 0.1),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                          fontSize: 25.0,
                          fontWeight:FontWeight.bold
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Container(
                    child: Form(
                      key: _signInformkey,
                      child: Column(
                        children: [
                          Align(
                            alignment:Alignment.centerLeft,
                             child: Text('Mobile number',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              )
                          )
                          ,
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            // inputFormatters: [DialCodeFormatter()],
                            controller: _phoneno,
                            decoration: InputDecoration(
                                hintText: '+xxx xxxx xxxx xxx',
                              border: OutlineInputBorder(
                                borderSide : BorderSide(color: colorConvert('#adb0ae'))
                              ),
                              fillColor: Color(0xffffffff),
                              filled: true
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a valid Phone number.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: colorConvert('#ec2761'),
                              ),
                              child: Text('Sign In', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300),),
                              onPressed: () {
                                _signInformkey.currentState!.save();
                                if(_signInformkey.currentState!.validate()){
                                  signInUser();
                                }
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Forgot Password?', style: TextStyle(fontWeight: FontWeight.bold, fontSize:17,),),
                              InkWell(child: Text('Sign Up', style: TextStyle(fontWeight: FontWeight.bold, fontSize:17,  color:colorConvert('#ec2761')),),
                              onTap: (){
                                Navigator.pushNamed(context, '/signup');
                              },
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

