import 'package:flutter/material.dart';
import 'package:movie_buddy/HomeScreen/RemoveMoviesScreen/Components/removemoviescreenbody.dart';

class RemoveMoviesScreen extends StatelessWidget {
  static String routeName = "/removemoviesscreen";
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: Colors.white,
      body: RemoveMoviesScreenBody(),
      appBar: AppBar(
        title: Text(
          'Movie Buddy',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50)),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFF9EFE3),
      ),
    );
  }
}
