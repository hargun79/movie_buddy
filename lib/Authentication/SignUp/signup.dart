import 'package:flutter/material.dart';
import 'Components/signupbody.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = "/login";
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: Color(0xFFF9EFE3),
      body: SignUpScreenBody(),
      //appBar: myappbar(_scaffoldkey),
      // drawerEnableOpenDragGesture: true,
    );
  }
}
