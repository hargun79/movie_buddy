import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;

final LocalStorage storage = new LocalStorage('movie-buddy');
bool flag = true;

Future<dynamic> fetchMovies() async {
  await storage.ready;
  var token = await storage.getItem('auth_token');
  var email = await storage.getItem('email');
  Map<String, String> headers = {
    "Content-type": "application/json",
    "Accept": "application/json",
    'Charset': 'utf-8',
    "Authorization": "Bearer $token",
  };

  final response = await http.get(
      Uri.parse(
          'https://movie-buddy-server.herokuapp.com/recommend?email=$email'),
      headers: headers);

  if (response.statusCode == 200) {
    return MovieDetails.fromJson(jsonDecode(response.body));
  } else {
    flag = false;
    //throw Exception('Failed to load album');
  }
}

List<MovieDetails>? movies = <MovieDetails>[];

class MovieDetails {
  dynamic movieId;
  dynamic title;
  List<String>? genres;
  dynamic posterUrl;
  dynamic youtubeUrl;

  MovieDetails(
      {this.movieId, this.title, this.genres, this.posterUrl, this.youtubeUrl});

  MovieDetails.fromJson(dynamic json) {
    print("Here");
    print(jsonDecode(json));
    print("Here");
    for (int i = 0; i < json.length; i++) {
      MovieDetails md = new MovieDetails();
      md.movieId = json[i][0];
      print(json[4][0]);
      md.title = json[i][1];
      if (json[i][2].toString() != "NaN")
        md.posterUrl = json[i][2];
      else
        md.posterUrl = "";
      if (json[i][3].toString() != "NaN")
        md.youtubeUrl = json[i][3];
      else
        md.youtubeUrl = "";
      String s = json[i][4];
      List<String> g = s.split(', ');
      for (int i = 0; i < g.length; i++) {
        if (i == 0) g[i] = g[i].substring(1);
        if (i == g.length - 1) g[i] = g[i].substring(0, g[i].length - 1);
        g[i] = g[i].substring(1, g[i].length - 1);
      }
      md.genres = g;
      movies!.add(md);
    }
  }
}

class HomeScreenBody extends StatefulWidget {
  @override
  _HomeScreenBodyState createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  @override
  Widget build(BuildContext context) {
    return MyHomeScreenBody();
  }
}

class MyHomeScreenBody extends StatefulWidget {
  @override
  _MyHomeScreenBodyState createState() => _MyHomeScreenBodyState();
}

class _MyHomeScreenBodyState extends State<MyHomeScreenBody> {
  late Future<dynamic> futureMovies;
  @override
  void initState() {
    super.initState();
    if (movies != null) movies!.clear();
    futureMovies = fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: futureMovies,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return myhomebody(snapshot);
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Padding(
              padding: EdgeInsets.only(top: 0, left: 10, right: 10),
              child: Container(
                padding: EdgeInsets.only(left: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset('Assets/offline.jpg'),
                    ),
                    Center(
                      child: Text(
                        "You are offline",
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(
              child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
          ));
        });
  }
}

Widget myhomebody(dynamic snapshot) {
  return SingleChildScrollView(
    child: Padding(
      padding: EdgeInsets.only(top: 20, left: 10, right: 10),
      child: Container(
        padding: EdgeInsets.only(left: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Recommended For You",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            SizedBox(
              height: 20,
            ),
            for (int i = 0; i < movies!.length; i++)
              MovieTile(
                title: movies![i].title,
                posterUrl: movies![i].posterUrl,
                genres: movies![i].genres,
              ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    ),
  );
}

class MovieTile extends StatelessWidget {
  late final String title;
  late final String posterUrl;
  List<String>? genres;

  MovieTile({required this.title, required this.posterUrl, this.genres});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, right: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xFFFCE3C5),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                      child: Text(
                    "$title",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )),
                ],
              ),
              Row(
                children: [
                  for (int i = 0; i < genres!.length; i++)
                    if (i <= 2)
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(right: 5, top: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Color(0xFFFFFFF5),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text("${genres![i]} "),
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
