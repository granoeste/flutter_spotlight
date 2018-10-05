library flutter_spotlight;

import 'dart:math';

import 'package:flutter/material.dart';

/// A Spotlight.
class Spotlight extends StatefulWidget {
  final Widget child;
  final Color color;
  final Offset center;
  final double radius;
  final bool enabled;
  final Widget description;
  final GestureTapCallback onTap;

  Spotlight(
      {Key key,
      @required this.child,
      this.color,
      this.center,
      this.radius,
      this.enabled = true,
      this.onTap,
      this.description})
      : assert(child != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => SpotlightState();

  static Rect getRectFromKey(GlobalKey globalKey) {
    var object = globalKey?.currentContext?.findRenderObject();
    var translation = object?.getTransformTo(null)?.getTranslation();
    var size = object?.semanticBounds?.size;

    if (translation != null && size != null) {
      return new Rect.fromLTWH(
          translation.x, translation.y, size.width, size.height);
    } else {
      return null;
    }
  }

  static double calcRadius(Rect target) {
    // 長辺を計算
    var a = target.right - target.left;
    var b = target.bottom - target.top;
    var c = sqrt((a * a) + (b * b));
    // 半径
    var r = c / 2;
    return r;
  }
}

class SpotlightState extends State<Spotlight>
    with SingleTickerProviderStateMixin {
  GlobalKey stickyKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: stickyKey,
//      fit: StackFit.expand,
      children: widget.enabled
          ? <Widget>[
              IgnorePointer(child: widget.child),
              GestureDetector(
                child: ClipPath(
                  clipper: InvertedCircleClipper(
                      adjustCenter(widget.center), widget.radius),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        color: widget.color ?? Color.fromRGBO(0, 0, 0, 0.5),
                      ),
                      widget.description ?? Container(),
                    ],
                  ),
                ),
                onTap: () {
                  if (widget.onTap != null) {
                    widget.onTap();
                  }
                },
              ),
            ]
          : <Widget>[
              widget.child,
            ],
    );
  }

  /// TouchEvent の Offset が AppBar 含めるので ClipCircle の実位置と調整
  Offset adjustCenter(Offset offset) {
    var object = stickyKey.currentContext?.findRenderObject();
    var translation = object?.getTransformTo(null)?.getTranslation();
    if (translation != null) {
      double dx = offset.dx - translation.x;
      double dy = offset.dy - translation.y;
      return Offset(dx, dy);
    } else {
      return offset;
    }
  }
}

/// Flutter: inverted ClipOval - Stack Overflow https://stackoverflow.com/questions/49374893/flutter-inverted-clipoval

class InvertedCircleClipper extends CustomClipper<Path> {
  final Offset center;
  final double radius;

  InvertedCircleClipper(this.center, this.radius);

  @override
  Path getClip(Size size) {
    return Path()
      // ラウンド
      ..addOval(
        Rect.fromCircle(
          center: center ?? Offset(size.width / 2, size.height / 2),
          radius: radius ?? size.width * 0.25,
        ),
      )
      // 全体描画
      ..addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height))
      // くり抜き
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(InvertedCircleClipper oldClipper) {
    return oldClipper.center != center || oldClipper.radius != radius;
  }
}
