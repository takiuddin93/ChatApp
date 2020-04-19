import 'package:chatapp/screens/dashboard.dart';
import 'package:chatapp/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chatapp/provider/image_upload_provider.dart';
import 'package:chatapp/provider/user_provider.dart';
import 'package:chatapp/resources/authentication_methods.dart';
// import 'package:chatapp/screens/search_screen.dart';

void main() {
  runApp(Main());
}

class Main extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<Main> {
  final AuthenticationMethods _authenticationMethods = AuthenticationMethods();

  @override
  Widget build(BuildContext context) {
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
                if (snapshot.hasData) {
                  return Dashboard();
                } else {
                  return Login();
                }
              })),
    );
  }
}
