import 'dart:convert';

import 'package:api/image.dart';
import 'package:api/news_src/print_data_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PrintData extends StatefulWidget {
  @override
  _SrvicesState createState() => _SrvicesState();

  static List<Article> parsfromJsonephotos(String responseBody) {
    final parsed = json.decode(responseBody) ;
    var rest = parsed["articles"] as List;
//    print(rest);
//    list = rest.map<Article>((json) => Article.fromJson(json)).toList();
    return rest.map<Article>((json) => Article.fromJson(json)).toList();
  }



}

class _SrvicesState extends State<PrintData> {

  static const String url =
      "https://newsapi.org/v2/top-headlines?country=in&apiKey=ae6c3c0f9d8e485a98fd70edcff81134";

  @override
  void initState() {
    super.initState();
//    loadPerson();
  }

  static Future<List<Article>> getphotoss() async {
    List<Article> list;
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {


        var data = json.decode(response.body);
        var rest = data["articles"] as List;
        print(rest);
        list = rest.map<Article>((json) => Article.fromJson(json)).toList();

        print("List Size: ${list.length}");
        return list;

//        List<Article> list = parsfromJsonephotos(response.body);
//        return list;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }



  Future loadPerson() async {

    print('Loading.........');
     getphotoss().then((List<Article> Article) {
      print('Details: ${Article[1].author}');
    });
  }



  Widget listViewWidget(List<Article> article) {
/*
    print('total_pages: ${article[0].title }');
*/
    return Container(

      child: ListView.builder(
          itemCount: article.length,
          padding: const EdgeInsets.all(2.0),
          itemBuilder: (context, position) {
            return Card(
              child: Container(
                height: 120.0,
                width: 120.0,
                child: Center(
                  child: ListTile(
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        '${article[position].author}',

                      ),
                    ),
                    title: Text(
                      '${article[position].title}',
                      style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    leading: Container(
                      height: 100.0,
                      width: 100.0,
                      child: article[position].urlToImage == null
                          ? Image.asset(
                        'images/no_image_available.png',
                        height: 70,
                        width: 70,
                      )
                          : Image.network(
                        '${article[position].urlToImage}',
                        height: 70,
                        width: 70,
                      ),
                    ),

                  ),
                ),
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Appbar'),
      ),
      body: FutureBuilder(
          future:  getphotoss(),
          builder: (context, snapshot) {
            return snapshot.data != null
                ? listViewWidget(snapshot.data)
                : Center(child: CircularProgressIndicator());
          }),
    );
  }
}
