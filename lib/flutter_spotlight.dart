library flutter_spotlight;

import 'dart:math';

import 'package:flutter/material.dart';

/// A Spotlight.
/// The [child] argument must not be null.
/// Fill the whole with the specified [color], Spotlight with [radius] to [center]
/// and draw [description] on screen. If [animation] is true, appears slowly.
/// Spotlight is not displayed if [enabled] is false. Default is true.
/// Call [onTap] when the screen is tapped.
/// By default, gestures are not notified to [child] under the screen. If you
/// want to notify you, specify [ignoring] as false.
class Spotlight extends StatefulWidget {
  final Widget child;
  final Color color;
  final Offset center;
  final double radius;
  final Widget description;
  final bool animation;
  final bool enabled;
  final GestureTapCallback onTap;
  final bool ignoring;

  /// Creates an object.
  Spotlight(
      {Key key,
      @required this.child,
      this.color,
      this.center,
      this.radius,
      this.description,
      this.animation = false,
      this.enabled = true,
      this.onTap,
      this.ignoring = true})
      : assert(child != null),
        super(key: key);

  @override
  SpotlightState createState() => SpotlightState();

  /// Get Rect from GlobalKey.
  static Rect getRectFromKey(GlobalKey globalKey) {
    var object = globalKey?.currentContext?.findRenderObject();
    var translation = object?.getTransformTo(null)?.getTranslation();
    var size = object?.semanticBounds?.size;

    if (translation != null && size != null) {
      return Rect.fromLTWH(
          translation.x, translation.y, size.width, size.height);
    } else {
      return null;
    }
  }

  /// Calculate target radius.
  static double calcRadius(Rect target) {
    // Calculate the long side of target rect.
    // 長辺を計算
    var a = target.right - target.left; // Horizontal
    var b = target.bottom - target.top; // Vertical
    var c = sqrt((a * a) + (b * b)); // the long side
    // Calculate radius
    // 半径
    var r = c / 2;
    return r;
  }
}

class SpotlightState extends State<Spotlight>
    with SingleTickerProviderStateMixin {
  GlobalKey stickyKey = GlobalKey();
  AnimationController _controller;
  Animation _animation;
  double _fraction = 1.0;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    if (widget.animation) {
      _controller = AnimationController(
        duration: Duration(milliseconds: 500),
        vsync: this,
      );

      _animation = Tween(begin: 0.0, end: 1.0)
          .animate(CurvedAnimation(parent: _controller, curve: Curves.ease))
            ..addListener(() {
              setState(() {
                _fraction = _animation.value;
              });
            })
            ..addStatusListener((status) {
              if (status == AnimationStatus.completed) {
                setState(() {
                  _visible = true;
                });
              } else if (status == AnimationStatus.dismissed) {
                setState(() {
                  _visible = false;
                });
              }
            });

      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(Spotlight oldWidget) {
    _controller?.reset();
    _controller?.forward();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: stickyKey,
      children: widget.enabled
          ? <Widget>[
              // Child does not respond to gestures while displaying spotlight
              IgnorePointer(ignoring: widget.ignoring, child: widget.child),
              GestureDetector(
                child: ClipPath(
                  clipper: InvertedCircleClipper(
                    adjustCenter(widget.center),
                    widget.radius * _fraction,
                  ),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        color: widget.color ?? Color.fromRGBO(0, 0, 0, 0.5),
                      ),
                      Opacity(
                        opacity: _visible ? 1.0 : 0.0,
                        child: widget.description ?? Container(),
                      ),
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

  /// Adjust target center.
  /// If Spotlight is a child of Scaffold, translation (Widget position) is shifted by AppBar, so adjust the center of ClipCircle.
  /// Spotlight が、Scaffold の子供の場合、translation (Widget position) が AppBar 分ずれるので、ClipCircle のセンターを調整する
  Offset adjustCenter(Offset offset) {
    // Get the translation vector (widget position) from Spotlight
    var object = stickyKey.currentContext?.findRenderObject();
    var translation = object?.getTransformTo(null)?.getTranslation();
    if (translation != null) {
      // Adjust center
      double dx = offset.dx - translation.x;
      double dy = offset.dy - translation.y;
      return Offset(dx, dy);
    } else {
      return offset;
    }
  }
}

/// Inverted Circle Clipper
/// Flutter: inverted ClipOval - Stack Overflow https://stackoverflow.com/questions/49374893/flutter-inverted-clipoval
class InvertedCircleClipper extends CustomClipper<Path> {
  final Offset center;
  final double radius;

  InvertedCircleClipper(this.center, this.radius);

  @override
  Path getClip(Size size) {
    return Path()
      // Circle (円)
      ..addOval(
        Rect.fromCircle(
          center: center ?? Offset(size.width / 2, size.height / 2),
          radius: radius ?? size.width * 0.25,
        ),
      )
      // Overall drawing (全体描画)
      ..addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height))
      // Hollow out a circle (くり抜き)
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(InvertedCircleClipper oldClipper) {
    return oldClipper.center != center || oldClipper.radius != radius;
  }
}
