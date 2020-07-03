/*
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:math';

void main() => runApp(Gooey());

class Gooey extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: GooeyCarousel(),
        ),
      ),
    );
  }
}

enum Side { left, top, right, bottom }

class GooeyCarousel extends StatefulWidget {
  final List<Widget> children;

  GooeyCarousel({this.children}) : super();

  @override
  GooeyCarouselState createState () => GooeyCarouselState();
}

class GooeyCarouselState extends State<GooeyCarousel> with SingleTickerProviderStateMixin {
  int _index = 0; // index of the base (bottom) child
  int _dragIndex; // index of the top child
  Offset _dragOffset; // starting offset of the drag
  double _dragDirection; // +1 when dragging left to right, -1 for right to left
  bool _dragCompleted; // has the drag successfully resulted in a swipe
  Image _blueImage;
  Image _redImage;
  Image _yellowImage;
  Image _blueBg;
  Image _redBg;
  Image _yellowBg;

  GooeyEdge _edge;
  Ticker _ticker;
  GlobalKey _key = GlobalKey();

  @override
  void initState() {
    _edge = GooeyEdge(count: 25);
    _ticker = createTicker(_tick)..start();
    _blueImage = Image.network('https://firebasestorage.googleapis.com/v0/b/vgv-flutter-vignettes.appspot.com/o/gooey_edge%2FIllustration-Blue.png?alt=media&token=7a55c1fc-0cb1-4f98-bafd-81780cd42775',);
    _redImage = Image.network('https://firebasestorage.googleapis.com/v0/b/vgv-flutter-vignettes.appspot.com/o/gooey_edge%2FIllustration-Red.png?alt=media&token=69eef39d-b806-49c1-943c-1e5c5173859a',);
    _yellowImage = Image.network('https://firebasestorage.googleapis.com/v0/b/vgv-flutter-vignettes.appspot.com/o/gooey_edge%2FIllustration-Yellow.png?alt=media&token=bcd5498e-8745-43a4-8938-d9fc69d58b49',);
    _blueBg = Image.network(
      'https://firebasestorage.googleapis.com/v0/b/vgv-flutter-vignettes.appspot.com/o/gooey_edge%2FBg-Blue.png?alt=media&token=e00eaf19-3a5f-4133-a0f7-68ab7afe95ab',
      fit: BoxFit.cover,);
    _yellowBg = Image.network(
      'https://firebasestorage.googleapis.com/v0/b/vgv-flutter-vignettes.appspot.com/o/gooey_edge%2FBg-Yellow.png?alt=media&token=a012c201-a8a4-4ec2-854c-acc92c291113',
      fit: BoxFit.cover,);
    _redBg = Image.network(
      'https://firebasestorage.googleapis.com/v0/b/vgv-flutter-vignettes.appspot.com/o/gooey_edge%2FBg-Red.png?alt=media&token=bc44fec1-89fd-41d3-baca-85fadad5e5f0',
      fit: BoxFit.cover,);


    super.initState();
  }

  @override
  void didChangeDependencies() {
    precacheImage(_blueImage.image, context);
    precacheImage(_yellowImage.image, context);
    precacheImage(_redImage.image, context);
    precacheImage(_blueBg.image, context);
    precacheImage(_yellowBg.image, context);
    precacheImage(_redBg.image, context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _tick(Duration duration) {
    _edge.tick(duration);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        key: _key,
        onPanDown: (details) => _handlePanDown(details, _getSize()),
        onPanUpdate: (details) => _handlePanUpdate(details, _getSize()),
        onPanEnd: (details) => _handlePanEnd(details, _getSize()),
        child: Stack(
          children: <Widget>[
            cards(_index % 3),
            _dragIndex == null
                ? SizedBox()
                : ClipPath(
              child: cards(_dragIndex % 3),
              clipBehavior: Clip.hardEdge,
              clipper: GooeyEdgeClipper(_edge, margin: 10.0),
            ),
          ],
        ));
  }

  Widget cards(int index) {
    if (index == 0) {
      return ContentCard(
        index: index,
        color: Color.fromARGB(255, 53, 101, 248),
        image: _redImage,
        background: _redBg,
      );
    }
    if (index == 1) {
      return ContentCard(
        index: index,
        color: Color.fromARGB(255, 240, 101, 79),
        image: _blueImage,
        background: _blueBg,
      );
    }
    if (index == 2) {
      return ContentCard(
        index: index,
        color: Color.fromARGB(255, 240, 147, 61),
        image: _yellowImage,
        background: _yellowBg,
      );
    }
    return Container();
  }

  Size _getSize() {
    final RenderBox box = _key.currentContext.findRenderObject();
    return box.size;
  }

  void _handlePanDown(DragDownDetails details, Size size) {
    if (_dragIndex != null && _dragCompleted) {
      _index = _dragIndex;
    }
    _dragIndex = null;
    _dragOffset = details.localPosition;
    _dragCompleted = false;
    _dragDirection = 0;

    _edge.farEdgeTension = 0.0;
    _edge.edgeTension = 0.01;
    _edge.reset();
  }

  void _handlePanUpdate(DragUpdateDetails details, Size size) {
    double dx = details.globalPosition.dx - _dragOffset.dx;

    if (!_isSwipeActive(dx)) {
      return;
    }
    if (_isSwipeComplete(dx, size.width)) {
      return;
    }

    if (_dragDirection == -1) {
      dx = size.width + dx;
    }
    _edge.applyTouchOffset(Offset(dx, details.localPosition.dy), size);
  }

  bool _isSwipeActive(double dx) {
    // check if a swipe is just starting:
    if (_dragDirection == 0.0 && dx.abs() > 20.0) {
      _dragDirection = dx.sign;
      _edge.side = _dragDirection == 1.0 ? Side.left : Side.right;
      setState(() {
        _dragIndex = _index - _dragDirection.toInt();
      });
    }
    return _dragDirection != 0.0;
  }

  bool _isSwipeComplete(double dx, double width) {
    if (_dragDirection == 0.0) {
      return false;
    } // haven't started
    if (_dragCompleted) {
      return true;
    } // already done

    // check if swipe is just completed:
    double availW = _dragOffset.dx;
    if (_dragDirection == 1) {
      availW = width - availW;
    }
    double ratio = dx * _dragDirection / availW;

    if (ratio > 0.8 && availW / width > 0.5) {
      _dragCompleted = true;
      _edge.farEdgeTension = 0.01;
      _edge.edgeTension = 0.0;
      _edge.applyTouchOffset();
    }
    return _dragCompleted;
  }

  void _handlePanEnd(DragEndDetails details, Size size) {
    _edge.applyTouchOffset();
  }
}

class ContentCard extends StatefulWidget {
  final Color color;
  final int index;
  final Widget image;
  final Widget background;

  ContentCard({this.color, this.index, this.image, this.background}) : super();

  @override
  _ContentCardState createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> {
  Ticker _ticker;
  @override
  void initState() {
    _ticker = Ticker((d) {
      setState(() {});
    })
      ..start();
    super.initState();
  }
  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var time = DateTime.now().millisecondsSinceEpoch / 2000;
    var scaleX = 1.2 + sin(time) * .05;
    var scaleY = 1.2 + cos(time) * .07;
    var offsetY = 20 + cos(time) * 20;
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: <Widget>[
        Transform(
          transform: Matrix4.diagonal3Values(scaleX, scaleY, 1),
          child: Transform.translate(
            offset: Offset(-(scaleX - 1) / 2 * size.width, -(scaleY - 1) / 2 * size.height + offsetY),
            child: widget.background,
          ),
        ),
        Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: Container(
                      child: widget.image,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                    )),
                _buildPageIndicator(this.widget.index),
              ],
            ))
      ],
    );
  }

  Widget _buildPageIndicator(int index) {
    return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text("SWIPE",
                        style: TextStyle(color: Colors.white)
                    ),
                    Icon(Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ]
              ),
            ),
            _indicator(0),
            SizedBox(
              width: 10,
            ),
            _indicator(1),
            SizedBox(
              width: 10,
            ),
            _indicator(2),
            Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Icon(Icons.arrow_back,
                      color: Colors.white,
                    ),
                    Text("SWIPE",
                        style: TextStyle(color: Colors.white)
                    ),
                  ]
              ),
            ),
          ],
        )
    );
  }

  Widget _indicator(int idx) {
    BoxDecoration _selected =
    BoxDecoration(color: Colors.white, shape: BoxShape.circle);
    BoxDecoration _unselected = BoxDecoration(
      border: Border.all(color: Colors.white),
      shape: BoxShape.circle,
    );
    return Container(
      decoration: this.widget.index == idx ? _selected : _unselected,
      height: 30,
      width: 30,
      //  width: 30,
    );
  }
}

class GooeyEdge {
  List<_GooeyPoint> points;
  Side side;
  double edgeTension = 0.01;
  double farEdgeTension = 0.0;
  double touchTension = 0.1;
  double pointTension = 0.25;
  double damping = 0.9;
  double maxTouchDistance = 0.15;
  int lastT = 0;

  FractionalOffset touchOffset;

  GooeyEdge({count = 10, this.side = Side.left}) {
    points = [];
    for (int i = 0; i < count; i++) {
      points.add(_GooeyPoint(0.0, i / (count - 1)));
    }
  }

  void reset() {
    points.forEach((pt) => pt.x = pt.velX = pt.velY = 0.0);
  }

  void applyTouchOffset([Offset offset, Size size]) {
    if (offset == null) {
      touchOffset = null;
      return;
    }
    FractionalOffset o = FractionalOffset.fromOffsetAndSize(offset, size);
    if (side == Side.left) {
      touchOffset = o;
    } else if (side == Side.right) {
      touchOffset = FractionalOffset(1.0 - o.dx, 1.0 - o.dy);
    } else if (side == Side.top) {
      touchOffset = FractionalOffset(o.dy, 1.0 - o.dx);
    } else {
      touchOffset = FractionalOffset(1.0 - o.dy, o.dx);
    }
  }

  Path buildPath(Size size, {double margin = 0.0}) {
    if (points == null || points.length == 0) {
      return null;
    }

    Matrix4 mtx = _getTransform(size, margin);

    Path path = Path();
    int l = points.length;
    Offset pt = _GooeyPoint(-margin, 1.0).toOffset(mtx), pt1;
    path.moveTo(pt.dx, pt.dy); // bl

    pt = _GooeyPoint(-margin, 0.0).toOffset(mtx);
    path.lineTo(pt.dx, pt.dy); // tl

    pt = points[0].toOffset(mtx);
    path.lineTo(pt.dx, pt.dy); // tr

    pt1 = points[1].toOffset(mtx);
    path.lineTo(pt.dx + (pt1.dx - pt.dx) / 2, pt.dy + (pt1.dy - pt.dy) / 2);

    for (int i = 2; i < l; i++) {
      pt = pt1;
      pt1 = points[i].toOffset(mtx);
      double midX = pt.dx + (pt1.dx - pt.dx) / 2;
      double midY = pt.dy + (pt1.dy - pt.dy) / 2;
      path.quadraticBezierTo(pt.dx, pt.dy, midX, midY);
    }

    path.lineTo(pt1.dx, pt1.dy); // br
    path.close(); // bl

    return path;
  }

  void tick(Duration duration) {
    if (points == null || points.length == 0) {
      return;
    }
    int l = points.length;
    double t = min(1.5, (duration.inMilliseconds - lastT) / 1000 * 60);
    lastT = duration.inMilliseconds;
    double dampingT = pow(damping, t);

    for (int i = 0; i < l; i++) {
      _GooeyPoint pt = points[i];
      pt.velX -= pt.x * edgeTension * t;
      pt.velX += (1.0 - pt.x) * farEdgeTension * t;
      if (touchOffset != null) {
        double ratio =
        max(0.0, 1.0 - (pt.y - touchOffset.dy).abs() / maxTouchDistance);
        pt.velX += (touchOffset.dx - pt.x) * touchTension * ratio * t;
      }
      if (i > 0) {
        _addPointTension(pt, points[i - 1].x, t);
      }
      if (i < l - 1) {
        _addPointTension(pt, points[i + 1].x, t);
      }
      pt.velX *= dampingT;
    }

    for (int i = 0; i < l; i++) {
      _GooeyPoint pt = points[i];
      pt.x += pt.velX * t;
    }
  }

  Matrix4 _getTransform(Size size, double margin) {
    bool vertical = side == Side.top || side == Side.bottom;
    double w = (vertical ? size.height : size.width) + margin * 2;
    double h = (vertical ? size.width : size.height) + margin * 2;

    Matrix4 mtx = Matrix4.identity()
      ..translate(-margin, 0.0)
      ..scale(w, h);
    if (side == Side.top) {
      mtx
        ..rotateZ(pi / 2)
        ..translate(0.0, -1.0);
    } else if (side == Side.right) {
      mtx
        ..rotateZ(pi)
        ..translate(-1.0, -1.0);
    } else if (side == Side.bottom) {
      mtx
        ..rotateZ(pi * 3 / 2)
        ..translate(-1.0, 0.0);
    }

    return mtx;
  }

  void _addPointTension(_GooeyPoint pt0, double x, double t) {
    pt0.velX += (x - pt0.x) * pointTension * t;
  }
}

class _GooeyPoint {
  double x;
  double y;
  double velX = 0.0;
  double velY = 0.0;

  _GooeyPoint([this.x = 0.0, this.y = 0.0]);

  Offset toOffset([Matrix4 transform]) {
    Offset o = Offset(x, y);
    if (transform == null) {
      return o;
    }
    return MatrixUtils.transformPoint(transform, o);
  }
}

class GooeyEdgeClipper extends CustomClipper<Path> {
  GooeyEdge edge;
  double margin;

  GooeyEdgeClipper(this.edge, {this.margin = 0.0}) : super();

  @override
  Path getClip(Size size) {
    return edge.buildPath(size, margin: margin);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

*/
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(NeumorphicClock());

