import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ReceiverTrackingTest extends StatefulWidget {

  @override
  _ReceiverTrackingTestState createState() => _ReceiverTrackingTestState();
}

class _ReceiverTrackingTestState extends State<ReceiverTrackingTest> {
  final databaseReference = FirebaseDatabase.instance.reference();
  final name = "1234Bak";
  @override
  void initState(){
    super.initState();
    databaseReference.child(name).onValue.listen((event) {
      var snapshot = event.snapshot;

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
