import 'dart:convert';
import 'dart:math';

import 'package:api/apiexample/services.dart';
import 'package:api/image.dart';
import 'package:api/photomodel.dart';
import 'package:api/news_src/print_data.dart';
import 'package:api/news_src/ui/home_page.dart';
import 'package:api/news_src/ui/news_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'apiexample/pagejson.dart';
import 'apiexample/person.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // is not restarted.
       home: HomePage(  ),
    );
  }
}

Future<List<photo>> fetchPhotos(http.Client client) async {
  final response =
      await client.get('https://jsonplaceholder.typicode.com/photos');

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parsephotos, response.body);
}



List<photo> parsephotos(String responseBody) {
  final parsed = jsonDecode(responseBody).cast  <Map<String, dynamic>>();

  return parsed.map<photo>((json) => photo.fromJson(json)).toList();
}



class MyHomePage extends StatelessWidget {

  String title;
  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: FutureBuilder<List<photo>>(
              future: fetchPhotos(http.Client()),

              builder: (context, snapshot) {

                if (snapshot.hasError) print(snapshot.error);

                return snapshot.hasData
                    ? PhotosList(photos: snapshot.data)
                    : Center(child: CircularProgressIndicator());
              })),
    );
  }
}

class PhotosList extends StatelessWidget {
  final List<photo> photos;

  PhotosList({Key key, this.photos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(

      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,

      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {

        return GestureDetector(child: Image.network(photos[index].thumbnailUrl,color: Colors.primaries[Random().nextInt(Colors.primaries.length)]),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => image(jsondata: photos[index].url),
              ),
            );
          },);
      },
    );
  }
}
