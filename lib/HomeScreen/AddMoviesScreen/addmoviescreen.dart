import 'package:flutter/material.dart';
import 'package:movie_buddy/HomeScreen/AddMoviesScreen/Components/addmoviescreenbody.dart';

class AddMoviesScreen extends StatefulWidget {
  static String routeName = "/addmoviesscreen";

  @override
  State<AddMoviesScreen> createState() => _AddMoviesScreenState();
}

class _AddMoviesScreenState extends State<AddMoviesScreen> {
  @override
  Widget build(BuildContext context) {
    return AddMoviesScreenBody();
  }
}
