import 'package:country_codes/country_codes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:timetrack/blocs/application_bloc.dart';
import 'package:timetrack/blocs/user_bloc.dart';


class NoInternetPage extends StatefulWidget {
  @override
  _NoInternetPageState createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {

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
  void dispose() {
    super.dispose();
  }

  var loading;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
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
                  Text("Please turn on. Internet Connection",  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight:FontWeight.bold
                  ),)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

