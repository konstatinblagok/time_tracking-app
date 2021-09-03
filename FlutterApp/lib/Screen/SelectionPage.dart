import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetrack/constants/constants.dart';
import 'package:timetrack/blocs/user_bloc.dart';
import 'package:timetrack/services/userpreference_service.dart';

class SelectionPage extends StatefulWidget {
  @override
  _SelectionPageState createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  Color colorConvert(String color) {
    color = color.replaceAll("#", "");
    if (color.length == 6) {
      return Color(int.parse("0xFF"+color));
    } else if (color.length == 8) {
      return Color(int.parse("0x"+color));
    }
    return Color(0xfff3f3f4);
  }
  var token;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final user = Provider.of<UserProvider>(context, listen: false).user;

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: height,
          color: colorConvert('#e1f6ff'),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
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
                  SizedBox(height: height*0.04,),
                  Container(child: Image.asset('assets/images/map.jpeg'), height: height*0.6, width: width,),
                  SizedBox(height: height*0.05,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: width * 0.4,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                            primary: Colors.white,
                            backgroundColor: colorConvert('#ec2761'),
                          ),
                          child: Text('SEND ITEM', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300),),
                          onPressed: () {
                            Navigator.pushNamed(context, '/shippingdetailspage');
                          },
                        ),
                      ),
                      Container(
                        width: width * 0.4,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                            primary: Colors.white,
                            backgroundColor: colorConvert('#ec2761'),
                          ),
                          child: Text('TRACK ITEM', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300),),
                          onPressed: () {
                            Navigator.pushNamed(context, '/recevertrackingpage');
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
