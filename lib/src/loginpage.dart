import 'package:flutter/material.dart';
import 'package:flutter_social_login/auth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Center(
        child: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: Auth().signInWithGoogle,
              child: Text('Google Login'),
            ),
            OutlinedButton(
              onPressed: Auth().signInWithFacebook,
              child: Text('Facebook Login'),
            ),
            OutlinedButton(
              onPressed: Auth().signInWithApple,
              child: Text('Apple Login'),
            ),
          ],
        ),
      ),
    );
  }
}