class NeumorphicClock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: AnalogClock(),
      ),
    );
  }
}

final radiansPerTick = pi / 180 * (360 / 60);
final radiansPerHour = pi / 180 * (360 / 12);

class AnalogClock extends StatefulWidget {

  @override
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  var _now = DateTime.now();
  bool isDark = true;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    // Set the initial values.
    _updateTime();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedTheme(
      data: ThemeData(
          brightness: isDark ? Brightness.dark : Brightness.light,
          // Hour & Minute hand.
          primaryColor: isDark ? Colors.grey[400] : Colors.grey[800],
          // Second hand.
          accentColor: Colors.red[800],
          // Tick color
          cursorColor: Colors.grey[900],
          // Shadow color
          canvasColor: isDark ? Colors.grey[900] : Colors.grey[500],
          // Inner shadow color
          dividerColor: isDark ? Colors.grey[900] : Colors.grey[400],
          // Inner Highlight Color
          highlightColor: isDark ? Colors.white.withOpacity(0.08) : Colors.white.withOpacity(0.7),
          backgroundColor: isDark ? Color(0xFF3C4043) : Colors.grey[300],
          textTheme: Theme.of(context).textTheme,
          // switch theme
          toggleableActiveColor: Colors.grey[500],
          // icon colors
          iconTheme: IconThemeData(
              color: Colors.grey[600]
          )
      ),
      child: Builder(
          builder: (context) {
            return Container(
              color: Theme.of(context).backgroundColor,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child:AspectRatio(
                        aspectRatio: 1,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final unit = constraints.biggest.height / 25;

                            return ClockData(
                              time: _now,
                              unit: unit,
                              child: Container(
                                padding: EdgeInsets.all(2 * unit),
                                color: Theme.of(context).backgroundColor,
                                child: Stack(
                                  children: [
                                    OuterShadows(),
                                    InnerShadows(),
                                    ClockTicks(),
                                    HourHandShadow(),
                                    MinuteHandShadow(),
                                    SecondHandShadow(),
                                    HourHand(),
                                    MinuteHand(),
                                    SecondHand(),
                                    SecondHandCircle(),
                                    ClockPin(),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.wb_sunny,
                          ),
                          Switch(
                            value: isDark,
                            onChanged: (v) => setState(() => isDark = v),
                          ),
                          Icon(Icons.brightness_3,

                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
      ),
    );
  }
}

class ClockData extends InheritedWidget {
  final DateTime time;
  final double unit;
  @override final Widget child;

  ClockData({
    @required this.time,
    @required this.unit,
    @required this.child,
  });

  @override
  bool updateShouldNotify(ClockData oldWidget)
  => oldWidget.time != time && oldWidget.unit != unit;

  static ClockData of(BuildContext context)
  => context.dependOnInheritedWidgetOfExactType<ClockData>();
}

abstract class Hand extends StatelessWidget {
  /// Create a const clock [Hand].
  ///
  /// All of the parameters are required and must not be null.
  const Hand({
    @required this.color,
    @required this.size,
    @required this.angleRadians,
  })  : assert(color != null),
        assert(size != null),
        assert(angleRadians != null);

  final Color color;
  final double size;
  final double angleRadians;
}

class ContainerHand extends Hand {
  const ContainerHand({
    @required Color color,
    @required double size,
    @required double angleRadians,
    this.child,
  })  : assert(size != null),
        assert(angleRadians != null),
        super(
        color: color,
        size: size,
        angleRadians: angleRadians,
      );

  /// The child widget used as the clock hand and rotated by [angleRadians].
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: Transform.rotate(
          angle: angleRadians,
          alignment: Alignment.center,
          child: Transform.scale(
            scale: size,
            alignment: Alignment.center,
            child: Container(
              color: color,
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedContainerHand extends StatelessWidget {
  const AnimatedContainerHand({
    Key key,
    @required int now,
    @required Widget child,
    @required double size,
  })  : _now = now,
        _child = child,
        _size = size,
        super(key: key);

  final int _now;
  final Widget _child;
  final double _size;

  @override
  Widget build(BuildContext context) {
    if (_now == 0) {
      return TweenAnimationBuilder<double>(
        key: ValueKey('special_case_when_overflowing'),
        duration: Duration(milliseconds: 300),
        tween: Tween<double>(
          begin: value(_now - 1),
          end: value(_now),
        ),
        curve: Curves.easeInQuint,
        builder: (context, anim, child) {
          return ContainerHand(
            color: Colors.transparent,
            size: _size,
            angleRadians: anim,
            child: child,
          );
        },
        child: _child,
      );
    }
    return TweenAnimationBuilder<double>(
      key: ValueKey('normal_case'),
      duration: Duration(milliseconds: 300),
      tween: Tween<double>(
        begin: value(_now - 1),
        end: value(_now),
      ),
      curve: Curves.easeInQuint,
      builder: (context, anim, child) {
        return ContainerHand(
          color: Colors.transparent,
          size: _size,
          angleRadians: anim,
          child: child,
        );
      },
      child: _child,
    );
  }

  double value(int second) {
    return second * radiansPerTick;
  }
}

class OuterShadows extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final unit = ClockData.of(context).unit;
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).highlightColor,
            offset: Offset(-unit / 2, -unit / 2),
            blurRadius: 1.5 * unit,
          ),
          BoxShadow(
            color: Theme.of(context).dividerColor.withOpacity(0.5),
            offset: Offset(unit / 2, unit / 2),
            blurRadius: 1.5 * unit,
          ),
        ],
      ),
    );
  }
}

class InnerShadows extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final unit = ClockData.of(context).unit;
    return Padding(
      padding: EdgeInsets.all(1.5 * unit),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).dividerColor.withOpacity(0.3),
              offset: Offset(-unit / 2, -unit / 2),
              blurRadius: 0.5 * unit,
            ),
            BoxShadow(
              color: Theme.of(context).highlightColor,
              offset: Offset(unit / 2, unit / 2),
              blurRadius: 0.5 * unit,
            ),

          ],
        ),
      ),
    );
  }
}

