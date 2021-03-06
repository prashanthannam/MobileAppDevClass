import 'package:fan_page_app/screens/sign_in.dart';
import 'package:flutter/material.dart';
import 'sign_up.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  bool showSignin = true;
  void toggleview() {
    setState(() => showSignin = !showSignin);
  }

  Widget build(BuildContext context) {
    if (showSignin == true) {
      return SignIn(toggleview: toggleview);
    } else {
      return SignUp(toggleview: toggleview);
    }
  }
}
