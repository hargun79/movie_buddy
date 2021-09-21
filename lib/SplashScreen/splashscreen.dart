import 'dart:async';

import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:movie_buddy/LandingScreen/landingscreen.dart';
import 'package:localstorage/localstorage.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/splashscreen";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  final LocalStorage storage = new LocalStorage('moviebuddy');

  @override
  void initState() {
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LandingScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: storage.ready,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return SizedBox.expand(
              child: Container(
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
                color: Colors.white,
                //width: MediaQuery.of(context).size.width,
                //height: MediaQuery.of(context).size.height,
                child: Image(
                  //width: MediaQuery.of(context).size.width,
                  //height: MediaQuery.of(context).size.height,
                  image: AssetImage("Assets/splash.jpeg"),
                  fit: BoxFit.fitHeight,
                ),
              ),
            );
          }
          return SizedBox.expand(
              child: Container(
            color: Colors.white,
          ));
        });
  }
}
