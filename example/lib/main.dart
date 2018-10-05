import 'package:flutter/material.dart';
import 'package:flutter_spotlight/flutter_spotlight.dart';
import 'dart:async';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
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
          style: ThemeData.dark().textTheme.caption.copyWith(color: Colors.white),
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
      onTap: _onTap,
      color: Color.fromRGBO(0, 0, 0, 0.8),
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
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