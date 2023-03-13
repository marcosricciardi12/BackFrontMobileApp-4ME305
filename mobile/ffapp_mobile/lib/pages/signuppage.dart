import 'dart:async';

import 'package:ffapp_mobile/pages/loginpage.dart';
import 'package:ffapp_mobile/pages/myhomepage.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  late String user;
  late String email;
  late String password;
  late String confirmpassword;
  late bool _sendingData = false;
  late bool createuserOK = false;
  late bool createuserERROR = false;
  dynamic createuser;

  Future<http.Response> createUser(
      String user, String email, String password) async {
    _createuserOKFalse();
    _watingResponse();
    try {
      final response = await http
          .post(
            Uri.parse('http://151.252.176.107:5000/users'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              "user": user,
              "email": email,
              "password": password
            }),
          )
          .timeout(Duration(seconds: 3));
      _thereisResponse();
      if (response.statusCode == 201) {
        _createuserOKTrue();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('User Created!'),
              backgroundColor: Color.fromARGB(183, 255, 115, 0)),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        _createuserERRORTrue();
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

  void _createuserOKTrue() {
    setState(() {
      createuserOK = true;
      createuserERROR = false;
    });
  }

  void _createuserOKFalse() {
    setState(() {
      createuserOK = false;
    });
  }

  void _createuserERRORTrue() {
    setState(() {
      createuserERROR = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
        body: SingleChildScrollView(
            reverse: true,
            child: Column(
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
                            obscureText: false,
                            cursorColor: Color.fromARGB(255, 206, 108, 43),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                width: 2,
                                color: Color.fromARGB(255, 236, 163, 66),
                              )),
                              prefixIconColor:
                                  Color.fromARGB(255, 206, 108, 43),
                              prefixIcon: Icon(Icons.email_outlined),
                              border: OutlineInputBorder(),
                              labelText: 'email',
                            ),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              email = value!;
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          )),
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
                              prefixIconColor:
                                  Color.fromARGB(255, 206, 108, 43),
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
                              prefixIconColor:
                                  Color.fromARGB(255, 206, 108, 43),
                              prefixIcon: Icon(Icons.key),
                              border: OutlineInputBorder(),
                              labelText: 'Confirm password',
                            ),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              confirmpassword = value!;
                              if (value == null || value.isEmpty) {
                                return 'Please enter your confirm password';
                              }
                              if (password != confirmpassword) {
                                return "Passwords do not match";
                              }
                              return null;
                            },
                          )),
                      Column(children: <Widget>[
                        if (!_sendingData)
                          Container(
                              alignment: Alignment.center,
                              child: FloatingActionButton(
                                child: Icon(Icons.app_registration_rounded),
                                backgroundColor:
                                    Color.fromARGB(255, 207, 124, 68),
                                foregroundColor: Colors.white,
                                onPressed: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  // Validate returns true if the form is valid, or false otherwise.
                                  if (_formKey.currentState!.validate()) {
                                    // If the form is valid, display a snackbar. In the real world,
                                    // you'd often call a server or save the information in a database.
                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //   const SnackBar(
                                    //       content: Text('Processing request')),
                                    // );
                                    createuser =
                                        createUser(user, email, password);
                                    print(createuser);
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
                        if (createuserERROR)
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            child:
                                Center(child: Text("User couldn't be created")),
                          ),
                        if (createuserOK)
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            child: Center(child: Text("USER CREATED!")),
                          ),
                        Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom))
                      ]),
                    ],
                  ),
                ),
              ],
            )));
  }
}
