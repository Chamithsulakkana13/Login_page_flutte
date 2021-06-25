import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/login_bg.png'),
                fit: BoxFit.cover,
                colorFilter:
                    ColorFilter.mode(Colors.black54, BlendMode.darken))),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 80,
              ),
              Text(
                'Log In',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 60,
                    color: Colors.yellowAccent,
                    fontFamily: 'GrandHotel',
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 60,
              ),
              TextField(
                controller: emailController,
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle:
                        TextStyle(color: Colors.white, fontFamily: 'BreeSerif'),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellow),
                    ),
                    border: OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.yellow),
                    ),
                    prefixIcon: const Icon(Icons.email,
                        color: Colors.deepOrangeAccent)),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(),
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(
                          color: Colors.white, fontFamily: 'BreeSerif'),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow),
                      ),
                      border: OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.yellow),
                      ),
                      prefixIcon: const Icon(Icons.lock,
                          color: Colors.deepOrangeAccent)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(80),
                child: RaisedButton(
                  onPressed: emailController.text == "" ||
                          passwordController.text == ""
                      ? null
                      : () {
                          setState(() {
                            _isLoading = true;
                          });
                          signIn(emailController.text, passwordController.text);
                        },
                  color: Colors.deepOrangeAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: Text(
                    'Sign in',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontFamily: 'BreeSerif'),
                  ),
                  textColor: Colors.white,
                ),
              ),
              FlatButton(
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'BreeSerif'),
                ),
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }

  signIn(String email, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'email': email, 'pass': pass};
    var jsonResponse = null;
    var response =
        await http.post("http://localhost:3000/users/login", body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        if (jsonResponse != null) {
          setState(() {
            _isLoading = false;
          });
          sharedPreferences.setString("token", jsonResponse['token']);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => MainPage()),
              (Route<dynamic> route) => false);
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        print(response.body);
      }
    }
  }

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
}
