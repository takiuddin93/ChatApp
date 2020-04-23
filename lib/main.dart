import 'package:chatapp/screens/dashboard.dart';
import 'package:chatapp/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chatapp/provider/image_upload_provider.dart';
import 'package:chatapp/provider/user_provider.dart';
import 'package:chatapp/resources/authentication_methods.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() {
  runApp(Main());
}

class Main extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<Main> {
  final AuthenticationMethods _authenticationMethods = AuthenticationMethods();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String token;
  _getdeviceToken() {
    _firebaseMessaging.getToken().then((deviceToken) {
      setState(() {
        token = deviceToken.toString();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getdeviceToken();
    Future.delayed(Duration(milliseconds: 500), () {
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
          final notification = message['data'];
          setState(() {
            print("title: " +
                notification['title'] +
                "body: " +
                notification['body']);
          });
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
          final notification = message['data'];
          setState(() {
            print("title: " +
                notification['title'] +
                "body: " +
                notification['body']);
          });
          print("onLaunch: " + notification['click_action']);
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
          final notification = message['data'];
          setState(() {
            print("title: " +
                notification['title'] +
                "body: " +
                notification['body']);
          });

          print("onResume: " + notification['click_action']);
        },
      );
      _firebaseMessaging.requestNotificationPermissions(
          const IosNotificationSettings(sound: true, badge: true, alert: true));
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Firebase Token: " + token);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Chat App',
          theme: ThemeData(brightness: Brightness.dark),
          home: FutureBuilder(
              future: _authenticationMethods.getCurrentUser(),
              builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                if (snapshot.hasData != false) {
                  return Dashboard();
                } else {
                  return Login(token: token);
                }
              })),
    );
  }
}
