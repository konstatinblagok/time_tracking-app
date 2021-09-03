
import 'dart:convert';
import 'dart:io';

import 'package:country_codes/country_codes.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:timetrack/blocs/application_bloc.dart';
import 'package:timetrack/blocs/user_bloc.dart';
// import 'package:timetrack/components/custom_switch.dart';
import 'package:timetrack/constants/constants.dart';

class UpdateProfilePage extends StatefulWidget {
  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  var _image;


  Color colorConvert(String color) {
    color = color.replaceAll("#", "");
    if (color.length == 6) {
      return Color(int.parse("0xFF"+color));
    } else if (color.length == 8) {
      return Color(int.parse("0x"+color));
    }
    return Color(0xfff3f3f4);
  }

  updateUser() async{
    File file;
    String? base64avatar;
    String? avatarname;
    if(_image != null){
      File file = File(_image.path!);
      base64avatar = base64Encode(file.readAsBytesSync());
      avatarname = _image.path.split("/").last;
    }

    var data= {
      "username" : _username.text.toString(),
      'avatar_name': avatarname,
      'avatar': base64avatar,
      "phone_number" : _phoneno.text.toString(),
      "location" : _location.text.toString(),
      "email" : _email.text.toString(),
      "is_notification" : notification.toString(),
    };

    await Provider.of<Applicationbloc>(context, listen: false).update(data, 'updateProfile').then((response){
      if (response['status']) {
        Provider.of<UserProvider>(context, listen: false).setUser(response['user']);
        Navigator.pushNamed(context, '/profilepage');
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message']), backgroundColor: Colors.red));
      }
    });
  }

