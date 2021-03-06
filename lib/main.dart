import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

const url = 'https://api.tibiadata.com/v2/characters/';

void main() {
  runApp(MyApp());
}

Future<Map> getCharData({String name}) async {
  if (name.isNotEmpty) {
    http.Response response = await http.get(url + name + '.json');
    return json.decode(response.body);
  }
  return null;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tibia Info',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 124, 0, 1),
      body: SingleChildScrollView(
        child: Column(            
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 300,              
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(90),
                      bottomRight: Radius.circular(90)
                    ),
                    color: Colors.red,
                  )
                ),
                Padding(
                  padding: EdgeInsets.only(top: 70.0, left: 30.0, right: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Tibia', style: TextStyle(
                        color: Colors.white,
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold
                      )),
                      Text('Information', style: TextStyle(
                        color: Colors.white,
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold
                      )),
                      Divider(),
                      Material(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            labelText: 'Character Name',
                            labelStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 13)                            
                          ),
                          style: TextStyle(
                            fontSize: 20.0
                          ),
                          onSubmitted: (string) {
                            setState(() {
                              searchController.text = string;
                            });                            
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            FutureBuilder<Map> (
              future: getCharData(name: searchController.text),
              builder: (content, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child: Text('Fetching data...'),
                    );                    
                    break;

                  default:
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('API Error'),
                      );
                    } else if (snapshot.data == null) {
                      return Center(
                        child: Text(''),
                      );
                    } else {                      
                      return charInfoScreen(snapshot.data);
                    }
                }
              },
            )
          ],
        ),
      )
    );
  }
}

Widget charInfoScreen(Map<String, dynamic> data) {
  String vocation = data['characters']['data']['vocation'];
  String name = data['characters']['data']['name'];
  String world = data['characters']['data']['world'];
  String residence = data['characters']['data']['residence'];
  String sex = data['characters']['data']['sex'];
  int level = data['characters']['data']['level'];

  return Padding (
    padding: EdgeInsets.only(top: 15.0),
    child: Card(  
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Image.asset('assets/images/tibia_icon.png',
              height: 60.0,
            ),
            title: Text('$name', style: TextStyle(
              fontSize: 50.0,
              fontFamily: 'Pacifico'
            )),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Divider(),
                Text('Level: $level', style: TextStyle(
                  fontSize: 20.0
                )),
                Text('Vocation: $vocation', style: TextStyle(
                  fontSize: 20.0
                )),
                Text('World: $world', style: TextStyle(
                  fontSize: 20.0
                )),
                Text('Residence: $residence', style: TextStyle(
                  fontSize: 20.0
                )),
                Text('Sex: $sex', style: TextStyle(
                  fontSize: 20.0
                ))
              ],
            ),
          )
        ],
      ),
    )
  );
}