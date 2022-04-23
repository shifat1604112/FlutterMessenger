import 'package:flutter/material.dart';
import 'package:messenger_flutter/screens/registration_screen.dart';
import 'package:messenger_flutter/screens/login_screen.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return LoginScreen(toggleView);
    } else {
      return RegistrationScreen(toggleView);
    }
  }
}