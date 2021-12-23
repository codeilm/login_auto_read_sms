import 'package:flutter/material.dart';
import 'package:login/screens/home_screen.dart';
import 'package:login/screens/otp_screen.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assignment',
      debugShowCheckedModeBanner: false,
      home: OtpScreen(),
      routes: {
        'home': (context) => HomeScreen(),
      },
    );
  }
}
