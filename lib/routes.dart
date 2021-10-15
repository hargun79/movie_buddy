import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:movie_buddy/LandingScreen/landingscreen.dart';
import 'package:movie_buddy/SplashScreen/splashscreen.dart';
import 'Authentication/Login/login.dart';
import 'Authentication/SignUp/signup.dart';
import 'HomeScreen/homescreen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  LandingScreen.routeName: (context) => LandingScreen(),
  LoginScreen.routeName: (context) => LoginScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  HomeScreen.routeName: (context) => HomeScreen()
};
