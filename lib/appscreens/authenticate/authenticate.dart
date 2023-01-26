import 'package:flutter/material.dart';
import 'package:fyp1/appscreens/authenticate/register.dart';
import 'package:fyp1/appscreens/login.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showLogin = true;
  void toggleView() {
    setState(() => showLogin = !showLogin);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('authenticate.dart@ Auth');
    if (showLogin) {
      return LoginPage(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}
