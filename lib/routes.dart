import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:movie_buddy/HomeScreen/AddMoviesScreen/addmoviescreen.dart';
import 'package:movie_buddy/LandingScreen/landingscreen.dart';
import 'package:movie_buddy/SplashScreen/splashscreen.dart';
import 'Authentication/Login/login.dart';
import 'Authentication/SignUp/signup.dart';
import 'ChoosingScreen/choosingscreen.dart';
import 'HomeScreen/RemoveMoviesScreen/removemoviescreen.dart';
import 'HomeScreen/homescreen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  LandingScreen.routeName: (context) => LandingScreen(),
  LoginScreen.routeName: (context) => LoginScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  ChoosingScreen.routeName: (context) => ChoosingScreen(),
  AddMoviesScreen.routeName: (context) => AddMoviesScreen(),
  RemoveMoviesScreen.routeName: (context) => RemoveMoviesScreen()
};