class ClockTicks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final unit = ClockData.of(context).unit * 0.8;
    return Stack(
      children: <Widget>[
        for (var i = 0; i < 12; i++)
          Center(
            child: Transform.rotate(
              // convert degrees to radians
              angle:  pi / 180 * 360 / 12 * i,
              child: Transform.translate(
                offset: Offset(0, i % 3 == 0 ? -9.7 * unit : -10.2 * unit),
                child: Container(
                  color: Colors.black.withOpacity(0.7),
                  height: i % 3 == 0 ? 3.0 * unit : 2.0 * unit,
                  width: i % 3 == 0 ? 0.3 * unit : 0.2 * unit,
                ),
              ),
            ),
          )
      ],
    );
  }
}

class HourHandShadow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final unit = ClockData.of(context).unit;
    final time = ClockData.of(context).time;
    return Transform.translate(
      offset: Offset(unit / 4, unit / 5),
      child: Padding(
        padding: EdgeInsets.all(2 * unit),
        child: ContainerHand(
          color: Colors.transparent,
          size: 0.5,
          angleRadians:
          time.hour * radiansPerHour + (time.minute / 60) * radiansPerHour,
          child: Transform.translate(
            offset: Offset(0.0, -3 * unit),
            child: Container(
              width: 1.5 * unit,
              height: 7 * unit,
              decoration: BoxDecoration(
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).canvasColor,
                    blurRadius: unit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MinuteHandShadow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final unit = ClockData.of(context).unit;
    return Transform.translate(
      offset: Offset(unit / 3, unit / 3),
      child: Padding(
        padding: EdgeInsets.all(2 * unit),
        child: AnimatedContainerHand(
          size: 0.5,
          now: ClockData.of(context).time.minute,
          child: Transform.translate(
            offset: Offset(0.0, -8 * unit),
            child: Container(
              width: unit / 2,
              height: unit * 15,
              decoration: BoxDecoration(
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).canvasColor,
                    blurRadius: unit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SecondHandShadow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final unit = ClockData.of(context).unit;
    return Transform.translate(
      offset: Offset(unit / 2, unit / 1.9),
      child: AnimatedContainerHand(
        now: ClockData.of(context).time.second,
        size: 0.6,
        child: Transform.translate(
          offset: Offset(0.0, -4 * unit),
          child: Container(
            width: unit / 3,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.transparent,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).canvasColor,
                  blurRadius: unit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HourHand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final unit = ClockData.of(context).unit;
    final time = ClockData.of(context).time;
    return Padding(
      padding: EdgeInsets.all(2 * unit),
      child: ContainerHand(
        color: Colors.transparent,
        size: 0.5,
        angleRadians:
        time.hour * radiansPerHour + (time.minute / 60) * radiansPerHour,
        child: Transform.translate(
          offset: Offset(0.0, -3 * unit),
          child: Container(
            width: 1.5 * unit,
            height: 7 * unit,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}

class MinuteHand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final unit = ClockData.of(context).unit;
    return Padding(
      padding: EdgeInsets.all(2 * unit),
      child: AnimatedContainerHand(
        size: 0.5,
        now: ClockData.of(context).time.minute,
        child: Transform.translate(
          offset: Offset(0.0, -8 * unit),
          child: Container(
            width: unit / 2,
            height: unit * 15,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}

class SecondHand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final second = ClockData.of(context).time.second;
    final unit = ClockData.of(context).unit;
    return AnimatedContainerHand(
      now: second,
      size: 0.6,
      child: Transform.translate(
        offset: Offset(0.0, -4 * unit),
        child: Container(
          width: unit / 2,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}

class SecondHandCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final unit = ClockData.of(context).unit;
    return AnimatedContainerHand(
      now: ClockData.of(context).time.second,
      size: 0.6,
      child: Transform.translate(
        offset: Offset(0.0, 4 * unit),
        child: Container(
          width: 2 * unit,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}

class ClockPin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 0.8 * ClockData.of(context).unit,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}