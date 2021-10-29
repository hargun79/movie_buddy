import 'package:flutter/material.dart';
import 'package:movie_buddy/ChoosingScreen/Components/choosingscreenbody.dart';

class ChoosingScreen extends StatefulWidget {
  static String routeName = "/choosingscreen";

  @override
  State<ChoosingScreen> createState() => _ChoosingScreenState();
}

class _ChoosingScreenState extends State<ChoosingScreen> {
  final _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChoosingScreenBody();
  }
}
