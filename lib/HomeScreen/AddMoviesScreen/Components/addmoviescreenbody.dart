import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cached_network_image/cached_network_image.dart';

final LocalStorage storage = new LocalStorage('movie-buddy');
bool flag = true, flag2 = false, isButtonDisabled = true;
HashMap mp = new HashMap<int, int>();
HashMap mp2 = new HashMap<int, int>();
int rtng = 0;
String previous = "";

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
List<MovieDetails>? fantasy = <MovieDetails>[];
List<MovieDetails>? mystery = <MovieDetails>[];
List<MovieDetails>? all = <MovieDetails>[];

class MovieDetails {
  dynamic movieId;
  dynamic title;
  dynamic imdbId;
  dynamic youtubeId;
  List<String>? genres;
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
    for (int i = 0; i < json.length; i++) {
      MovieDetails md = new MovieDetails();
      md.movieId = json[i]['movieId'];
      md.title = json[i]['title'];
      md.imdbId = json[i]['imdbId'];
      md.youtubeId = json[i]['youtubeId'];
      List<dynamic> l = json[i]['Genre'];
      md.genres = l.cast<String>();
      if (json[i]['posterUrl'] != null)
        md.posterUrl = json[i]['posterUrl'];
      else
        md.posterUrl = "";
      if (json[i]['youtubeUrl'] != null)
        md.youtubeUrl = json[i]['youtubeUrl'];
      else
        md.youtubeUrl = "";
      all!.add(md);
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
        if (json[i]['Genre'][j] == "Mystery") mystery!.add(md);
        if (json[i]['Genre'][j] == "Fantasy") fantasy!.add(md);
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
  String _searchText = "";
  _MyAddMoviesScreenBodyState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          flag2 = false;
          movieTiles.clear();
          _searchText = "";
        });
      } else {
        setState(() {
          if (_searchQuery.text != previous) {
            movieTiles.clear();
            _searchText = _searchQuery.text;
            print(_searchText);
            for (int i = 0; i < all!.length; i++) {
              String name = all![i].title;
              if (name.toLowerCase().contains(_searchText.toLowerCase())) {
                bool isSelected = false;
                if (mp[all![i].movieId] != null) isSelected = true;
                if (mp2[all![i].movieId] == null)
                  movieTiles.add(
                    MovieTile(
                      movieId: all![i].movieId,
                      title: all![i].title,
                      posterUrl: all![i].posterUrl,
                      genres: all![i].genres,
                      isSelected: isSelected,
                    ),
                  );
              }
            }
            if (movieTiles.length > 0)
              flag2 = true;
            else
              flag2 = false;
            previous = _searchText;
          }
        });
      }
    });
  }
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
    if (all != null) all!.clear();
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
    if (mystery != null) mystery!.clear();
    if (fantasy != null) fantasy!.clear();
    mp.clear();
    mp2.clear();
    getUserMovies();
    futureMovies = fetchMovies();
  }

  final _scaffoldkey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = new TextEditingController();
  Widget appBarTitle = new Text(
    "Movie Buddy",
    style: new TextStyle(color: Colors.black),
  );
  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  bool _IsSearching = false;
  void _handleSearchStart() {
    setState(() {
      //flag2 = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        "Movie Buddy",
        style: new TextStyle(color: Colors.black),
      );
      flag2 = false;
      _searchQuery.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    BuildContext context2 = context;
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
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
                            "Rate Movies You Like",
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
                                'Fantasy',
                                'Horror',
                                'Musical',
                                'Mystery',
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
                                          title: action![i].title,
                                          posterUrl: action![i].posterUrl,
                                          genres: action![i].genres,
                                          isSelected: isSelected,
                                        ));
                                    }
                                  }
                                  if (value == "Adventure") {
                                    for (int i = 0;
                                        i < adventure!.length;
                                        i++) {
                                      bool isSelected = false;
                                      if (mp[adventure![i].movieId] != null)
                                        isSelected = true;
                                      if (mp2[adventure![i].movieId] == null)
                                        movieTiles.add(
                                          MovieTile(
                                            movieId: adventure![i].movieId,
                                            title: adventure![i].title,
                                            posterUrl: adventure![i].posterUrl,
                                            genres: adventure![i].genres,
                                            isSelected: isSelected,
                                          ),
                                        );
                                    }
                                  }
                                  if (value == "Animation") {
                                    for (int i = 0;
                                        i < animation!.length;
                                        i++) {
                                      bool isSelected = false;
                                      if (mp[animation![i].movieId] != null)
                                        isSelected = true;
                                      if (mp2[animation![i].movieId] == null)
                                        movieTiles.add(
                                          MovieTile(
                                            movieId: animation![i].movieId,
                                            title: animation![i].title,
                                            posterUrl: animation![i].posterUrl,
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
                                            title: children![i].title,
                                            posterUrl: children![i].posterUrl,
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
                                            title: comedy![i].title,
                                            posterUrl: comedy![i].posterUrl,
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
                                            title: crime![i].title,
                                            posterUrl: crime![i].posterUrl,
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
                                            title: documentary![i].title,
                                            posterUrl:
                                                documentary![i].posterUrl,
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
                                            title: drama![i].title,
                                            posterUrl: drama![i].posterUrl,
                                            genres: drama![i].genres,
                                            isSelected: isSelected,
                                          ),
                                        );
                                    }
                                  }
                                  if (value == "Fantasy") {
                                    print("here");
                                    print(fantasy!.length);
                                    for (int i = 0; i < fantasy!.length; i++) {
                                      bool isSelected = false;
                                      if (mp[fantasy![i].movieId] != null)
                                        isSelected = true;
                                      if (mp2[fantasy![i].movieId] == null)
                                        movieTiles.add(
                                          MovieTile(
                                            movieId: fantasy![i].movieId,
                                            title: fantasy![i].title,
                                            posterUrl: fantasy![i].posterUrl,
                                            genres: fantasy![i].genres,
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
                                            title: horror![i].title,
                                            posterUrl: horror![i].posterUrl,
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
                                            title: musical![i].title,
                                            posterUrl: musical![i].posterUrl,
                                            genres: musical![i].genres,
                                            isSelected: isSelected,
                                          ),
                                        );
                                    }
                                  }
                                  if (value == "Mystery") {
                                    for (int i = 0; i < mystery!.length; i++) {
                                      bool isSelected = false;
                                      if (mp[mystery![i].movieId] != null)
                                        isSelected = true;
                                      if (mp2[mystery![i].movieId] == null)
                                        movieTiles.add(
                                          MovieTile(
                                            movieId: mystery![i].movieId,
                                            title: mystery![i].title,
                                            posterUrl: mystery![i].posterUrl,
                                            genres: mystery![i].genres,
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
                                            title: romance![i].title,
                                            posterUrl: romance![i].posterUrl,
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
                                            title: scifi![i].title,
                                            posterUrl: scifi![i].posterUrl,
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
                                            title: thriller![i].title,
                                            posterUrl: thriller![i].posterUrl,
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
                                            title: war![i].title,
                                            posterUrl: war![i].posterUrl,
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
                                      key: ObjectKey(movieTiles[0]),
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
                                          var obj = {"id": k, "rating": mp[k]};
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
                                            arr.add(mp[k]);
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
                                              "Content-type":
                                                  "application/json",
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
                                                  toastLength:
                                                      Toast.LENGTH_LONG,
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
      ),
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () {
                setState(() {
                  if (this.actionIcon.icon == Icons.search) {
                    this.actionIcon = new Icon(
                      Icons.close,
                      color: Colors.white,
                    );
                    this.appBarTitle = new TextField(
                      controller: _searchQuery,
                      style: new TextStyle(
                        color: Colors.black,
                      ),
                      decoration: new InputDecoration(
                          prefixIcon:
                              new Icon(Icons.search, color: Colors.black),
                          hintText: "Search a movie",
                          hintStyle: new TextStyle(color: Colors.black)),
                    );
                    print(_searchQuery.text);
                    _handleSearchStart();
                  } else {
                    _handleSearchEnd();
                  }
                });
              },
              icon: actionIcon,
            ),
          )
        ],
        title: appBarTitle,
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

class MovieTile extends StatefulWidget {
  late final int movieId;
  late final String title;
  late final String posterUrl;
  List<String>? genres;
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
                              "https://res.cloudinary.com/hargun79/image/upload/v1634793149/404_Poster_Not_Found.png"),
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
                        if (!widget.isSelected) {
                          bool result = await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Rate'),
                                  content: RatingBar.builder(
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    itemCount: 5,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      rtng = rating.toInt();
                                    },
                                  ),
                                  actions: <Widget>[
                                    new TextButton(
                                      onPressed: () {
                                        rtng = 0;
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop(
                                                false); // dismisses only the dialog and returns false
                                      },
                                      child: Text('Back'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        mp[widget.movieId] = rtng;
                                        if (rtng == 0) {
                                          Fluttertoast.showToast(
                                              msg: "Rating can't be 0",
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1);
                                        } else {
                                          rtng = 0;
                                          if (mounted) {
                                            setState(() {
                                              widget.isSelected = true;
                                            });
                                          }
                                          if (mp.length > 0)
                                            isButtonDisabled = false;
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop(true);
                                        }
                                      },
                                      child: Text('Confirm'),
                                    ),
                                  ],
                                );
                              });
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
