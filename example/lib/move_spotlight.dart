import 'package:flutter/material.dart';
import 'package:flutter_spotlight/flutter_spotlight.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Spotlight Demo',
      home: MyHomePage(title: 'Flutter Spotlight Movable Demo'),
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
  Offset _center;
  double _radius = 50.0;

  void _onPointerMove(PointerMoveEvent event) {
    setState(() {
      _center = event.position;
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    setState(() {
      _center = event.position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Container(
          constraints: BoxConstraints.expand(),
          color: Colors.amber,
          child: Listener(
            onPointerMove: _onPointerMove,
            onPointerUp: _onPointerUp,
            child: Spotlight(
              center: _center,
              radius: _radius,
              ignoring: false,
              color: Color.fromRGBO(0, 0, 0, 0.95),
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
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
