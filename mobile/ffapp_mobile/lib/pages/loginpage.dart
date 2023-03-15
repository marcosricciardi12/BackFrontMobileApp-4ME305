import 'package:ffapp_mobile/pages/myhomepage.dart';
import 'package:ffapp_mobile/pages/userinpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late String user;
  late String password;
  late bool _sendingData = false;
  late bool loginuserOK = false;
  late bool loginuserERROR = false;
  dynamic loginuser;

  Future<http.Response> loginUser(String user, String password) async {
    _loginuserOKFalse();
    _watingResponse();
    try {
      final response = await http
          .post(
            Uri.parse('${dotenv.env['URLAPI']}/auth/login'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(
                <String, String>{"user": user, "password": password}),
          )
          .timeout(Duration(seconds: 3));
      _thereisResponse();
      if (response.statusCode == 200) {
        _loginuserOKTrue();
        final Map parsed = json.decode(response.body);
        final String access_token = parsed["access_token"];
        saveJWT(access_token);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User login!'),
            backgroundColor: Color.fromARGB(183, 255, 115, 0),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserInPage()),
        );
      } else {
        _loginuserERRORTrue();
      }

      return response;
    } on TimeoutException catch (e) {
      print('Timeout');
      return http.Response("Bad Gateway", 504);
    }
  }

  void _watingResponse() {
    setState(() {
      _sendingData = true;
    });
  }

  void _thereisResponse() {
    setState(() {
      _sendingData = false;
    });
  }

  void _loginuserOKTrue() {
    setState(() {
      loginuserOK = true;
      loginuserERROR = false;
    });
  }

  void _loginuserOKFalse() {
    setState(() {
      loginuserOK = false;
    });
  }

  void _loginuserERRORTrue() {
    setState(() {
      loginuserERROR = true;
    });
  }

  saveJWT(String access_token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("access_token", access_token);
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 206, 108, 43),
          title: const Text("FastFoodApp"),
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Image.asset(
              "assets/logoMR.png",
            ),
          ),
        ),
        body: ListView(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(15),
                    child: TextFormField(
                      obscureText: false,
                      cursorColor: Color.fromARGB(255, 206, 108, 43),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          width: 2,
                          color: Color.fromARGB(255, 236, 163, 66),
                        )),
                        prefixIconColor: Color.fromARGB(255, 206, 108, 43),
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                        labelText: 'User',
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        user = value!;
                        if (value == null || value.isEmpty) {
                          return 'Please enter your user';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.all(15),
                      child: TextFormField(
                        obscureText: true,
                        cursorColor: Color.fromARGB(255, 206, 108, 43),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            width: 2,
                            color: Color.fromARGB(255, 236, 163, 66),
                          )),
                          prefixIconColor: Color.fromARGB(255, 206, 108, 43),
                          prefixIcon: Icon(Icons.key),
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          password = value!;
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      )),
                  Column(children: <Widget>[
                    if (!_sendingData)
                      Container(
                          alignment: Alignment.center,
                          child: FloatingActionButton(
                            child: Icon(Icons.send_rounded),
                            backgroundColor: Color.fromARGB(255, 207, 124, 68),
                            foregroundColor: Colors.white,
                            onPressed: () {
                              // Validate returns true if the form is valid, or false otherwise.
                              if (_formKey.currentState!.validate()) {
                                // If the form is valid, display a snackbar. In the real world,
                                // you'd often call a server or save the information in a database.
                                loginUser(user, password);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Processing Data'),
                                    duration: Duration(milliseconds: 1500),
                                  ),
                                );
                              }
                            },
                          )),
                    if (!_sendingData)
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: Center(child: Text("Sign Up!")),
                      )
                    else
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    if (loginuserERROR)
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: Center(child: Text("User couldn't login :(")),
                      ),
                    if (loginuserOK)
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: Center(child: Text("USER LOGIN SUCCESFUL!")),
                      )
                  ]),
                ],
              ),
            ),
          ],
        ));
  }
}
