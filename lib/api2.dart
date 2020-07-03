import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'image.dart';

Future<List<Album>> fetchAlbum() async {
  final response =
//  await http.get('https://jsonplaceholder.typicode.com/albums/1');
      await http.get('https://jsonplaceholder.typicode.com/photos');
  return compute(parsephotos, response.body);
}

class Album {
  final int userId;
  final int id;
  final String title;
  final String titleee;

  Album({this.userId, this.id, this.title, this.titleee});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['thumbnailUrl'],
      titleee: json['title'],
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  final List<Album> title;

  MyApp({Key key, this.title}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

List<Album> parsephotos(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Album>((json) => Album.fromJson(json)).toList();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<List<Album>>(
            future: fetchAlbum(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return PhotosList(photos: snapshot.data);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors
                      .primaries[Random().nextInt(Colors.primaries.length)]));
            },
          ),
        ),
      ),
    );
  }
}

class PhotosList extends StatelessWidget {
  final List<Album> photos;

  PhotosList({Key key, this.photos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: photos.length,
          itemBuilder: (context, index) {
            return
/*
              GestureDetector(
              child: CachedNetworkImage(

                imageUrl: photos[index].title,
                placeholder: (context, url) => Image.network(

                  photos[index].title,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        image(jsondata: photos[index].titleee),
                  ),
                );
              },
            );*/

              CachedNetworkImage(
              imageUrl: photos[index].title,
              placeholder: (context, url) => GestureDetector(
                child: FadeInImage.assetNetwork(
                  placeholder: "images/top_news.png"
                  // your assets image path
                  ,
                  image: photos[index].title,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          image(jsondata: photos[index].titleee),
                    ),
                  );
                },
              ),
            );
            /*GestureDetector(
              child: Card(

                color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(13.0),
                ),
                child: Center(
                  child: Text(
                    photos[index].title,
                    style: TextStyle(
                        color: Colors
                            .primaries[Random().nextInt(Colors.primaries.length)]),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => image(jsondata: photos[index].title),
                  ),
                );
              },
            );*/
          },
        ),
      ),
    );
  }
}
