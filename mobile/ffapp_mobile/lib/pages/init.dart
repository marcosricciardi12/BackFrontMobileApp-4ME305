import 'package:ffapp_mobile/pages/myhomepage.dart';
import 'package:ffapp_mobile/pages/userinpage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decode/jwt_decode.dart';

class InitPage extends StatelessWidget {
  const InitPage({super.key});

  initState() async {
    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }

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

  @override
  Widget build(BuildContext context) {
    if (getJWT()) {
      return const UserInPage();
    } else {
      return const MyHomePage();
    }
  }
}
