import 'package:flutter/material.dart';

class RatingHearts extends StatefulWidget {
  final double size;
  final bool active;
  final int? rating;
  final ValueChanged<int>? onChanged;

  RatingHearts(
      {required this.size, required this.active, this.rating, this.onChanged})
      : assert(size >= 5),
        assert(active
            ? onChanged != null
            : rating != null && rating >= 0 && rating <= 5);

  @override
  _RatingHeartsState createState() => _RatingHeartsState();
}

class _RatingHeartsState extends State<RatingHearts> {
  final _hearts = <Widget>[];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 5; i++) {
      _hearts.add(Image.asset(
        !widget.active && i < widget.rating!
            ? 'assets/icons/rate_filled.png'
            : 'assets/icons/rate_outlined.png',
        height: widget.size,
        width: widget.size,
      ));
      _hearts.add(SizedBox(width: widget.size / 5));
    }
    _hearts.removeLast();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: !widget.active
          ? _hearts
          : _hearts.map((heart) {
              return GestureDetector(
                child: heart,
                onTap: () {
                  final index = _hearts.indexOf(heart);
                  for (int i = 0; i < 5; i++) {
                    _hearts[i * 2] = Image.asset(
                      i * 2 <= index
                          ? 'assets/icons/rate_filled.png'
                          : 'assets/icons/rate_outlined.png',
                      height: widget.size,
                      width: widget.size,
                    );
                  }
                  setState(() {});
                  widget.onChanged!(index ~/ 2 + 1);
                },
              );
            }).toList(),
    );
  }
}
