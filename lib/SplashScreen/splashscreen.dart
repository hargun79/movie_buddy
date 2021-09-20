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
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: storage.ready,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return AnimatedSplashScreen(
              duration: 3000,
              splash: Text(
                "Movie Buddy",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 50,
                ),
              ),
              //nextScreen: flag ? HomePage() : SignIn(),
              nextScreen: LandingScreen(),
              splashTransition: SplashTransition.fadeTransition,
              backgroundColor: Color(0xffF9EFE3),
            );
          }
          return SizedBox.expand(
              child: Container(
            color: Colors.white,
          ));
        });
  }
}
