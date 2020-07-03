import 'package:flutter/material.dart';

class LoadingBar extends StatelessWidget {

  var _loadImage = new AssetImage(
      'assets/img/basic2-090_loader_loading-512.png');
  var _myEarth = new NetworkImage(
      "http://qige87.com/data/out/73/wp-image-144183272.png");
  bool _checkLoaded = true;

  /*@override
  void initState() {
    _myEarth.resolve(new ImageConfiguration()).addListener((_, __) {
      if (mounted) {
        setState(() {
          _checkLoaded = false;
        });
    });      }

  }*/


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Center(child: new Container(
          decoration: new BoxDecoration(shape: BoxShape.circle,),
          height: 80.0,
          width: 80.0,
          child: new CircleAvatar(
            backgroundColor: Theme
                .of(context)
                .scaffoldBackgroundColor,
            backgroundImage: _checkLoaded ? _loadImage : _myEarth,
          ),)
        )
    );
  }
}
