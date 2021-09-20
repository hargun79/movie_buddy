import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_buddy/SplashScreen/splashscreen.dart';
import 'package:movie_buddy/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild!.unfocus();
        }
      },
      child: MaterialApp(
        title: "Movie Buddy",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xff2d2f93),
        ),
        initialRoute: SplashScreen.routeName,
        //initialRoute: HomePage.routeName,
        routes: routes,
      ),
    );
  }
}
