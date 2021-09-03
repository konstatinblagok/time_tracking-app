import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:provider/provider.dart';
import 'package:timetrack/blocs/tracking_codes.dart';
import 'package:timetrack/models/card_details.dart';
import 'package:timetrack/models/tracking_codes.dart';
import 'package:timetrack/services/auth_service.dart';

class PaymentSettingPage extends StatefulWidget {
  @override
  _PaymentSettingPageState createState() => _PaymentSettingPageState();
}

class _PaymentSettingPageState extends State<PaymentSettingPage> {
  AuthService authService = AuthService();

  List paymentData=[
    new TrackingCodes(price: 250, no_tracking_codes: 5, message: "5 Tracking Codes/N250"),
    new TrackingCodes(price: 500, no_tracking_codes: 10, message: "10 Tracking Codes/N500"),
    new TrackingCodes(price: 1000, no_tracking_codes: 20, message: "20 Tracking Codes/N1000"),
    new TrackingCodes(price: 50,  no_tracking_codes: 1, message: "Pay as you go/N50", isPayAsYouGo: true)
  ];

  Color colorConvert(String color) {
    color = color.replaceAll("#", "");
    if (color.length == 6) {
      return Color(int.parse("0xFF"+color));
    } else if (color.length == 8) {
      return Color(int.parse("0x"+color));
    }
    return Color(0xfff3f3f4);
  }

  final _verticalSizeBox = const SizedBox(height: 20.0);
  String? _cardNumber;
  String? _cvv;
  int? _expiryMonth;
  int? _expiryYear;
  final _horizontalSizeBox = const SizedBox(width: 10.0);
  bool isloading = false;

  bool checkboxValue1 = false;
  bool checkboxValue2 = false;
  bool checkboxValue3 = false;
  bool checkboxValue4 = true;
  final _cardFormKey = GlobalKey<FormState>();

  Future<void> _showMyDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Card'),
          content: SingleChildScrollView(
              child:Form(
                key: _cardFormKey,
                child: Column(
                  children: [
                    new TextFormField(
                      inputFormatters: [
                        CreditCardNumberInputFormatter(),
                      ],
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: const UnderlineInputBorder(),
                        labelText: 'Card number',
                      ),
                      onSaved: (String? value) { setState(() {
                        _cardNumber = value;
                      });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Valid Card Number';
                        }
                        return null;
                      },

                    ),
                    _verticalSizeBox,
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Expanded(
                          child: new TextFormField(
                            inputFormatters: [
                              CreditCardCvcInputFormatter(),
                            ],
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: const UnderlineInputBorder(),
                              labelText: 'CVV',
                            ),
                            onSaved: (String? value){
                              _cvv = value;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Valid CVV';
                              }
                              return null;
                            },
                          ),
                        ),
                        _horizontalSizeBox,
                        new Expanded(
                          child: new TextFormField(
                            decoration: const InputDecoration(
                              border: const UnderlineInputBorder(),
                              labelText: 'Expiry Month',
                            ),
                            keyboardType: TextInputType.number,
                            onSaved: (String? value) =>
                            _expiryMonth = int.tryParse(value ?? ""),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Valid Expiry Month';
                              }
                              return null;
                            },
                          ),
                        ),
                        _horizontalSizeBox,
                        new Expanded(
                          child: new TextFormField(
                            decoration: const InputDecoration(
                              border: const UnderlineInputBorder(),
                              labelText: 'Expiry Year',
                            ),
                            keyboardType: TextInputType.number,
                            onSaved: (String? value) =>
                            _expiryYear = int.tryParse(value ?? ""),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Valid Expiry Year';
                              }
                              return null;
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                _cardFormKey.currentState!.validate();
                _cardFormKey.currentState!.save();
                saveCard();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  saveCard(){
    setState(() {
      isloading = true;
    });
    var data= {
      "card_no" : _cardNumber.toString(),
      "expiry_month" : _expiryMonth.toString(),
      "expiry_year" : _expiryYear.toString(),
      "cvv" : _cvv.toString(),
      "amount" : "50",
    };

    authService.saveCards(data, 'saveCards').then((value) {
      if(value.statusCode == 200){
        setState(() {
          isloading = false;
        });
        final cardDetails = (json.decode(value.body))['card_details'];
        // CardDetails cards = CardDetails.fromJson(cardDetails);
        CardDetails cards = new CardDetails(card_no: cardDetails['card_no'], expiry_month: int.parse(cardDetails['expiry_month']), expiry_year: int.parse(cardDetails['expiry_year']), cvv: int.parse(_cvv.toString()) );
        _cardNumber = cards.card_no;
        _expiryYear = cards.expiry_year;
        _expiryMonth = cards.expiry_month;
      }
      Navigator.pushReplacementNamed(context, '/shippingdetailspage');
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final trackingProvider =  Provider.of<TrackingCodesProvider>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: height,
          color: colorConvert('#e1f6ff'),
          child:Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.close, size: 30,),
                    ],
                  ),
                  SizedBox(height: height*0.02,),
                  Text("Add Credit", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20 ),),
                  SizedBox(height: height*0.02,),
                  ListView.builder(
                  itemCount: paymentData.length,
                  scrollDirection: Axis.vertical,
                  primary: false,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    TrackingCodes tracking = paymentData[index];
                    return   Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(tracking.message!),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  trackingProvider.setTrackingCodes(tracking);
                                });
                              },
                              child: Container(
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: trackingProvider.trackingCodes.price == tracking.price ? Colors.green : Colors.grey),
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: trackingProvider.trackingCodes.price == tracking.price  ?  Icon(
                                      Icons.check,
                                      size: 30.0,
                                      color: Colors.white,
                                    )
                                        :  Icon(
                                      Icons.check_box_outline_blank,
                                      size: 30.0,
                                      color: Colors.grey,
                                    )
                                    ,
                                  )
                              ),
                            )
                          ],
                        ),
                        Divider(thickness: 1,),
                      ],
                    );
                  }),
                  SizedBox(height: height*0.3,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: TextButton(
                      child: Text('CONTINUE TO PAYMENT', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300),),
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: colorConvert('#ec2761'),
                      ),
                      onPressed: () {
                        if(trackingProvider.trackingCodes.isPayAsYouGo != null){
                          _showMyDialog(context);
                        }else{
                          Navigator.pushReplacementNamed(context, '/checkoutpage');
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
    );
  }
}
