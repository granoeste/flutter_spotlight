# flutter_spotlight

Spotlight for Flutter

[![pub package](https://img.shieflutter_spotlightlds.io/pub/v/flutter_spotlight.svg)](https://pub.dartlang.org/packages/flutter_spotlight)

## Example

```dart
class _MyHomePageState extends State<MyHomePage> {
  Offset _center = Offset(100.0, 100.0);
  double _radius = 50.0;

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