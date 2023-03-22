import 'dart:convert';
import 'package:ffapp_mobile/pages/userinpage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ffapp_mobile/models/menu.dart';
import 'package:http/http.dart' as http;
import 'package:ffapp_mobile/models/menus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:local_auth/local_auth.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late List<dynamic> listmenus;
  late List<int> cantmenu = [];
  late String token = "";
  late Map order = {};
  late int cantorder = 0;
  late double totalprice = 0.0;
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> auth_user() async {
    final bool didAuthenticate = await auth.authenticate(
        localizedReason:
            'Please authenticate to confirm your order and pay $totalprice',
        options: const AuthenticationOptions(biometricOnly: true));
    return didAuthenticate;
  }

  Future<Menus> fetchMenus() async {
    final response = await http.get(Uri.parse('${dotenv.env['URLAPI']}/menus'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Menus.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Menus');
    }
  }

  getMenus() {
    fetchMenus().then((value) => {
          setState(() {
            listmenus = value.menus;
            for (int i = 0; i < listmenus.length; i++) {
              cantmenu.add(0);
              print(cantmenu[i]);
            }
          }),
        });
  }

  Future<http.Response> neworder(List finalorder) async {
    try {
      final response = await http
          .post(
            Uri.parse('${dotenv.env['URLAPI']}/salesmanager/newsale'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              "Authorization": "Bearer $token",
            },
            body: jsonEncode(finalorder),
          )
          .timeout(Duration(seconds: 3));
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Order in process!'),
              backgroundColor: Color.fromARGB(183, 255, 115, 0)),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserInPage()),
        );
      }
      return response;
    } on TimeoutException catch (e) {
      print('Timeout');
      return http.Response("Bad Gateway", 504);
    }
  }

  gettoken() {
    SharedPreferences.getInstance().then((value) {
      token = value.getString("access_token")!;
      while (token == "" || token != value.getString("access_token")!) {
        token = value.getString("access_token")!;
      }
    });
  }

  @override
  initState() {
    super.initState();
    listmenus = [];
    getMenus();
    gettoken();
  }

  @override
  Widget build(BuildContext context) {
    if (listmenus.isEmpty) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 206, 108, 43),
            title: const Text("Please Wait!"),
            centerTitle: true,
          ),
          body: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(50),
            child: ListView(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: Center(child: CircularProgressIndicator()),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.all(30),
                  child: Center(
                      child: Text(
                    "Loading Menus!",
                    textAlign: TextAlign.center,
                  )),
                )
              ],
            ),
          ));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 206, 108, 43),
        centerTitle: true,
        title: const Text('Product List'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                if (cantorder > 0) {
                  auth_user().then((value) {
                    if (value) {
                      late List<dynamic> finalorder = [];
                      for (int i = 0; i < listmenus.length; i++) {
                        if (cantmenu[i] != 0) {
                          late Map order = {
                            "menu_id": listmenus[i]['id'],
                            "cant": cantmenu[i],
                          };
                          finalorder.add(order);
                        }
                      }
                      print(finalorder);
                      neworder(finalorder);
                    }
                  });
                }
              },
              icon: Icon(Icons.shopping_cart)),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(2, 0, 20, 0),
            child: Text("Cant: $cantorder \ntotal: $totalprice"),
          ),
        ],
      ),
      body: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
          shrinkWrap: true,
          itemCount: listmenus.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.blueGrey.shade200,
              elevation: 5.0,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image.network(
                      listmenus[index]['imageURL'].toString(),
                      height: 80,
                      width: 80,
                    ),
                    SizedBox(
                      width: 130,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5.0,
                          ),
                          RichText(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            text: TextSpan(
                                text: 'Menu: ',
                                style: TextStyle(
                                    color: Colors.blueGrey.shade800,
                                    fontSize: 16.0),
                                children: [
                                  TextSpan(
                                      text:
                                          '${listmenus[index]['name'].toString()}\n',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ]),
                          ),
                          RichText(
                            maxLines: 6,
                            text: TextSpan(
                                text: 'Description: ',
                                style: TextStyle(
                                    color: Colors.blueGrey.shade800,
                                    fontSize: 16.0),
                                children: [
                                  TextSpan(
                                      text:
                                          '${listmenus[index]['description'].toString()}\n',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ]),
                          ),
                          RichText(
                            maxLines: 3,
                            text: TextSpan(
                                text: 'Price: ' r"$",
                                style: TextStyle(
                                    color: Colors.blueGrey.shade800,
                                    fontSize: 16.0),
                                children: [
                                  TextSpan(
                                      text:
                                          '${listmenus[index]['price'].toString()}\n',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ]),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  if (cantmenu[index] > 0) {
                                    setState(() {
                                      cantmenu[index] = cantmenu[index] - 1;
                                      cantorder = cantorder - 1;
                                      totalprice = totalprice -
                                          listmenus[index]['price'];
                                    });
                                  }
                                },
                                icon: Icon(Icons.remove_circle)),
                            Center(child: Text("${cantmenu[index]}")),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    cantmenu[index] = cantmenu[index] + 1;
                                    cantorder = cantorder + 1;
                                    totalprice =
                                        totalprice + listmenus[index]['price'];
                                  });

                                  print(cantmenu[index]);
                                },
                                icon: Icon(Icons.add_circle))
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
