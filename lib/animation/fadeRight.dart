import 'package:flutter/material.dart';
//import 'package:simple_animations/simple_animations.dart';

class fadeRight extends StatelessWidget {
  final double delay;
  final Widget child;

  fadeRight(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    /*  final tween = MultiTrackTween([
      Track("opacity")
          .add(Duration(milliseconds: 500), Tween(begin: 0.0, end: 1.0)),
      Track("translateY").add(
          Duration(milliseconds: 500), Tween(begin: 30.0, end: 0.0),
          curve: Curves.easeOut)
    ]);

    return ControlledAnimation(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builderWithChild: (context, child, animation) => Opacity(
        opacity: (animation as Map)["opacity"],
        child: Transform.translate(
            offset: Offset(animation["translateY"], 0), child: child),
      ),
    );*/
    return child;
  }
}
