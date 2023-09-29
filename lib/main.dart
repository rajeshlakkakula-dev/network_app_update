import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

// Fetch Data

Future<Album> fetchAlbum() async {
  final response = await http
      .get(Uri.parse("https://jsonplaceholder.typicode.com/albums/1"));

  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

// Http Request to update the data
Future<Album> updateAlbum(String title) async {
  final response =
      await http.put(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{'title': title}));

  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to update album');
  }
}

// Album -> To convert the json data to Obj and display to user
class Album {
  final int id;
  final String title;

  Album({required this.id, required this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(id: json['id'], title: json['title']);
  }
}

// Display the data and update th data

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController _controller = TextEditingController();
  late Future<Album> _futureAlbum;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Update Data"),
        ),
        body: Container(
            child: FutureBuilder<Album>(
          future: _futureAlbum,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(snapshot.data!.title),
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(hintText: "Enter Title"),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _futureAlbum = updateAlbum(_controller.text);
                          });
                        },
                        child: Text('Update Data'))
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
            }

            return CircularProgressIndicator();
          },
        )),
      ),
    );
  }
}
