import 'dart:math';

import 'package:api/photomodel.dart';
import 'package:flutter/material.dart';

class image extends StatelessWidget {
  final List<photo> photos;

  image({Key key, this.photos, this.jsondata}) : super(key: key);
  final String jsondata;

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(

        body: Image.network(jsondata
        ),
      ),
    );
  }
}
