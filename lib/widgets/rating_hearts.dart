import 'package:flutter/material.dart';

class RatingHearts extends StatelessWidget {
  final int rating;
  final double iconWidth;
  final double iconHeight;

  RatingHearts({@required this.rating, this.iconHeight, this.iconWidth});

  @override
  Widget build(BuildContext context) {
    final list = <Widget>[];
    for (int i = 0; i < 5; i++) {
      list.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        child: Image.asset(
          i < rating
              ? "assets/icons/rate_filled.png"
              : "assets/icons/rate_outlined.png",
          height: iconHeight,
          width: iconWidth,
        ),
      ));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: list,
    );
  }
}
