import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ShadowDemo(),
      ),
    );
  }
}

class ShadowDemo extends StatefulWidget {
  @override
  _ShadowDemoState createState() => _ShadowDemoState();
}

class _ShadowDemoState extends State<ShadowDemo> {
  var _opacity = 1.0;
  var _xOffset = 0.0;
  var _yOffset = 0.0;
  var _blurRadius = 0.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 120.0),
          child: ClipRRect(
            child: Align(
              alignment: Alignment.topCenter,
              heightFactor: 01,
              child: Image.asset('images/youtube.png'),
            ),
          ),
        ),
        Center(
            child: Text(
              'Flutter',
              style: TextStyle(
                fontSize: 100,
                color: Colors.blue.shade700,
                shadows: [
                  Shadow(
                    color: Colors.blue.shade900.withOpacity(_opacity),
                    offset: Offset(_xOffset, _yOffset),
                    blurRadius: _blurRadius,
                  ),
                ],
              ),
            )),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              children: <Widget>[
                Spacer(),
                Slider(
                  activeColor: Colors.pink,
                  inactiveColor: Colors.green,
                  value: _opacity,
                  min: 0.0,
                  max: 1.0,
                  onChanged: (newValue) =>
                  {setState(() => _opacity = newValue)},
                ),
                Slider(
                  value: _xOffset,
                  min: -100,
                  max: 100,
                  onChanged: (newValue) =>
                  {setState(() => _xOffset = newValue)},
                ),
                Slider(
                  activeColor: Colors.pink,
                  inactiveColor: Colors.green,
                  value: _yOffset,
                  min: -100,
                  max: 100,
                  onChanged: (newValue) =>
                  {setState(() => _yOffset = newValue)},
                ),
                Slider(
                  value: _blurRadius,
                  min: 0,
                  max: 100,
                  onChanged: (newValue) =>
                  {setState(() => _blurRadius = newValue)},
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}