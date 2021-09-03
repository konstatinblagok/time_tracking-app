import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timetrack/blocs/application_bloc.dart';
import 'package:timetrack/blocs/shippingdata_bloc.dart';
import 'package:timetrack/components/slide_button.dart';
import 'package:timetrack/models/shipping_details.dart';
import 'package:timetrack/services/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HistoryPage extends StatefulWidget {

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  final AuthService historyService = AuthService();

  Color colorConvert(String color) {
    color = color.replaceAll("#", "");
    if (color.length == 6) {
      return Color(int.parse("0xFF"+color));
    } else if (color.length == 8) {
      return Color(int.parse("0x"+color));
    }
    return Color(0xfff3f3f4);
  }

  var url;
  var receiver_id;
  ShippingData? selectedShipping;


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: height,
          color: colorConvert('#e1f6ff'),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Stack(
                children:[
                  Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(child: FaIcon(FontAwesomeIcons.arrowLeft), onTap: (){
                              Navigator.pop(context);
                            },)
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 15,),
                    Align(alignment:Alignment.center,child: Text('Tracking History', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),)),
                    SizedBox(height: 15,),
                    FutureBuilder(
                      future: historyService.getShippingHistory('shippinghistory'),
                      builder: (BuildContext context, AsyncSnapshot<List<ShippingData>> snapshot){
                        if(snapshot.hasData) {
                          return ListView.separated(
                              itemCount: snapshot.data!.length,
                              scrollDirection: Axis.vertical,
                              primary: false,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                ShippingData shp = snapshot.data![index];
                                print('snapshot.data![index]');
                                print(snapshot.data![index]);
                                return ListTile(
                                  leading: FaIcon(FontAwesomeIcons.certificate, size: 35, color: Colors.black,),
                                  title: Text("Track ID: ${shp.trackingId}"),
                                  subtitle: Text("${shp.eTA}"),
                                );
                              }, separatorBuilder: (BuildContext context, int index) { return Divider(); },);
                        }else{
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    )
                  ],
                ),
                  Positioned(
                    top: height * 0.7,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: TextButton(
                        child: Text('Clear History', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300),),
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: colorConvert('#ec2761'),
                        ),
                        onPressed: () {
                          clearHistory();
                        },
                      ),
                    ),
                  ),
                ]
              ),
            ),
          ),
        ),
      ),
    );
  }

  void clearHistory() {
    final Future successfulMessage =  Provider.of<Applicationbloc>(context, listen: false).clearHistory('clearhistory');
    successfulMessage.then((response) {
      if (response['status']) {
        Navigator.pushReplacementNamed(context, '/profilepage');
      }
    });
  }
}
