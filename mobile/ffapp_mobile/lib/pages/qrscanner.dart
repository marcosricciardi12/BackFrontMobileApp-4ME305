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
  MobileScannerController cameraController = MobileScannerController(
    facing: CameraFacing.back,
    torchEnabled: false,
  );
  bool _screenOpened = false;
  late String token = "";
  late bool _sendingData = false;

  void loginUser(String? randomID, MobileScannerController camcontroller) {
    late bool status = false;
    SharedPreferences.getInstance().then((value) {
      token = value.getString("access_token")!;
      while (token == "" || token != value.getString("access_token")!) {
        token = value.getString("access_token")!;
      }
      print("el token a enviar es: " + token);
      if (token.isNotEmpty) {
        print("HAY TOKEN");
        status = true;
      } else {
        print("No hay token");
        status = false;
      }
      postData(randomID, camcontroller);
    });
  }

  void postData(String? randomID, MobileScannerController camcontroller) async {
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
      if (response.statusCode == 200 && token != "") {
        print(token);
        camcontroller.stop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('QR Scanned, redirecting in the WebSite!')),
        );
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

  void _setZoom() {
    setState(() {
      cameraController.setZoomScale(0.5);
    });
  }

  @override
  Widget build(BuildContext context) {
    _setZoom();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Website History'),
          backgroundColor: Color.fromARGB(255, 206, 108, 43),
          centerTitle: true,
        ),
        body: Stack(children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 50, 50, 250),
            child: MobileScanner(
              fit: BoxFit.cover,
              controller: cameraController,
              onStart: (init) {
                _setZoom();
              },
              onDetect: (capture) async {
                if (!_sendingData) {
                  final List<Barcode> barcodes = capture.barcodes;
                  final Uint8List? image = capture.image;
                  for (final barcode in barcodes) {
                    print(_sendingData);
                    debugPrint('Barcode found! ${barcode.rawValue}');
                    loginUser(barcode.rawValue, cameraController);
                  }
                }
              },
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child:
                Text("Scan QR code in the website!", textAlign: TextAlign.end),
          ),
          if (_sendingData)
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.all(100),
              child: CircularProgressIndicator(),
            ),
          if (_sendingData)
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.all(80),
              child: Text("Wating..."),
            )
        ]));
  }
}
