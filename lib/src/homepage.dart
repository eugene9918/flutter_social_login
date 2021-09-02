import 'package:flutter/material.dart';
import 'package:flutter_social_login/auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(Auth().currentUser!.displayName ?? 'no name'),
            ElevatedButton(
              onPressed: Auth().logout,
              child: Text('logout'),
            ),
          ],
        ),
      ),
    );
  }
}