  _showMessage(String message,
      [Duration duration = const Duration(seconds: 4)]) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(message),
      duration: duration,
      action: new SnackBarAction(
          label: 'CLOSE',
          onPressed: () =>
              ScaffoldMessenger.of(context).removeCurrentSnackBar()),
    ));
  }
  _imgFromCamera() async {
    final image = await ImagePicker.platform.pickImage(
        source: ImageSource.camera,
    );

    setState(() {
      _image = image! ;
    });
  }

  _imgFromGallery() async {
    final image = (await  ImagePicker.platform.pickImage(
        source: ImageSource.gallery,
    )) ;

    setState(() {
      _image = image!;
    });
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  ListTile(
                    title: Text('Choose Profile Photo', style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  final _updateprofileKey = GlobalKey<FormState>();

  TextEditingController _username = TextEditingController();
  TextEditingController _phoneno = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _location = TextEditingController();

  bool showLocation = false;
  bool notification = false;

  @override
  void initState() {
    Provider.of<Applicationbloc>(context, listen: false).getLoggedInUser('getUser').then((value){
      Provider.of<UserProvider>(context, listen: false).setUser(value['user']);
    });
    final userbloc= Provider.of<UserProvider>(context, listen: false);

    if(userbloc.user.username != null && userbloc.user.email != null && userbloc.user.location != null && userbloc.user.phone_number != null){
      _username.text  = userbloc.user.username;
      _email.text     = userbloc.user.email;
      _location.text  = userbloc.user.location;
      _phoneno.text   = userbloc.user.phone_number;
      notification    = userbloc.user.is_notificaction != null && userbloc.user.is_notificaction != 'false'  ? true : false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final applicationbloc= Provider.of<Applicationbloc>(context, listen: false);
    final userbloc= Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: height,
          color: colorConvert('#e1f6ff'),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _updateprofileKey,
              child: SingleChildScrollView(
                child:
                applicationbloc.registeredInStatus == Status.Registering? Center(child: CircularProgressIndicator(),):
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(child: Icon(Icons.close, size: 30,), onTap: (){
                          Navigator.pop(context);
                        },)
                      ],
                    ),

                    SizedBox(height: height*0.03,),

                    Stack(
                      children: [
                        _image == null ?
                        userbloc.user.avatar_name != null ?  CircleAvatar(
                          radius: 50.0,
                          backgroundImage:NetworkImage("${BASE_URL}profile/profile/${userbloc.user.avatar_name}"),
                          backgroundColor: Colors.transparent,
                        ):CircleAvatar(
                          radius: 60,
                          child: Image.asset('assets/images/avatar.png'),
                          // backgroundImage: AssetImage('assets/images/avatar.png'),
                        ): CircleAvatar(
                          radius: 60,
                          backgroundImage: FileImage(File(_image.path)),
                        ) ,
                        Positioned(
                          bottom: 10,
                            right: 20,
                            child: InkWell(
                              onTap: (){
                                    _showPicker(context);
                              },
                              child: Icon(Icons.camera_alt,
                        size: 28,
                        ),
                            ))
                      ],
                    ),

                    Text("Upload Avatar", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),

                    SizedBox(height: height*0.02,),

                    Stack(
                      alignment: Alignment.centerLeft,
                      children: <Widget>[
                        Builder(
                            builder: (context) {
                              return Text(
                                'User Name ',
                                style: TextStyle(color: Colors.grey),
                              );
                            }
                        ),
                        TextFormField(
                          controller:_username,
                          decoration: InputDecoration(
                            prefixText: "User Name ",
                            hintText: "Kristine Henessy",
                            prefixStyle: TextStyle(color: Colors.transparent),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter name';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),

                    Stack(
                      alignment: Alignment.centerLeft,
                      children: <Widget>[
                        Builder(
                            builder: (context) {
                              return Text(
                                'Location ',
                                style: TextStyle(color: Colors.grey),
                              );
                            }
                        ),
                        TextFormField(
                          controller:_location,
                          maxLines:1,
                          decoration: InputDecoration(
                            prefixText: "Location ",
                            hintText: "San Fransisco",
                            prefixStyle: TextStyle(color: Colors.transparent),
                          ),
                          onChanged: (value){
                             applicationbloc.searchCity(value);
                             setState(() {
                               showLocation = true;
                             });
                          },
                          validator: (value) {
                            print('here');
                            print(applicationbloc.searchcityresults.length);
                            if (_location.text.isEmpty) {
                              return 'Please Enter Location';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),

                    if(applicationbloc.searchcityresults != null && applicationbloc.searchcityresults.length != 0 && showLocation)
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
                                  itemCount: applicationbloc.searchcityresults.length,
                                  itemBuilder: (context, index){
                                    return InkWell(
                                      child: ListTile(
                                        title: Text(applicationbloc.searchcityresults[index].description, style: TextStyle(color: Colors.white),),
                                      ),
                                      onTap: (){
                                        setState(() {
                                          showLocation = false;
                                        });
                                        _location.text = applicationbloc.searchcityresults[index].description;
                                      },
                                    );
                                  }
                              ),
                            ),
                          ]),

                    Stack(
                      alignment: Alignment.centerLeft,
                      children: <Widget>[
                        Builder(
                            builder: (context) {
                              return Text(
                                'Phone number ',
                                style: TextStyle(color: Colors.grey),
                              );
                            }
                        ),
                        TextFormField(
                          controller:_phoneno,
                          inputFormatters: [DialCodeFormatter()],
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            prefixText: "Phone number ",
                            hintText: "+123 456 789 1230",
                            prefixStyle: TextStyle(color: Colors.transparent),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Phone number';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),

                    Stack(
                      alignment: Alignment.centerLeft,
                      children: <Widget>[
                        Builder(
                            builder: (context) {
                              return Text(
                                'Recovery Email ',
                                style: TextStyle(color: Colors.grey),
                              );
                            }
                        ),
                        TextFormField(
                          controller: _email,
                          decoration: InputDecoration(
                            prefixText: "Recovery Email ",
                            hintText: "Sample@website.com",
                            prefixStyle: TextStyle(color: Colors.transparent),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty || !(EmailValidator.validate(value)) ) {
                              return 'Please enter valid email ';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),


                    SizedBox(height: height*0.02,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Notifications", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                        FlutterSwitch(
                          width: 45.0,
                          height: 25.0,
                          activeColor: Colors.green,
                          value: notification,
                          onToggle: (val) {
                            setState(() {
                              notification = val;
                            });
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: height*0.02,),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: TextButton(
                        // child: applicationbloc.registeredInStatus == Status.Registering ? CircularProgressIndicator() : Text('Sign Up', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300),),
                        child: Text('Update', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300),),
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: colorConvert('#ec2761'),
                        ),
                        onPressed: () {
                          if(_updateprofileKey.currentState!.validate()){
                            updateUser(); print(applicationbloc.registeredInStatus);
                          }
                        },
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






