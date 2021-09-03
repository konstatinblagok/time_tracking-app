import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:country_codes/country_codes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timetrack/Screen/CheckoutPage.dart';
import 'package:timetrack/Screen/DeliveryQueuePage.dart';
import 'package:timetrack/Screen/Historypage.dart';
import 'package:timetrack/Screen/NavigationPage.dart';
import 'package:timetrack/Screen/NoInternetPage.dart';
import 'package:timetrack/Screen/OtpPage.dart';
import 'package:timetrack/Screen/PaymentSettingPage.dart';
import 'package:timetrack/Screen/ProfilePage.dart';
import 'package:timetrack/Screen/ReceiverTrackingPage.dart';
import 'package:timetrack/Screen/ShippingDetailsPage.dart';
import 'package:timetrack/Screen/SignIn.dart';
import 'package:timetrack/Screen/SignUpPage.dart';
import 'package:timetrack/Screen/UpdateProfilePage.dart';
import 'package:timetrack/blocs/application_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetrack/blocs/shippingdata_bloc.dart';
import 'package:timetrack/blocs/tracking_codes.dart';
import 'package:timetrack/blocs/user_bloc.dart';
import 'package:timetrack/models/static_tracking.dart';
import 'package:timetrack/services/userpreference_service.dart';
import 'Screen/SelectionPage.dart';
import 'models/push_notification.dart';



Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('background');
  print("Handling a background message: ${message.messageId}");
}

const AndroidNotificationChannel channel = AndroidNotificationChannel('high channel', 'high importance', 'This channel is used for important notification', importance: Importance.high, playSound: true);
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
RemoteMessage? _remoteMessage;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CountryCodes.init();

  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true
  );

  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final FirebaseMessaging _messaging;
  PushNotification? _notificationInfo;
  Future getUserData() => UserPreferences().getToken();
  final GlobalKey<NavigatorState> navigatorkey = GlobalKey<NavigatorState>();
  var trackingId = null;
  var connectivity;
  var _connectivityStatus = 'Unknown';
  StreamSubscription<ConnectivityResult>? subscription;

  void registerNotification() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;
print('registernoti');
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
    );
    
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        showNotification(message);

        print(
            'Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');
        // Parse the message received
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
          dataTitle: message.data['title'],
          dataBody: message.data['body'],
        );

        setState(() {
          _notificationInfo = notification;
        });
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void showNotification(message) {
    flutterLocalNotificationsPlugin.show(0, message?.notification?.title, message?.notification?.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              importance: Importance.high,
              color: Colors.blue,
              playSound: true,
              icon: '@mipmap/ic_launcher'
          ),
        ),
        payload: jsonEncode(message?.data)
    );
  }

  // For handling notification when the app is in terminated state
  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
        dataTitle: initialMessage.data['title'],
        dataBody: initialMessage.data['body'],
      );

      setState(() {
        _notificationInfo = notification;
      });
    }
  }

  @override
  void initState() {
    registerNotification();
    checkForInitialMessage();
    // For handling notification when the app is in background
    // but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if(message != null && message.data != null && message.data.containsKey('screen')){
        TrackingId.trackingId = message.data['trackingId'];
        navigatorkey.currentState!.pushNamed(message.data['screen']);
      }
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
        dataTitle: message.data['title'],
        dataBody: message.data['body'],
      );
      setState(() {
        _notificationInfo = notification;
      });
    });

    // connectivity = Connectivity();
    // subscription = connectivity.onConnectivityChanged.listen((ConnectivityResult result){
    //     if(result == ConnectivityResult.none){
    //       Navigator.pushNamed(context, '/nointernet');
    //     }
    // });
    super.initState();
  }



  Future selectNotification(payload) async{
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
  }

  Future onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title!),
        content: Text(body!),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[
        ChangeNotifierProvider(create: (_)=>Applicationbloc()),
        ChangeNotifierProvider(create: (_)=>UserProvider()),
        ChangeNotifierProvider(create: (_)=>ShippingDetailsProvider()),
        ChangeNotifierProvider(create: (_)=>TrackingCodesProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        navigatorKey: navigatorkey,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
       home: FutureBuilder(
         future: getUserData(),
         builder: (context, snapshot) {
           switch(snapshot.connectionState){
             case ConnectionState.none:
             case ConnectionState.waiting:
               return CircularProgressIndicator();
             default:
               if(snapshot.hasError) {
                 return Text('Error: ${snapshot.error}');
               } else if(snapshot.data == null)
                 {
                   return SignIn();
                 }
               else {
                 Provider.of<Applicationbloc>(context, listen: false).getLoggedInUser('getUser').then((value){
                   print('value');
                   print(value);
                   if(value.containsKey('user')){
                    Provider.of<UserProvider>(context, listen:false).setUser(value['user']);
                   }
                 });
                 return SelectionPage();
               }
           }
         },
       ),

        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/signup': (context) => SignUp(),
          '/otppage': (context) => OtpPage(),
          '/selectionpage': (context) => SelectionPage(),
          '/shippingdetailspage': (context) => ShippingDetailsPage(),
          '/navigationpage': (context) => NavigationPage(),
          '/deliveryqueuepage': (context) => DeliveryQueuePage(),
          '/profilepage': (context) => ProfilePage(),
          '/historypage': (context) => HistoryPage(),
          '/payemntsettingpage': (context) => PaymentSettingPage(),
          '/checkoutpage': (context) => CheckoutPage(),
          '/recevertrackingpage': (context) => ReceiverTrackingPage(),
          '/updateprofile': (context) => UpdateProfilePage(),
          '/nointernet': (context) => NoInternetPage(),
          // When navigating to the "/second" route, build the SecondScreen widget.
        },
      ),
    );
  }

}
