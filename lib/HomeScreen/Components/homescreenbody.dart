import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
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
    for (int i = 0; i < json.length; i++) {
      MovieDetails md = new MovieDetails();
      md.movieId = json[i][0];
      md.title = json[i][1];
      if (json[i][2] != "None")
        md.posterUrl = json[i][2];
      else
        md.posterUrl = "";
      if (json[i][3] != "None")
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

class MovieTile extends StatefulWidget {
  late final String title;
  late final String posterUrl;
  List<dynamic>? genres;

  MovieTile({required this.title, required this.posterUrl, this.genres});

  @override
  State<MovieTile> createState() => _MovieTileState();
}

class _MovieTileState extends State<MovieTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Container(
        height: 165,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xFFFCE3C5),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    if (widget.posterUrl != "")
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image(
                          image: CachedNetworkImageProvider(widget.posterUrl),
                          width: 110,
                          height: 165,
                        ),
                      ),
                    if (widget.posterUrl == "")
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image(
                          image: CachedNetworkImageProvider(
                              "https://res.cloudinary.com/hargun79/image/upload/v1634756580/41bLP6NzvKL.jpg"),
                          width: 110,
                          height: 165,
                        ),
                      ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 15, right: 15, top: 15, bottom: 5),
                          child: Container(
                            width: 160,
                            child: Center(
                              child: Text(
                                "${widget.title}",
                                maxLines: 2,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  for (int i = 0;
                                      i < widget.genres!.length && i < 2;
                                      i++)
                                    Padding(
                                      padding: EdgeInsets.only(left: 7, top: 5),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Color(0xFFFFFFF5),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Text("${widget.genres![i]} "),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              Row(
                                children: [
                                  for (int i = 2;
                                      i < widget.genres!.length && i < 4;
                                      i++)
                                    Padding(
                                      padding: EdgeInsets.only(left: 7, top: 5),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Color(0xFFFFFFF5),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Text("${widget.genres![i]} "),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
