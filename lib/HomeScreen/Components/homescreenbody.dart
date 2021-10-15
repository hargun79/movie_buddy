import 'package:flutter/material.dart';

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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 100.0, horizontal: 30.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Home Screen"),
            ],
          ),
        ),
      ),
    );
  }
}
