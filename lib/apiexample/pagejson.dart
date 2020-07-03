import 'dart:convert';

import 'package:api/apiexample/page_model.dart';
 import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class pagejson extends StatefulWidget {

  @override
  _JsoncodeState createState() => _JsoncodeState();
}

class _JsoncodeState extends State<pagejson> {
  Future<String> loadPersonFromAssets() async {
    return await rootBundle.loadString('json/page.json');
  }

  Future loadPerson() async {
    String jsonString = await loadPersonFromAssets();
    final jsonResponse = json.decode(jsonString);
    Page person = new Page.fromJson(jsonResponse);
    print('total_pages: ${person.total_pages}');
    print('auther: ${person.auther.last_name}');
    print('data: ${person.data[1].first_name}');
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
