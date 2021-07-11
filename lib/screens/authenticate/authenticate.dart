import 'package:flutter/material.dart';
import 'package:med_reminder/screens/authenticate/welcome.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  @override
  Widget build(BuildContext context) {
    return Welcome();
  }
}
