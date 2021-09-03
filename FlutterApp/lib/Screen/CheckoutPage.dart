import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:provider/provider.dart';
import 'package:timetrack/blocs/tracking_codes.dart';
import 'package:timetrack/blocs/user_bloc.dart';
import 'package:timetrack/constants/constants.dart';
import 'package:timetrack/models/User.dart';
import 'package:timetrack/models/card_details.dart';
import 'package:timetrack/services/auth_service.dart';


class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool get _isLocal => true;
  AuthService authService = AuthService();


  Color colorConvert(String color) {
    color = color.replaceAll("#", "");
    if (color.length == 6) {
      return Color(int.parse("0xFF"+color));
    } else if (color.length == 8) {
      return Color(int.parse("0x"+color));
    }
    return Color(0xfff3f3f4);
  }
  bool _inProgress = false;
  final _formKey = GlobalKey<FormState>();
  final _cardFormKey = GlobalKey<FormState>();
  CheckoutMethod _method = CheckoutMethod.selectable;

  var _border = new Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.red,
  );

  final _verticalSizeBox = const SizedBox(height: 20.0);
  String? _cardNumber;
  String? _cvv;
  int? _expiryMonth;
  int? _expiryYear;
  final _horizontalSizeBox = const SizedBox(width: 10.0);
  final plugin = PaystackPlugin();

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
                          onSaved: (String? value) => _cvv = value,
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
                _cardFormKey.currentState!.save();
                saveCard();
                _showMessage("Card Saved");
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
    var data= {
      "card_no" : _cardNumber.toString(),
      "expiry_month" : _expiryMonth.toString(),
      "expiry_year" : _expiryYear.toString(),
      "cvv" : _cvv.toString(),
    };

    authService.saveCards(data, 'saveCards').then((value) {
      if(value.statusCode == 200){
        final cardDetails = (json.decode(value.body))['card_details'];
        // CardDetails cards = CardDetails.fromJson(cardDetails);
        CardDetails cards = new CardDetails(card_no: cardDetails['card_no'], expiry_month: int.parse(cardDetails['expiry_month']), expiry_year: int.parse(cardDetails['expiry_year']), cvv: int.parse(_cvv.toString()) );
        _cardNumber = cards.card_no;
        _expiryYear = cards.expiry_year;
        _expiryMonth = cards.expiry_month;
      }

    });
  }
  deleteCard(){
    var data= {
      "card_no" : _cardNumber.toString(),
    };

    authService.deleteCards(data, 'deleteCards').then((value) {
      // if(value.statusCode == 200){
      //   final cardDetails = (json.decode(value.body))['card_details'];
      //   // CardDetails cards = CardDetails.fromJson(cardDetails);
      //   CardDetails cards = new CardDetails(card_no: cardDetails['card_no'], expiry_month: int.parse(cardDetails['expiry_month']), expiry_year: int.parse(cardDetails['expiry_year']), cvv: int.parse(_cvv.toString()) );
      //   _cardNumber = cards.card_no;
      //   _expiryYear = cards.expiry_year;
      //   _expiryMonth = cards.expiry_month;
      // }
      if(value["status"]==1){
        _showMessage("${value["message"]}");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CheckoutPage()));
        log("data deleted successfully==================");

      }
      else{
        _showMessage("${value["message"]}");
        log("data not deleted  successfully==================");
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CheckoutPage()));
      }

      // log("value==============${value["status"]}");


    });
  }

  PaymentCard _getCardFromUI() {
    // Using just the must-required parameters.
    return PaymentCard(
      number: _cardNumber,
      // number: '4084084084084081',
      cvc: _cvv,
      expiryMonth: _expiryMonth,
      expiryYear: _expiryYear,
    );
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

  Future<String?> _fetchAccessCodeFrmServer(String reference) async {
    String url = '$backendUrl/new-access-code';
    String? accessCode;
    try {
      print("Access code url = $url");
      http.Response response = await http.get(Uri.parse(url));
      accessCode = response.body;
      print('Response for access code = $accessCode');
    } catch (e) {
      setState(() => _inProgress = false);
      _updateStatus(
          reference,
          'There was a problem getting a new access code form'
              ' the backend: $e');
    }

    return accessCode;
  }

  _handleCheckout(BuildContext context) async {
    int amount = (Provider.of<TrackingCodesProvider>(context, listen: false).trackingCodes.price)??0;
    int tracking_codes = (Provider.of<TrackingCodesProvider>(context, listen: false).trackingCodes.no_tracking_codes)??0;
    final String userEmail = (Provider.of<UserProvider>(context, listen: false).user.email)??'customer@email.com';
    amount = amount*100;
    _method = CheckoutMethod.card;
    setState(() => _inProgress = true);
    _formKey.currentState?.save();
    Charge charge = Charge()
      ..amount = amount // In base currency
      ..email = userEmail
      ..card = _getCardFromUI();

    if (!_isLocal) {
      var accessCode = await _fetchAccessCodeFrmServer(_getReference());
      charge.accessCode = accessCode;
    } else {
      charge.reference = _getReference();
    }

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
          "card_number":_cardNumber.toString(),
        };
        authService.saveCheckout(data, 'saveCheckout').then((value) {
          if(value.statusCode == 200){
            print(value.body);
            final user = (json.decode(value.body)['user']);
            User authUser = User.fromJson(user);
            Provider.of<UserProvider>(context, listen: false).setUser(authUser);
            _showMessage("Payment Successfully completed");
          }else{
            _showMessage("Payment Unsuccessful");
          }
        }
        );
      }

      setState(() => _inProgress = false);
      // _updateStatus(response.reference, '$response');
    } catch (e) {
      setState(() => _inProgress = false);
      // _showMessage("Check console for error");
      rethrow;
    }
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

  _updateStatus(String? reference, String message) {
    _showMessage('Reference: $reference \n\ Response: $message',
        const Duration(seconds: 7));
  }

  @override
  void initState() {
    plugin.initialize(publicKey: paystackPublicKey);
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user;
    print('user');
    print(user);
    if(user.cardDetails != null){
    _cardNumber = user.cardDetails.card_no;
    _expiryMonth = user.cardDetails.expiry_month;
    _expiryYear = user.cardDetails.expiry_year;
    }
  }

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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(child: Icon(Icons.arrow_back), onTap: (){
                        Navigator.pop(context);
                      },)
                    ],
                  ),
                  SizedBox(height: height * 0.04),
                  Text("Checkout", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  SizedBox(height: height * 0.07),
                  Align(alignment:Alignment.centerLeft,child: Text('PAYMENT METHOD', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),)),
                  SizedBox(height: 15,),
                  if(_cardNumber != null)
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.red,
                          width: 2,
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Row(
                        children: [
                          Icon(Icons.credit_card_outlined, color: colorConvert('#ec2761'),),
                          SizedBox(width: 10,),
                          Text(_cardNumber!.replaceAll(RegExp(r'\d(?=.{4})'), '*')),
                        ],
                      ),
                       IconButton(onPressed: (){


                         _showDialog(context);
                       }, icon: Icon(Icons.delete,color: Colors.red,))
                      ],
                    ),
                  ),

                  SizedBox(height: height * 0.04),
                  InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: Colors.grey,),
                        SizedBox(width: 10,),
                        Text("USE A NEW CARD", style: TextStyle(fontSize: 16, color: Colors.grey),)
                      ],
                    ),
                    onTap: (){
                      _showMyDialog(context);
                    },
                  ),
                  SizedBox(height: height * 0.4,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: TextButton(
                      child: Text('Checkout', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300),),
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: colorConvert('#ec2761'),
                      ),
                      onPressed: () {
                        _handleCheckout(context);
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
  _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: colorConvert('#e1f6ff'),
            content: Wrap(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: Text(
                          "Are you sure want to delete card?",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        )),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            deleteCard();
                          },
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width / 4,
                            decoration: BoxDecoration(
                              color: Colors.green,

                              borderRadius: new BorderRadius.circular(10.0),

                              //border: Border.all(color: Colors.grey)
                            ),
                            child: Center(
                                child: Text("Yes",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold))),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width / 4,
                            decoration: BoxDecoration(
                              color: Colors.red,

                              borderRadius: new BorderRadius.circular(10.0),

                              //border: Border.all(color: Colors.grey)
                            ),
                            child: Center(
                                child: Text("No",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold))),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ));
      },
    );
  }
}


class MyLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      child: Text(
        "CO",
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
