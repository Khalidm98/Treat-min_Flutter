import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  final Key key;
  final Widget child;
  final DecorationPosition position;

  BackgroundImage({@required this.child, this.key, this.position});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: key,
      child: child,
      position: position ?? DecorationPosition.background,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
