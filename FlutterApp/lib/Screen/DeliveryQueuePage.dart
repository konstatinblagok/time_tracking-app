import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetrack/blocs/application_bloc.dart';
import 'package:timetrack/blocs/shippingdata_bloc.dart';
import 'package:timetrack/components/slide_button.dart';
import 'package:timetrack/models/shipping_details.dart';
import 'package:timetrack/services/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DeliveryQueuePage extends StatefulWidget {

  @override
  _DeliveryQueuePageState createState() => _DeliveryQueuePageState();
}

class _DeliveryQueuePageState extends State<DeliveryQueuePage> {

  final AuthService shippingService = AuthService();

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


  void _showPicker(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 50,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(alignment:Alignment.centerLeft,child: Text("Tracking ID:${selectedShipping!.trackingId}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),)),
                    ),
                    SizedBox(height: 15,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on, size: 25,),
                          SizedBox(width: width* 0.02,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container( width: width * 0.8, child: Text('Drop off ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                              Container(
                                width: width * 0.8,
                                  child: Text("${selectedShipping!.location}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.1),
                    SlideButton(
                      height: height * 0.08,
                      slidingChild: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                            width: width,

                            padding: EdgeInsets.all(12.0) ,
                            decoration: BoxDecoration(
                              boxShadow:[ BoxShadow(color:Colors.white)],
                                borderRadius: BorderRadius.circular(10),
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                                decoration: BoxDecoration(
                                    color: colorConvert("#ec2761"),
                                    shape: BoxShape.circle
                                ),
                                child: Icon(Icons.chevron_right, color: Colors.white,)
                            )
                        ),
                      ),
                      borderRadius: 60,
                      backgroundColor: Colors.pinkAccent,
                      backgroundChild: Center(
                        child: Text("ARRIVED DROP LOCATION", style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),
                      ),
                      slideDirection: SlideDirection.RIGHT,
                      onButtonOpened: () async {
                        Navigator.of(context).pop();
                        _showArrivalDialog();
                      }, slidingBarColor: null,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  _showArrivalDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("Are You sure?"),
          actions: [
            InkWell(
                child: Text('Confirm'),
              onTap: () async {
                var data= {
                  "phone_number" : selectedShipping!.phoneNumber.toString(),
                  "tracking_code" : selectedShipping!.trackingId.toString(),
                };
                await shippingService.updateShippingStatus(data, 'updateShippingStatus').then((response){
                  if(response['status']){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Shipping has arrived."), backgroundColor: Colors.red));
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message']), backgroundColor: Colors.red));
                  }
                  Navigator.of(context).pop();
                });

              },
            ),

            InkWell(
              child: Text('Cancel'),
              onTap: (){
                Navigator.of(context).pop();
              },
            ),
          ],

        );
      },
    );
  }

  _showMessageDialog(phone_number) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                  child: Icon(Icons.forward_to_inbox, size: 45,),
              onTap: (){
                url ='sms:${phone_number}';
                launch(url);
                Navigator.of(context).pop();
              },
              ),
              InkWell(child: Icon(Icons.call, size: 45,),
              onTap: (){
                url ="tel:${phone_number}";
                print(url);
                launch(url);
                Navigator.of(context).pop();
              },
              ),
            ],
          ),

        );
      },
    );
  }

  clearQueue() async{
    await Provider.of<Applicationbloc>(context, listen: false).clearQueue('clearqueue').then((response){
      if (response['status']) {
        setState(() {

        });
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message']), backgroundColor: Colors.red));
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: height,
          color: colorConvert('#e1f6ff'),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        child: Icon(Icons.account_circle_rounded, size: 35,),
                        onTap:(){
                          Navigator.pushNamed(context, '/profilepage');
                        }
                    ),
                    InkWell(
                        child: FaIcon(FontAwesomeIcons.eraser, size: 32,),
                        onTap:(){
                          clearQueue();
                        }
                    )
                  ],
                ),
                SizedBox(height: 15,),
                Align(alignment:Alignment.center,child: Text('Delivery Queue', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorConvert('#ec2761')),)),
                SizedBox(height: 15,),
                FutureBuilder(
                  future: shippingService.getShippingList('shippinglist'),
                  builder: (BuildContext context, AsyncSnapshot<List<ShippingData>> snapshot){
                   if(snapshot.hasData) {
                     return snapshot.data!.length < 1 ? Text("No data Found") :ListView.builder(
                         itemCount: snapshot.data!.length,
                         scrollDirection: Axis.vertical,
                         primary: false,
                         shrinkWrap: true,
                         itemBuilder: (context, index) {
                           ShippingData shp = snapshot.data![index];
                           return Container(
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Padding(
                                   padding: const EdgeInsets.all(8.0),
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment
                                         .spaceBetween,
                                     children: [
                                       InkWell(
                                         child: Text(shp.receiverName.toString(),
                                           style: TextStyle(
                                               fontWeight: FontWeight.bold,
                                               fontSize: 15),),
                                         onTap: (){
                                           selectedShipping = snapshot.data![index];
                                           _showPicker(context);
                                         },
                                       ),
                                       InkWell(
                                         child: Text(shp.phoneNumber.toString(), style: TextStyle(
                                             fontWeight: FontWeight.bold,
                                             fontSize: 15),),
                                         onTap: (){
                                           _showMessageDialog(shp.phoneNumber);
                                         },
                                       ),
                                     ],
                                   ),
                                 ),
                                 Padding(
                                   padding: const EdgeInsets.symmetric(
                                       horizontal: 8.0),
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment
                                         .spaceBetween,
                                     children: [
                                       Text("Drop Off Location:",
                                         style: TextStyle(
                                           fontWeight: FontWeight.w200,),),
                                       Text(shp.status == 0 ? "In progress" : "Delivered", style: TextStyle(
                                           fontWeight: FontWeight.bold,
                                           fontSize: 15,
                                           color: shp.status == 0 ? colorConvert('#ec2761'): Colors.green),),
                                     ],
                                   ),
                                 ),
                                 Padding(
                                   padding: const EdgeInsets.symmetric(
                                       horizontal: 8.0),
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment
                                         .spaceBetween,
                                     children: [
                                       Container(
                                         width: width * 0.6,
                                         child: InkWell(
                                           child: Text(
                                             shp.location.toString(),
                                             style: TextStyle(
                                               fontWeight: FontWeight.w200,),),
                                           onTap: (){
                                             selectedShipping = snapshot.data![index];
                                             Provider.of<ShippingDetailsProvider>(context, listen: false).setShippingData(selectedShipping!);
                                             Navigator.pushReplacementNamed(context, '/');
                                           },
                                         ),
                                       ),
                                     ],
                                   ),
                                 ),
                                 Divider(thickness: 1,)
                               ],
                             ),
                           );
                         });
                   }else{
                     return Center(child: CircularProgressIndicator());
                   }
                  },

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
