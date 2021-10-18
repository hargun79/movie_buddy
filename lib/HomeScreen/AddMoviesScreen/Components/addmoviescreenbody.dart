import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:movie_buddy/HomeScreen/homescreen.dart';

final LocalStorage storage = new LocalStorage('movie-buddy');
bool flag = true, flag2 = false, isButtonDisabled = true;
HashMap mp = new HashMap<int, int>();
HashMap mp2 = new HashMap<int, int>();

Future<dynamic> fetchMovies() async {
  flag2 = false;
  await storage.ready;
  var token = await storage.getItem('auth_token');
  Map<String, String> headers = {
    "Content-type": "application/json",
    "Accept": "application/json",
    "Authorization": "Bearer $token",
  };

  final response = await http.get(
      Uri.parse('https://movie-buddy-server.herokuapp.com/getallmovies'),
      headers: headers);

  if (response.statusCode == 200) {
    return MovieDetails.fromJson(jsonDecode(response.body));
  } else {
    flag = false;
    //throw Exception('Failed to load album');
  }
}

List<MovieDetails>? action = <MovieDetails>[];
List<MovieDetails>? comedy = <MovieDetails>[];
List<MovieDetails>? drama = <MovieDetails>[];
List<MovieDetails>? crime = <MovieDetails>[];
List<MovieDetails>? thriller = <MovieDetails>[];
List<MovieDetails>? scifi = <MovieDetails>[];
List<MovieDetails>? children = <MovieDetails>[];
List<MovieDetails>? war = <MovieDetails>[];
List<MovieDetails>? romance = <MovieDetails>[];
List<MovieDetails>? horror = <MovieDetails>[];
List<MovieDetails>? adventure = <MovieDetails>[];
List<MovieDetails>? musical = <MovieDetails>[];
List<MovieDetails>? animation = <MovieDetails>[];
List<MovieDetails>? documentary = <MovieDetails>[];

class MovieDetails {
  dynamic movieId;
  dynamic movieName;
  dynamic date;
  dynamic imdbUrl;
  List<String>? genres;

  MovieDetails(
      {this.movieId, this.movieName, this.date, this.imdbUrl, this.genres});

  MovieDetails.fromJson(dynamic json) {
    for (int i = 0; i < json.length; i++) {
      MovieDetails md = new MovieDetails();
      md.movieId = json[i]['movieId'];
      md.movieName = json[i]['title'];
      md.date = json[i]['date'];
      md.imdbUrl = json[i]['imdb'];
      List<dynamic> l = json[i]['Genre'];
      md.genres = l.cast<String>();
      for (int j = 0; j < json[i]['Genre'].length; j++) {
        if (json[i]['Genre'][j] == "Action") action!.add(md);
        if (json[i]['Genre'][j] == "Comedy") comedy!.add(md);
        if (json[i]['Genre'][j] == "Drama") drama!.add(md);
        if (json[i]['Genre'][j] == "Thriller") thriller!.add(md);
        if (json[i]['Genre'][j] == "Crime") crime!.add(md);
        if (json[i]['Genre'][j] == "Sci-Fi") scifi!.add(md);
        if (json[i]['Genre'][j] == "Documentary") documentary!.add(md);
        if (json[i]['Genre'][j] == "Romance") romance!.add(md);
        if (json[i]['Genre'][j] == "Animation") animation!.add(md);
        if (json[i]['Genre'][j] == "Children") children!.add(md);
        if (json[i]['Genre'][j] == "Musical") musical!.add(md);
        if (json[i]['Genre'][j] == "Adventure") adventure!.add(md);
        if (json[i]['Genre'][j] == "Horror") horror!.add(md);
        if (json[i]['Genre'][j] == "War") war!.add(md);
      }
    }
  }
}

class AddMoviesScreenBody extends StatefulWidget {
  @override
  _AddMoviesScreenBodyState createState() => _AddMoviesScreenBodyState();
}

class _AddMoviesScreenBodyState extends State<AddMoviesScreenBody> {
  @override
  Widget build(BuildContext context) {
    return MyAddMoviesScreenBody();
  }
}

class MyAddMoviesScreenBody extends StatefulWidget {
  @override
  _MyAddMoviesScreenBodyState createState() => _MyAddMoviesScreenBodyState();
}

List<MovieTile> movieTiles = <MovieTile>[];
String? _dropDownValue = "Choose Genre";

