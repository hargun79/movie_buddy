import 'package:flutter/material.dart';
import 'package:movie_buddy/LandingScreen/Components/landingscreenbody.dart';

class LandingScreen extends StatelessWidget {
  static String routeName = "/landingscreen";
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: Color(0xFFF9EFE3),
      body: LandingScreenBody(),
      //appBar: myappbar(_scaffoldkey),
      // drawerEnableOpenDragGesture: true,
    );
  }
}
