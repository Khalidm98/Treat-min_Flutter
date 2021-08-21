import 'package:flutter/material.dart';
import '../models/review.dart';
import 'rating_hearts.dart';

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard(this.review);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: theme.primaryColor),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            dense: true,
            leading: ClipOval(
              child: Image.network(
                'https://treat-min.com/media/photos/users/${review.userId}.png',
                fit: BoxFit.fill,
                width: 40,
                errorBuilder: (_, __, ___) {
                  return Image.asset(
                    'assets/icons/default.png',
                    fit: BoxFit.fill,
                    width: 40,
                  );
                },
              ),
            ),
            title: Text(review.name),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(review.date),
                RatingHearts(rating: int.parse(review.rating), size: 15),
              ],
            ),
          ),
          if (review.review != null && review.review.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Text(review.review, textAlign: TextAlign.justify),
            ),
        ],
      ),
    );
  }
}
