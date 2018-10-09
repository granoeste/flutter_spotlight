import 'package:flutter/material.dart';
import 'package:flutter_spotlight/flutter_spotlight.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Spotlight Demo',
      home: MyHomePage(title: 'Flutter Spotlight Tageting Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final GlobalKey<_MyHomePageState> keySearch =
      GlobalKey<_MyHomePageState>();
  static final GlobalKey<_MyHomePageState> keySkipPrevious =
      GlobalKey<_MyHomePageState>();
  static final GlobalKey<_MyHomePageState> keyFastRewind =
      GlobalKey<_MyHomePageState>();
  static final GlobalKey<_MyHomePageState> keyPlay =
      GlobalKey<_MyHomePageState>();
  static final GlobalKey<_MyHomePageState> keyFastForward =
      GlobalKey<_MyHomePageState>();
  static final GlobalKey<_MyHomePageState> keySkipNext =
      GlobalKey<_MyHomePageState>();
  static final GlobalKey<_MyHomePageState> keyFab =
      GlobalKey<_MyHomePageState>();

  var targets = [
    [keySearch, "Search for videos"],
    [keySkipPrevious, "Skip to revious"],
    [keyFastRewind, "Rewind"],
    [keyPlay, "Play video"],
    [keyFastForward, "Forward"],
    [keySkipNext, "Skip to next"],
    [keyFab, "Add to favorites."],
  ];

  Size _size;
  Offset _center;
  double _radius = 50.0;
  bool _enabled = false;
  Widget _description;

  int _index = 0;

  spotlight(int index) {
    if (index >= targets.length) {
      index = 0;
      setState(() {
        _enabled = false;
      });
      return;
    }

    Rect target = Spotlight.getRectFromKey(targets[index][0]);
    debugPrint("Rect : $target");
    debugPrint("Size : $_size");

    setState(() {
      _enabled = true;
      _center = Offset(target.center.dx, target.center.dy);
      _radius = Spotlight.calcRadius(target);
      _description = Container(
        alignment: Alignment.center,
        child: Text(
          targets[index][1],
          style:
              ThemeData.dark().textTheme.caption.copyWith(color: Colors.white),
        ),
      );
    });
  }

  void _onTap() {
    _index++;
    spotlight(_index);
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3)).then((value) {
      spotlight(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;

    return Spotlight(
      center: _center,
      radius: _radius,
      enabled: _enabled,
      description: _description,
      animation: true,
      onTap: _onTap,
      color: Color.fromRGBO(0, 0, 0, 0.8),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
              key: keySearch,
              icon: Icon(Icons.search),
              tooltip: 'Open shopping cart',
              onPressed: () {
                debugPrint("onPressed");
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Container(
            constraints: BoxConstraints.expand(),
            color: Colors.amber,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                      color: Colors.green,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'images/lake.jpg',
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.skip_previous),
                                  onPressed: () {},
                                  key: keySkipPrevious,
                                ),
                                IconButton(
                                  icon: Icon(Icons.fast_rewind),
                                  onPressed: () {},
                                  key: keyFastRewind,
                                ),
                                IconButton(
                                  icon: Icon(Icons.play_arrow),
                                  onPressed: () {},
                                  key: keyPlay,
                                ),
                                IconButton(
                                  icon: Icon(Icons.fast_forward),
                                  onPressed: () {},
                                  key: keyFastForward,
                                ),
                                IconButton(
                                  icon: Icon(Icons.skip_next),
                                  onPressed: () {},
                                  key: keySkipNext,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          key: keyFab,
          onPressed: () {
            debugPrint("onPressed");
          },
          child: Icon(Icons.favorite_border),
        ),
      ),
    );
  }
}
