import 'dart:convert';

 import 'package:api/apiexample/person_model.dart';
import 'package:api/photomodel.dart';
import 'package:flutter/material.dart';
 import 'package:http/http.dart' as http;

import '../api2.dart';
 void main() => runApp(Srvices());

class Srvices extends StatefulWidget {
  @override
  _SrvicesState createState() => _SrvicesState();

  static const String url = "https://jsonplaceholder.typicode.com/photos";

  static Future<List<photo>> getphotoss() async{
    try{

      final response = await http.get(url);
      if(response.statusCode == 200){
        List<photo> list = parsephotos(response.body).cast<photo>();
        return list;
      }
      else {
        throw Exception("Error");
      }
    }
    catch(e){
      throw Exception(e.toString());
    }
  }

  static List<photo> parsephotos(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<photo>((json) => photo.fromJson(json)).toList();
  }
}

class _SrvicesState extends State<Srvices> {



  Future loadPerson() async {

    print("Loading Photos...");
    Srvices.getphotoss().then((photo) {
//      int i;
//      for(i=0;i<photo.length;i++){
//        print('Album ${[i]}: ${photo[i].thumbnailUrl}');
//        print('Album ${[i]}: ${Image.network(photo[i].thumbnailUrl)}');
//      }
      print('Albums: ${photo.length}');

     });
  }

  @override
  void initState() {
    super.initState();
    loadPerson();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
  /*static const String url = "https://jsonplaceholder.typicode.com/albums/1";

  static Future<Person> getphotoss() async{
    try{
      final response = await http.get(url);
      if(response.statusCode == 200){
         return Person.fromJson(json.decode(response.body));
//        Person list = parsephotos(response.body) ;
//        return list;
      }
      else {
        throw Exception("Error");
      }
    }
    catch(e){
      throw Exception(e.toString());
    }
  }

  }
*/



/*class _SrvicesState extends State<Srvices> {



  Future loadPerson() async {

    print("Loading Photos...");
    Srvices.getphotoss().then((Person) {
//      int i;
//      for(i=0;i<photo.length;i++){
//        print('Album ${[i]}: ${photo[i].thumbnailUrl}');
//        print('Album ${[i]}: ${Image.network(photo[i].thumbnailUrl)}');
//      }
      print('Albums: ${Person.id}');

    });

  }

  @override
  void initState() {
    super.initState();
    loadPerson();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}*/
