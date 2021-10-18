import 'package:flutter/material.dart';
import 'package:movie_buddy/HomeScreen/AddMoviesScreen/Components/addmoviescreenbody.dart';

class AddMoviesScreen extends StatelessWidget {
  static String routeName = "/addmoviesscreen";
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: Colors.white,
      body: AddMoviesScreenBody(),
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
