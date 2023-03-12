import 'package:ffapp_mobile/pages/init.dart';
import 'package:flutter/material.dart';
import 'package:ffapp_mobile/pages/myhomepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decode/jwt_decode.dart';

void main() => runApp(const MobileApp());

class MobileApp extends StatelessWidget {
  const MobileApp({super.key});

  // ignore: must_call_super

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Mobile App",
      home: InitPage(),
    );
  }
}
