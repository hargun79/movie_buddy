import 'package:flutter/material.dart';
import 'package:movie_buddy/Authentication/Login/login.dart';

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
  bool _passwordVisible = false;
  final TextEditingController _pass = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                            onSaved: (input) {},
                          ),
                        ),
                        SizedBox(
                          height: 17,
                        ),
                        Padding(
                            padding: EdgeInsets.all(10), child: Text("Email")),
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
                            onSaved: (input) {},
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
                            onSaved: (input) {},
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28.0),
                            ),
                          ),
                        ),
                        onPressed: () {},
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
    );
  }
}
