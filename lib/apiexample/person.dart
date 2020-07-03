 import 'dart:convert';

import 'package:api/apiexample/person_model.dart';
import 'package:api/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class jsoncodeee extends StatefulWidget {

  @override
  _JsoncodeState createState() => _JsoncodeState();
}

class _JsoncodeState extends State<jsoncodeee> {
  Future<String> loadPersonFromAssets() async {
    return await rootBundle.loadString('json/person.json');
  }

  Future loadPerson() async {
    String jsonString = await loadPersonFromAssets();
    final jsonResponse = json.decode(jsonString);
    Person person = new Person.fromJson(jsonResponse);
    print('Name: ${person.name}');
    print('places: ${person.places}');
    print('Images: ${person.images[0].name}');
    print('Details: ${person.address.details.town}');
  }

  @override
  void initState(){
    super.initState();
    loadPerson();
  }

  @override
   Widget build(BuildContext context) {
     return Container();
   }
}
