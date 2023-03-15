import 'package:ffapp_mobile/pages/loginpage.dart';
import 'package:ffapp_mobile/pages/signuppage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final bool flag = true;
  late String token = "";

  bool getJWT() {
    late bool status = false;
    SharedPreferences.getInstance().then((value) {
      if (value.getString("access_token") != null) {
        status = true;
      } else {
        status = false;
      }
    });
    print(status);
    return status;
    //Return String
  }

  void cleanSP() async {
    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  @override
  // ignore: must_call_super
  initState() {
    getJWT();
  }

  @override
  Widget build(BuildContext context) {
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
            Container(
                padding: const EdgeInsets.all(20.0),
                child: const Center(
                  child: Text("Welcome to FastFood App!"),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Column(children: <Widget>[
                  Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 92.0),
                      child: FloatingActionButton(
                        child: Icon(Icons.login),
                        backgroundColor: Color.fromARGB(255, 207, 124, 68),
                        foregroundColor: Colors.white,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        },
                      )),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.fromLTRB(92, 10, 0, 10),
                    child: Center(child: Text("Login")),
                  )
                ]),
                Column(children: <Widget>[
                  Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(right: 92.0),
                      child: FloatingActionButton(
                        child: Icon(Icons.create_rounded),
                        backgroundColor: Color.fromARGB(255, 207, 124, 68),
                        foregroundColor: Colors.white,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupPage()),
                          );
                        },
                      )),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.fromLTRB(0, 10, 92, 10),
                    child: Center(child: Text("Sign up")),
                  )
                ]),
              ],
            ),
          ],
        ));
  }
}
