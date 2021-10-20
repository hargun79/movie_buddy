import 'dart:collection';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../removemoviescreen.dart';

final LocalStorage storage = new LocalStorage('movie-buddy');
bool flag = true, isButtonDisabled = true;
HashMap mp = new HashMap<int, int>();

Future<dynamic> fetchMovies() async {
  await storage.ready;
  var token = await storage.getItem('auth_token');
  var email = await storage.getItem('email');
  Map<String, String> headers = {
    "Content-type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer $token",
  };

  final response = await http.get(
      Uri.parse(
          'https://movie-buddy-server.herokuapp.com/getusermovies?email=$email'),
      headers: headers);

  if (response.statusCode == 200) {
    var token = await storage.getItem('auth_token');
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    var json = [];
    var j = jsonDecode(response.body);
    print(j);
    for (int i = 0; i < j.length; i++) {
      json.add(j[i]["id"]);
    }
    var obj = {"ids": json};
    final response2 = await http.post(
        Uri.parse('https://movie-buddy-server.herokuapp.com/getmoviesbyids'),
        headers: headers,
        body: jsonEncode(obj));
    return MovieDetails.fromJson(jsonDecode(response2.body));
  } else {
    flag = false;
    //throw Exception('Failed to load album');
  }
}

List<MovieDetails>? movies = <MovieDetails>[];

class MovieDetails {
  dynamic movieId;
  dynamic title;
  dynamic imdbId;
  dynamic youtubeId;
  List<dynamic>? genres;
  dynamic posterUrl;
  dynamic youtubeUrl;

  MovieDetails(
      {this.movieId,
      this.title,
      this.imdbId,
      this.youtubeId,
      this.genres,
      this.posterUrl,
      this.youtubeUrl});

  MovieDetails.fromJson(dynamic json) {
    print(json);
    for (int i = 0; i < json.length; i++) {
      MovieDetails md = new MovieDetails();
      md.movieId = json[i]['movieId'];
      md.title = json[i]['title'];
      md.imdbId = json[i]['imdbId'];
      md.youtubeId = json[i]['youtubeId'];
      md.genres = json[i]['Genre'];
      if (json[i]['posterUrl'] != null)
        md.posterUrl = json[i]['posterUrl'];
      else
        md.posterUrl = "";
      if (json[i]['youtbeUrl'] != null)
        md.youtubeUrl = json[i]['youtubeUrl'];
      else
        md.youtubeUrl = "";
      movies!.add(md);
    }
  }
}

class RemoveMoviesScreenBody extends StatefulWidget {
  @override
  _RemoveMoviesScreenBodyState createState() => _RemoveMoviesScreenBodyState();
}

class _RemoveMoviesScreenBodyState extends State<RemoveMoviesScreenBody> {
  @override
  Widget build(BuildContext context) {
    return MyRemoveMoviesScreenBody();
  }
}

class MyRemoveMoviesScreenBody extends StatefulWidget {
  @override
  _MyRemoveMoviesScreenBodyState createState() =>
      _MyRemoveMoviesScreenBodyState();
}

bool showSpinner = false;

class _MyRemoveMoviesScreenBodyState extends State<MyRemoveMoviesScreenBody> {
  late Future<dynamic> futureMovies;
  @override
  void initState() {
    super.initState();
    if (movies != null) movies!.clear();
    futureMovies = fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: FutureBuilder<dynamic>(
          future: futureMovies,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              void remove(var movieId) {
                setState(() {
                  showSpinner = true;
                });
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(top: 20, left: 10, right: 20),
                  child: Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Movies You Have Watched",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        for (int i = 0; i < movies!.length; i++)
                          MovieTile(
                            movieId: movies![i].movieId,
                            title: movies![i].title,
                            posterUrl: movies![i].posterUrl,
                            genres: movies![i].genres,
                            isSelected: false,
                          ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              );
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
          }),
    );
  }
}

class MovieTile extends StatefulWidget {
  late final int movieId;
  late final String title;
  late final String posterUrl;
  List<dynamic>? genres;
  bool isSelected = false;

  MovieTile(
      {required this.movieId,
      required this.title,
      required this.posterUrl,
      this.genres,
      required this.isSelected});

  @override
  State<MovieTile> createState() => _MovieTileState();
}

class _MovieTileState extends State<MovieTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Container(
        height: 213,
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image(
                        image: CachedNetworkImageProvider(widget.posterUrl),
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
            Row(
              children: [
                Container(
                  width: 303.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20)),
                    color: Color(0xFFF9EFE3),
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(0),
                    ),
                    onPressed: () async {
                      BuildContext dialogContext = context;
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          dialogContext = context;
                          return Dialog(
                            child: Container(
                              width: 150,
                              child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Text(
                                    "Removing...",
                                    textScaleFactor: 1,
                                  )),
                            ),
                          );
                        },
                      );
                      var token = await storage.getItem('auth_token');
                      Map<String, String> headers = {
                        "Content-type": "application/json",
                        "Accept": "application/json",
                        "Authorization": "Bearer $token",
                      };
                      var email = await storage.getItem('email');
                      String json =
                          '{"email": "$email","id": ${widget.movieId}}';
                      final response = await http.delete(
                          Uri.parse(
                              'https://movie-buddy-server.herokuapp.com/usermovie'),
                          headers: headers,
                          body: json);
                      if (response.statusCode == 200) {
                        print(jsonDecode(response.body));
                        var token = await storage.getItem('auth_token');
                        Map<String, String> headers = {
                          "Content-type": "application/json",
                          "Accept": "application/json",
                          "Authorization": "Bearer $token",
                        };
                        var userId = await storage.getItem('userId');
                        var ratings = [];
                        ratings.add(widget.movieId);
                        print(widget.movieId);
                        print(userId);
                        var json = {"userId": userId, "ratings": ratings};
                        final response2 = await http.delete(
                            Uri.parse(
                                'https://movie-buddy-server.herokuapp.com/recommend'),
                            headers: headers,
                            body: jsonEncode(json));
                        if (response2.statusCode == 200) {
                          Navigator.pop(dialogContext);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      RemoveMoviesScreen()));
                        }
                      } else {
                        Navigator.pop(dialogContext);
                        Fluttertoast.showToast(
                            msg: "Minimum 5 movies are required",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1);
                      }
                    },
                    child: Text("Remove"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
