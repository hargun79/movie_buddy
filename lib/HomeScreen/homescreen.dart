import 'package:flutter/material.dart';
import 'package:movie_buddy/HomeScreen/Components/homescreenbody.dart';
import 'package:movie_buddy/LandingScreen/landingscreen.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/homescreen";
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    void handleClick(String value) async {
      switch (value) {
        case 'Logout':
          bool result = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                //title: Text('Confirmation'),
                content: Text('Are you sure you want to logout?'),
                actions: <Widget>[
                  new TextButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop(
                          false); // dismisses only the dialog and returns false
                    },
                    child: Text('No'),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context, rootNavigator: true).pop(true);
                      await storage.clear();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          LandingScreen.routeName,
                          (Route<dynamic> route) => false);
                    },
                    child: Text('Yes'),
                  ),
                ],
              );
            },
          );
          break;
        case 'Settings':
          break;
      }
    }

    return Scaffold(
      key: _scaffoldkey,
      body: HomeScreenBody(),
      backgroundColor: Colors.white,
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
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: PopupMenuButton<String>(
              onSelected: handleClick,
              icon: Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              itemBuilder: (BuildContext context) {
                return {'Edit Watched List', 'Logout'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ),
        ],
      ),
    );
  }
}
