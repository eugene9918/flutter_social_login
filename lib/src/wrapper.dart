import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_login/auth.dart';
import 'package:flutter_social_login/src/homepage.dart';
import 'package:flutter_social_login/src/loginpage.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(
        stream: Auth().userStream,
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasData)
            return HomePage();
          else
            return LoginPage();
        },
      ),
    );
  }
}
