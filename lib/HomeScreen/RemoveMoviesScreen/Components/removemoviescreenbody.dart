import 'dart:collection';
import 'dart:convert';
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
  dynamic movieName;
  dynamic date;
  dynamic imdbUrl;
  List<dynamic>? genres;

  MovieDetails(
      {this.movieId, this.movieName, this.date, this.imdbUrl, this.genres});

  MovieDetails.fromJson(dynamic json) {
    print(json);
    for (int i = 0; i < json.length; i++) {
      MovieDetails md = new MovieDetails();
      md.movieId = json[i]['movieId'];
      md.movieName = json[i]['title'];
      md.date = json[i]['date'];
      md.imdbUrl = json[i]['imdb'];
      md.genres = json[i]['Genre'];
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
                    padding: EdgeInsets.only(left: 15),
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
                            title: movies![i].movieName,
                            releaseDate: movies![i].date,
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
  late final String releaseDate;
  List<dynamic>? genres;
  bool isSelected = false;

  MovieTile(
      {required this.movieId,
      required this.title,
      required this.releaseDate,
      this.genres,
      required this.isSelected});

  @override
  State<MovieTile> createState() => _MovieTileState();
}

class _MovieTileState extends State<MovieTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xFFFCE3C5),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                      child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "${widget.title}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  )),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "${widget.releaseDate}",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    for (int i = 0; i < widget.genres!.length; i++)
                      if (i <= 2)
                        Row(
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(right: 5, top: 5, bottom: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
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
              Divider(
                height: 1,
              ),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.all(0),
                      ),
                      onPressed: () async {
                        BuildContext dialogContext = context;
                        print("In here");
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            print("In here 2");
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

                        //remove(widget.movieId);
                      },
                      child: Text("Remove")),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
