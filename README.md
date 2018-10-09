# flutter_spotlight

Spotlight for Flutter that lights items for tutorials etc...

[![pub package](https://img.shields.io/pub/v/flutter_spotlight.svg)](https://pub.dartlang.org/packages/flutter_spotlight)


## Simple Example

```dart
class _MyHomePageState extends State<MyHomePage> {
  Offset _center = Offset(100.0, 100.0); // Center position of Spotlight
  double _radius = 50.0; // Radius of Spotlight

  @override
  Widget build(BuildContext context) {
    return Spotlight(
      center: _center,
      radius: _radius,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
          ],
        ),
        body: SafeArea(
          child: Container(),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.favorite_border),
          onPressed: () {},
        ),
      ),
    );
  }
}
```

**For details see the example app**

## Showcase from example app 

![capture](https://user-images.githubusercontent.com/291993/46523938-3dbff100-c8c2-11e8-8103-7fade7f8e946.png)
