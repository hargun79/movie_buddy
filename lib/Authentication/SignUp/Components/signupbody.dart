import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:movie_buddy/Authentication/Login/login.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_buddy/ChoosingScreen/choosingscreen.dart';

class SignUpScreenBody extends StatefulWidget {
  @override
  _SignUpScreenBodyState createState() => _SignUpScreenBodyState();
}

class _SignUpScreenBodyState extends State<SignUpScreenBody> {
  @override
  Widget build(BuildContext context) {
    return MySignUpScreenBody();
  }
}

class MySignUpScreenBody extends StatefulWidget {
  @override
  _MySignUpScreenBodyState createState() => _MySignUpScreenBodyState();
}

class _MySignUpScreenBodyState extends State<MySignUpScreenBody> {
  final LocalStorage storage = new LocalStorage('movie-buddy');
  bool _passwordVisible = false;
  bool showSpinner = false;
  final TextEditingController _pass = TextEditingController();
  late String name;
  late String email;
  late String password;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFFCE3C5),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(75.0),
                ),
              ),
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: Padding(
                padding: EdgeInsets.only(left: 30, top: 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create Account !",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Sign Up and Join Us",
                      style: TextStyle(
                        fontSize: 23,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 30.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.all(10), child: Text("Name")),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(86),
                            ),
                            child: TextFormField(
                              validator: (input) {
                                if (input!.isEmpty) {
                                  return "Provide your name";
                                }
                              },
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(86),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(86),
                                ),
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      style: BorderStyle.solid, width: 10),
                                  borderRadius: BorderRadius.circular(86.0),
                                ),
                              ),
                              onChanged: (input) {
                                name = input;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 17,
                          ),
                          Padding(
                              padding: EdgeInsets.all(10),
                              child: Text("Email")),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(86),
                            ),
                            child: TextFormField(
                              validator: (input) {
                                if (input!.isEmpty) {
                                  return "Provide the Email ID";
                                }
                              },
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(86),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(86),
                                ),
                                prefixIcon: Icon(Icons.mail_rounded),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      style: BorderStyle.solid, width: 10),
                                  borderRadius: BorderRadius.circular(86.0),
                                ),
                              ),
                              onChanged: (input) {
                                email = input;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 17,
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text("Password"),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(86),
                            ),
                            child: TextFormField(
                              controller: _pass,
                              validator: (input) {
                                if (input!.isEmpty) {
                                  return "Provide the password";
                                }
                              },
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    // Based on passwordVisible state choose the icon
                                    _passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    // Update the state i.e. toogle the state of passwordVisible variable
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(86),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(86),
                                ),
                                prefixIcon: Icon(Icons.lock),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        style: BorderStyle.solid, width: 10),
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                              onChanged: (input) {
                                password = input;
                              },
                              obscureText: !_passwordVisible,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 37,
                    ),
                    Center(
                      child: Container(
                        width: 150,
                        height: 37,
                        child: TextButton(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xFF76B8F5)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28.0),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              showSpinner = true;
                            });
                            Map<String, String> headers = {
                              "Content-type": "application/json"
                            };
                            String json =
                                '{"email": "$email", "username": "$name", "password": "$password"}';
                            http.Response response = await http.post(
                                Uri.parse(
                                    'https://movie-buddy-server.herokuapp.com/signup'),
                                headers: headers,
                                body: json);
                            if (response.statusCode == 200) {
                              var res = await jsonDecode(response.body);
                              storage.setItem('auth_token', res['token']);
                              storage.setItem('name', res['username']);
                              storage.setItem('email', res['email']);
                              storage.setItem('userId', res['userId']);
                              setState(() {
                                showSpinner = false;
                              });
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  ChoosingScreen.routeName,
                                  (Route<dynamic> route) => false);
                            } else {
                              setState(() {
                                showSpinner = false;
                              });
                              FocusScope.of(context).unfocus();
                              Fluttertoast.showToast(
                                  msg: "Account Already Exists",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1);
                              print(response.reasonPhrase);
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account?"),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => LoginScreen()));
                            },
                            child: Text(
                              " Click Here!",
                              style: TextStyle(color: Colors.orange),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
