import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ffapp_mobile/models/menu.dart';
import 'package:http/http.dart' as http;
import 'package:ffapp_mobile/models/menus.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late List<dynamic> listmenus;

  Future<Menus> fetchMenus() async {
    final response =
        await http.get(Uri.parse('http://151.252.176.107:5000/menus'));

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
          }),
        });
  }

  @override
  initState() {
    super.initState();
    listmenus = [];
    getMenus();
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
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(166, 255, 115, 0)),
                        onPressed: () {
                          // saveData(index);
                        },
                        child: const Text('Add to Cart')),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
