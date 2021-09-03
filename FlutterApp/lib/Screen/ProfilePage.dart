import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:timetrack/Screen/SignIn.dart';
import 'package:timetrack/blocs/application_bloc.dart';
import 'package:timetrack/blocs/user_bloc.dart';
import 'package:timetrack/constants/constants.dart';
import 'package:timetrack/services/userpreference_service.dart';
import 'package:url_launcher/url_launcher.dart';
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var notification;

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
  void initState() {
    Provider.of<Applicationbloc>(context, listen: false).getLoggedInUser('getUser').then((value){
      if(value.containsKey('user'))
        Provider.of<UserProvider>(context, listen: false).setUser(value['user']);
    });
  }

  final _profileformKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final notificationValue = user.is_notificaction !=null &&  user.is_notificaction== 'true'? true : false;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: height,
          color: colorConvert('#e1f6ff'),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _profileformKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                            child: Icon(Icons.close, size: 30,),
                          onTap: (){
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                    SizedBox(height: height*0.03,),


                    if(user.avatar_name != null)
                      InkWell(
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundImage:NetworkImage("${BASE_URL}profile/profile/${user.avatar_name}"),
                          backgroundColor: Colors.transparent,
                        ),
                        onTap: (){
                          Navigator.pushNamed(context, '/updateprofile');
                        },
                      ),

                    if(user.avatar_name == null)
                      InkWell(
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundImage:AssetImage('assets/images/avatar.png'),
                          backgroundColor: Colors.transparent,
                        ),
                        onTap: (){
                          Navigator.pushNamed(context, '/updateprofile');
                        },
                      ),


                    Text(user.username != null ? user.username : "Kristine Hennessy", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on_rounded),
                        Text(user.location != null ? user.location :'San Franscisco', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),)
                      ],
                    ),
                    SizedBox(height: height*0.02,),
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
                        TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            prefixText: "Phone number ",
                            hintText: user.phone_number != null ? user.phone_number :"+123 456 789 1230",
                            prefixStyle: TextStyle(color: Colors.transparent),
                          ),
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
                        TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            prefixText: "Recovery Email ",
                            hintText: user.email != null ? user.email :"Sample@website.com",
                            prefixStyle: TextStyle(color: Colors.transparent),
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      alignment: Alignment.centerLeft,
                      children: <Widget>[
                        Builder(
                            builder: (context) {
                              return Text(
                                "Password ",
                                style: TextStyle(color: Colors.grey),
                              );
                            }
                        ),
                        TextField(
                          obscureText: true,
                          enabled: false,
                          decoration: InputDecoration(
                            prefixText: "Password ",
                            hintText: "*****************",
                            prefixStyle: TextStyle(color: Colors.transparent),
                          ),
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
                          disabled: true,
                          activeColor: Colors.green,
                          value: notificationValue,
                          onToggle: (val) {
                            setState(() {
                              print(val);
                              notification = val;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: height*0.02,),
                    InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, '/historypage');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("History", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                          Icon(Icons.access_time)
                        ],
                      ),
                    ),
                    SizedBox(height: height*0.02,),
                    InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, '/payemntsettingpage');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Payment Setting", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                          Icon(Icons.credit_card_outlined)
                        ],
                      ),
                    ),
                    SizedBox(height: height*0.02,),
                    InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("How to (FAQ)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color:colorConvert('#ec2761')),)
                        ],
                      ),
                      onTap: () async {
                        await launch("https://toffatrack.com/how-to-faq");
                      },
                    ),
                    SizedBox(height: height*0.08,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(onTap:(){
                          logout();
                        },child: Text("Logout", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),))
                      ],
                    ),
                    Divider(thickness: 2,),
                    SizedBox(height: height*0.12,),
                    InkWell(onTap:(){
                      deleteAccount();
                    },child: Text("Delete Account", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 11, color:colorConvert('#ec2761')),))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void logout() {
    final Future successfulMessage =  Provider.of<Applicationbloc>(context, listen: false).logout('logout');
    successfulMessage.then((response) {
      print(response);
      if (response['status']) {
        UserPreferences().removeToken();
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SignIn()), (route) => false);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message']), backgroundColor: Colors.red));
      }
    });
  }

  void deleteAccount() {
    final Future successfulMessage =  Provider.of<Applicationbloc>(context, listen: false).deleteAccount('deleteAccount');
    successfulMessage.then((response) {
      if (response['status']) {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SignIn()), (route) => false);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message']), backgroundColor: Colors.red));
      }
    });
  }
}