class _MyAddMoviesScreenBodyState extends State<MyAddMoviesScreenBody> {
  late Future<dynamic> futureMovies;
  bool showSpinner = false;
  @override
  void getUserMovies() async {
    var token = await storage.getItem('auth_token');
    var email = await storage.getItem('email');
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    final response2 = await http.get(
        Uri.parse(
            'https://movie-buddy-server.herokuapp.com/getusermovies?email=$email'),
        headers: headers);
    if (response2.statusCode == 200) {
      dynamic json2 = jsonDecode(response2.body);
      for (int i = 0; i < json2.length; i++) {
        mp2[json2[i]["id"]] = 1;
      }
    }
  }

  void initState() {
    super.initState();
    isButtonDisabled = true;
    if (action != null) action!.clear();
    if (crime != null) crime!.clear();
    if (thriller != null) thriller!.clear();
    if (drama != null) drama!.clear();
    if (adventure != null) adventure!.clear();
    if (war != null) war!.clear();
    if (animation != null) animation!.clear();
    if (children != null) children!.clear();
    if (comedy != null) comedy!.clear();
    if (romance != null) romance!.clear();
    if (documentary != null) documentary!.clear();
    if (horror != null) horror!.clear();
    if (musical != null) musical!.clear();
    if (scifi != null) scifi!.clear();
    mp.clear();
    mp2.clear();
    getUserMovies();
    futureMovies = fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    BuildContext context2 = context;
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: FutureBuilder<dynamic>(
          future: futureMovies,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                  child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Choose Movies You Like",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: DropdownButton<String>(
                            hint: _dropDownValue == null
                                ? Text('Choose Genre')
                                : Text(
                                    _dropDownValue.toString(),
                                  ),
                            isExpanded: true,
                            icon: Icon(
                              Icons.arrow_drop_down_circle_outlined,
                            ),
                            focusColor: Colors.black,
                            items: <String>[
                              'Action',
                              'Adventure',
                              'Animation',
                              'Children',
                              'Comedy',
                              'Crime',
                              'Documentary',
                              'Drama',
                              'Horror',
                              'Musical',
                              'Romance',
                              'Sci-Fi',
                              'Thriller',
                              'War'
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              print(mp2);
                              print(value);
                              setState(() {
                                _dropDownValue = value;
                                movieTiles.clear();
                                if (value == "Action") {
                                  for (int i = 0; i < action!.length; i++) {
                                    bool isSelected = false;
                                    if (mp[action![i].movieId] != null)
                                      isSelected = true;
                                    if (mp2[action![i].movieId] == null)
                                      movieTiles.add(MovieTile(
                                        movieId: action![i].movieId,
                                        title: action![i].movieName,
                                        releaseDate: action![i].date,
                                        genres: action![i].genres,
                                        isSelected: isSelected,
                                      ));
                                  }
                                }
                                if (value == "Adventure") {
                                  for (int i = 0; i < adventure!.length; i++) {
                                    bool isSelected = false;
                                    if (mp[adventure![i].movieId] != null)
                                      isSelected = true;
                                    if (mp2[adventure![i].movieId] == null)
                                      movieTiles.add(
                                        MovieTile(
                                          movieId: adventure![i].movieId,
                                          title: adventure![i].movieName,
                                          releaseDate: adventure![i].date,
                                          genres: adventure![i].genres,
                                          isSelected: isSelected,
                                        ),
                                      );
                                  }
                                }
                                if (value == "Animation") {
                                  for (int i = 0; i < animation!.length; i++) {
                                    bool isSelected = false;
                                    if (mp[animation![i].movieId] != null)
                                      isSelected = true;
                                    if (mp2[animation![i].movieId] == null)
                                      movieTiles.add(
                                        MovieTile(
                                          movieId: animation![i].movieId,
                                          title: animation![i].movieName,
                                          releaseDate: animation![i].date,
                                          genres: animation![i].genres,
                                          isSelected: isSelected,
                                        ),
                                      );
                                  }
                                }
                                if (value == "Children") {
                                  for (int i = 0; i < children!.length; i++) {
                                    bool isSelected = false;
                                    if (mp[children![i].movieId] != null)
                                      isSelected = true;
                                    if (mp2[children![i].movieId] == null)
                                      movieTiles.add(
                                        MovieTile(
                                          movieId: children![i].movieId,
                                          title: children![i].movieName,
                                          releaseDate: children![i].date,
                                          genres: children![i].genres,
                                          isSelected: isSelected,
                                        ),
                                      );
                                  }
                                }
                                if (value == "Comedy") {
                                  for (int i = 0; i < comedy!.length; i++) {
                                    bool isSelected = false;
                                    if (mp[comedy![i].movieId] != null)
                                      isSelected = true;
                                    if (mp2[comedy![i].movieId] == null)
                                      movieTiles.add(
                                        MovieTile(
                                          movieId: comedy![i].movieId,
                                          title: comedy![i].movieName,
                                          releaseDate: comedy![i].date,
                                          genres: comedy![i].genres,
                                          isSelected: isSelected,
                                        ),
                                      );
                                  }
                                }
                                if (value == "Crime") {
                                  for (int i = 0; i < crime!.length; i++) {
                                    bool isSelected = false;
                                    if (mp[crime![i].movieId] != null)
                                      isSelected = true;
                                    if (mp2[crime![i].movieId] == null)
                                      movieTiles.add(
                                        MovieTile(
                                          movieId: crime![i].movieId,
                                          title: crime![i].movieName,
                                          releaseDate: crime![i].date,
                                          genres: crime![i].genres,
                                          isSelected: isSelected,
                                        ),
                                      );
                                  }
                                }
                                if (value == "Documentary") {
                                  for (int i = 0;
                                      i < documentary!.length;
                                      i++) {
                                    bool isSelected = false;
                                    if (mp[documentary![i].movieId] != null)
                                      isSelected = true;
                                    if (mp2[documentary![i].movieId] == null)
                                      movieTiles.add(
                                        MovieTile(
                                          movieId: documentary![i].movieId,
                                          title: documentary![i].movieName,
                                          releaseDate: documentary![i].date,
                                          genres: documentary![i].genres,
                                          isSelected: isSelected,
                                        ),
                                      );
                                  }
                                }
                                if (value == "Drama") {
                                  for (int i = 0; i < drama!.length; i++) {
                                    bool isSelected = false;
                                    if (mp[drama![i].movieId] != null)
                                      isSelected = true;
                                    if (mp2[drama![i].movieId] == null)
                                      movieTiles.add(
                                        MovieTile(
                                          movieId: drama![i].movieId,
                                          title: drama![i].movieName,
                                          releaseDate: drama![i].date,
                                          genres: drama![i].genres,
                                          isSelected: isSelected,
                                        ),
                                      );
                                  }
                                }
                                if (value == "Horror") {
                                  for (int i = 0; i < horror!.length; i++) {
                                    bool isSelected = false;
                                    if (mp[horror![i].movieId] != null)
                                      isSelected = true;
                                    if (mp2[horror![i].movieId] == null)
                                      movieTiles.add(
                                        MovieTile(
                                          movieId: horror![i].movieId,
                                          title: horror![i].movieName,
                                          releaseDate: horror![i].date,
                                          genres: horror![i].genres,
                                          isSelected: isSelected,
                                        ),
                                      );
                                  }
                                }
                                if (value == "Musical") {
                                  for (int i = 0; i < musical!.length; i++) {
                                    bool isSelected = false;
                                    if (mp[musical![i].movieId] != null)
                                      isSelected = true;
                                    if (mp2[musical![i].movieId] == null)
                                      movieTiles.add(
                                        MovieTile(
                                          movieId: musical![i].movieId,
                                          title: musical![i].movieName,
                                          releaseDate: musical![i].date,
                                          genres: musical![i].genres,
                                          isSelected: isSelected,
                                        ),
                                      );
                                  }
                                }
                                if (value == "Romance") {
                                  for (int i = 0; i < romance!.length; i++) {
                                    bool isSelected = false;
                                    if (mp[romance![i].movieId] != null)
                                      isSelected = true;
                                    if (mp2[romance![i].movieId] == null)
                                      movieTiles.add(
                                        MovieTile(
                                          movieId: romance![i].movieId,
                                          title: romance![i].movieName,
                                          releaseDate: romance![i].date,
                                          genres: romance![i].genres,
                                          isSelected: isSelected,
                                        ),
                                      );
                                  }
                                }
                                if (value == "Sci-Fi") {
                                  for (int i = 0; i < scifi!.length; i++) {
                                    bool isSelected = false;
                                    if (mp[scifi![i].movieId] != null)
                                      isSelected = true;
                                    if (mp2[scifi![i].movieId] == null)
                                      movieTiles.add(
                                        MovieTile(
                                          movieId: scifi![i].movieId,
                                          title: scifi![i].movieName,
                                          releaseDate: scifi![i].date,
                                          genres: scifi![i].genres,
                                          isSelected: isSelected,
                                        ),
                                      );
                                  }
                                }
                                if (value == "Thriller") {
                                  for (int i = 0; i < thriller!.length; i++) {
                                    bool isSelected = false;
                                    if (mp[thriller![i].movieId] != null)
                                      isSelected = true;
                                    if (mp2[thriller![i].movieId] == null)
                                      movieTiles.add(
                                        MovieTile(
                                          movieId: thriller![i].movieId,
                                          title: thriller![i].movieName,
                                          releaseDate: thriller![i].date,
                                          genres: thriller![i].genres,
                                          isSelected: isSelected,
                                        ),
                                      );
                                  }
                                }
                                if (value == "War") {
                                  for (int i = 0; i < war!.length; i++) {
                                    bool isSelected = false;
                                    if (mp[war![i].movieId] != null)
                                      isSelected = true;
                                    if (mp2[war![i].movieId] == null)
                                      movieTiles.add(
                                        MovieTile(
                                          movieId: war![i].movieId,
                                          title: war![i].movieName,
                                          releaseDate: war![i].date,
                                          genres: war![i].genres,
                                          isSelected: isSelected,
                                        ),
                                      );
                                  }
                                }
                                flag2 = true;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        flag2
                            ? SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                child: ListView.builder(
                                    itemCount: movieTiles.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return movieTiles[index];
                                    }),
                              )
                            : SizedBox(),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Center(
                            child: Container(
                              //color: Colors.blueAccent,
                              width: double.infinity,
                              child: TextButton(
                                  style: TextButton.styleFrom(
                                    padding:
                                        EdgeInsets.only(bottom: 20, top: 5),
                                  ),
                                  onPressed: () async {
                                    if (!isButtonDisabled) {
                                      setState(() {
                                        showSpinner = true;
                                      });
                                      var token =
                                          await storage.getItem('auth_token');
                                      var email =
                                          await storage.getItem('email');
                                      Map<String, String> headers = {
                                        "Content-type": "application/json",
                                        "Authorization": "Bearer $token"
                                      };
                                      var movieIds = [];
                                      for (var k in mp.keys) {
                                        var obj = {"id": k, "rating": 4};
                                        movieIds.add(obj);
                                      }
                                      var json = {
                                        "email": email,
                                        "movieIds": movieIds
                                      };
                                      http.Response response = await http.post(
                                          Uri.parse(
                                              'https://movie-buddy-server.herokuapp.com/usermovie'),
                                          headers: headers,
                                          body: jsonEncode(json));
                                      if (response.statusCode == 200) {
                                        var userId =
                                            await storage.getItem('userId');
                                        print(userId);
                                        var ratings = [];
                                        for (var k in mp.keys) {
                                          var arr = [];
                                          arr.add(userId);
                                          arr.add(k);
                                          arr.add(4);
                                          ratings.add(arr);
                                        }
                                        print(ratings);
                                        var json2 = {
                                          "userId": userId,
                                          "ratings": ratings
                                        };
                                        http.Response response2 = await http.put(
                                            Uri.parse(
                                                'https://movie-buddy-server.herokuapp.com/recommend'),
                                            headers: headers,
                                            body: jsonEncode(json2));
                                        if (response2.statusCode == 200) {
                                          var token2 = await storage
                                              .getItem('auth_token');
                                          var email2 =
                                              await storage.getItem('email');
                                          Map<String, String> headers = {
                                            "Content-type": "application/json",
                                            "Accept": "application/json",
                                            "Authorization": "Bearer $token2",
                                          };
                                          final response3 = await http.get(
                                              Uri.parse(
                                                  'https://movie-buddy-server.herokuapp.com/getusermovies?email=$email2'),
                                              headers: headers);
                                          if (response3.statusCode == 200) {
                                            dynamic json2 =
                                                jsonDecode(response3.body);
                                            for (int i = 0;
                                                i < json2.length;
                                                i++) {
                                              mp2[json2[i]['id']] = 1;
                                            }
                                            _dropDownValue = "Choose Genre";
                                            flag2 = false;
                                            setState(() {
                                              showSpinner = false;
                                            });
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Movies Added Successfully",
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1);
                                          }
                                        } else {
                                          setState(() {
                                            showSpinner = false;
                                          });
                                          Fluttertoast.showToast(
                                              msg: "Please try again later",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1);
                                        }
                                      } else {
                                        setState(() {
                                          showSpinner = false;
                                        });
                                        print(response.body);
                                        Fluttertoast.showToast(
                                            msg: "Please try again later",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1);
                                        print(response.reasonPhrase);
                                      }
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Minimum of 1 movie needed",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1);
                                    }
                                  },
                                  child: Text(
                                    "Continue",
                                    style: TextStyle(
                                      color: Colors.blue,
                                    ),
                                  )),
                            ),
                          ),
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
  List<String>? genres;
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
                      onPressed: () {
                        if (!widget.isSelected) {
                          mp[widget.movieId] = 1;
                          setState(() {
                            widget.isSelected = true;
                          });
                          if (mp.length > 0) isButtonDisabled = false;
                        } else {
                          mp.remove(widget.movieId);
                          setState(() {
                            widget.isSelected = false;
                          });
                          if (mp.length < 1) isButtonDisabled = true;
                        }
                      },
                      child: widget.isSelected ? Text("Remove") : Text("Add")),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
