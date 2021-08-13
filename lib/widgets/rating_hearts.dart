import 'package:flutter/material.dart';

class RatingHearts extends StatelessWidget {
  final int rating;
  final double size;

  const RatingHearts({@required this.rating, @required this.size});

  @override
  Widget build(BuildContext context) {
    final list = <Widget>[];
    for (int i = 0; i < 5; i++) {
      list.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Image.asset(
          i < rating
              ? 'assets/icons/rate_filled.png'
              : 'assets/icons/rate_outlined.png',
          height: size,
          width: size,
        ),
      ));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: list,
    );
  }
}
