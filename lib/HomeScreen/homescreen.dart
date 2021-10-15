import 'package:flutter/material.dart';
import 'package:movie_buddy/HomeScreen/Components/homescreenbody.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/homescreen";
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: Color(0xFFF9EFE3),
      body: HomeScreenBody(),
      //appBar: myappbar(_scaffoldkey),
      // drawerEnableOpenDragGesture: true,
    );
  }
}
