import 'package:ffapp_mobile/pages/myhomepage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decode/jwt_decode.dart';

class InitPage extends StatelessWidget {
  const InitPage({super.key});

  initState() async {
    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  @override
  Widget build(BuildContext context) {
    initState();
    return const MyHomePage();
  }
}
