// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffapp_mobile/pages/userinpage.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class QrScannePage extends StatefulWidget {
  const QrScannePage({Key? key}) : super(key: key);

  @override
  State<QrScannePage> createState() => _QrScannePageState();
}

class _QrScannePageState extends State<QrScannePage> {
  MobileScannerController cameraController = MobileScannerController();
  bool _screenOpened = false;
  late String token = "";
  late bool _sendingData = false;

  bool getJWT() {
    late bool status = false;
    SharedPreferences.getInstance().then((value) {
      token = value.getString("access_token")!;
      if (token.isNotEmpty) {
        print("HAY TOKEN");
        status = true;
      } else {
        print("No hay token");
        status = false;
      }
    });
    return status;
    //Return String
  }

  void loginUser(
    String? randomID,
  ) {
    getJWT();
    postData(randomID);
  }

  void postData(String? randomID) async {
    try {
      print("SALE MANDAR DATA QR");
      _watingResponse();
      final response = await http
          .post(
            Uri.parse('http://151.252.176.107:5000/login/$randomID'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{"access_token": token}),
          )
          .timeout(Duration(seconds: 3));
      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserInPage()),
        );
        _thereisResponse();
      }
    } on TimeoutException catch (e) {
      print('Timeout');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mobile Scanner')),
      body: MobileScanner(
        // fit: BoxFit.contain,
        controller: MobileScannerController(
          facing: CameraFacing.back,
          torchEnabled: false,
        ),
        onDetect: (capture) async {
          if (!_sendingData) {
            final List<Barcode> barcodes = capture.barcodes;
            final Uint8List? image = capture.image;
            for (final barcode in barcodes) {
              print(_sendingData);

              debugPrint('Barcode found! ${barcode.rawValue}');
              loginUser(barcode.rawValue);
            }
          }
        },
      ),
    );
  }
}
