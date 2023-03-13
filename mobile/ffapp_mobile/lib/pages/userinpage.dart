import 'package:ffapp_mobile/pages/init.dart';
import 'package:ffapp_mobile/pages/loginpage.dart';
import 'package:ffapp_mobile/pages/menupage.dart';
import 'package:ffapp_mobile/pages/qrscanner.dart';
import 'package:ffapp_mobile/pages/signuppage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decode/jwt_decode.dart';

class UserInPage extends StatefulWidget {
  const UserInPage({super.key});

  @override
  State<UserInPage> createState() => _UserInPageState();
}

class _UserInPageState extends State<UserInPage> {
  final bool flag = true;
  late String token = "";
  late bool _istoken = false;
  late String user = getUser();

  getJWT() async {
    await SharedPreferences.getInstance().then((value) {
      token = value.getString("access_token")!;
      _isJWT();
    });

    //Return String
  }

  String getUser() {
    SharedPreferences.getInstance().then((value) {
      token = value.getString("access_token")!;
      _isJWT();
      Map<String, dynamic> payload = Jwt.parseJwt(token);
      user = payload["user"];
    });
    return user;
  }

  void _isJWT() {
    setState(() {
      _istoken = true;
    });
  }

  void _isnotJTW() {
    setState(() {
      _istoken = false;
    });
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
          actions: [
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              tooltip: 'Logout!',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('User logged out! Bye $user'),
                    backgroundColor: Color.fromARGB(183, 255, 115, 0),
                  ),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InitPage()),
                );
              },
            ),
          ],
        ),
        body: ListView(
          children: <Widget>[
            Container(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text("Welcome to FastFood App $user!"),
                )),
            Row(children: <Widget>[
              Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.fromLTRB(16, 5, 0, 5),
                  child: FloatingActionButton(
                    child: Icon(Icons.add_shopping_cart_sharp),
                    backgroundColor: Color.fromARGB(255, 207, 124, 68),
                    foregroundColor: Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MenuPage()),
                      );
                    },
                  )),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                child: Center(child: Text("New Order!")),
              )
            ]),
            Row(children: <Widget>[
              Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.fromLTRB(16, 5, 0, 5),
                  child: FloatingActionButton(
                    child: Icon(Icons.qr_code_scanner_rounded),
                    backgroundColor: Color.fromARGB(255, 207, 124, 68),
                    foregroundColor: Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const QrScannePage()),
                      );
                    },
                  )),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                child: Center(child: Text("View history on website!")),
              )
            ]),
          ],
        ));
  }
}
