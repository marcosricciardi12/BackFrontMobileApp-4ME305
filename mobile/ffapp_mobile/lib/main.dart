import 'package:flutter/material.dart';
import 'package:ffapp_mobile/pages/myhomepage.dart';

void main() => runApp(const MobileApp());

class MobileApp extends StatelessWidget {
  const MobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Mobile App",
      home: MyHomePage(),
    );
  }
}
