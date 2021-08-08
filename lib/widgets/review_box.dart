import 'package:flutter/material.dart';
import '../models/reviews.dart';
import 'rating_hearts.dart';

class ReviewBox extends StatelessWidget {
  final Review review;

  ReviewBox(this.review);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: theme.primaryColor),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColorLight.withOpacity(0.5),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                child: CircleAvatar(
                  child: Image.network(
                    "http://treat-min.com/media/photos/users/${review.userId}.png",
                    fit: BoxFit.fill,
                    errorBuilder: (_, __, ___) {
                      return Image.asset(
                        'assets/icons/default.png',
                        fit: BoxFit.fill,
                      );
                    },
                  ),
                  radius: 20,
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.name,
                      style: theme.textTheme.subtitle1
                          .copyWith(fontWeight: FontWeight.w700),
                      textScaleFactor: 0.9,
                    ),
                    Text(
                      //needs to be updated
                      review.date.toString(),
                      style: theme.textTheme.subtitle2
                          .copyWith(color: Colors.grey),
                      textScaleFactor: 0.7,
                    ),
                    RatingHearts(
                        rating: int.parse(review.rating),
                        iconWidth: 10,
                        iconHeight: 10),
                  ],
                ),
              ),
            ],
          ),
          if (review.review.length != 0)
            SizedBox(
              width: double.infinity,
              child: Card(
                color: theme.primaryColorLight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    review.review,
                    style:
                        theme.textTheme.subtitle2.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          // Row(
          //   children: [
          //     IconButton(
          //         icon: Icon(
          //           likeFlag == 2 || likeFlag == 1
          //               ? Icons.thumb_up_alt_outlined
          //               : Icons.thumb_up_alt,
          //           color: theme.accentColor,
          //         ),
          //         onPressed: () {
          //           if (likeFlag == 2) {
          //             setState(() {
          //               widget.review.likes += 1;
          //             });
          //             likeFlag = 0;
          //           } else if (likeFlag == 0) {
          //             setState(() {
          //               widget.review.likes -= 1;
          //             });
          //             likeFlag = 2;
          //           } else {
          //             setState(() {
          //               widget.review.likes += 1;
          //               widget.review.dislikes -= 1;
          //             });
          //             likeFlag = 0;
          //           }
          //         }),
          //     Text("${widget.review.likes}"),
          //     IconButton(
          //         icon: Icon(
          //           likeFlag == 2 || likeFlag == 0
          //               ? Icons.thumb_down_alt_outlined
          //               : Icons.thumb_down_alt,
          //           color: Colors.red,
          //         ),
          //         onPressed: () {
          //           if (likeFlag == 2) {
          //             setState(() {
          //               widget.review.dislikes += 1;
          //             });
          //             likeFlag = 1;
          //           } else if (likeFlag == 1) {
          //             setState(() {
          //               widget.review.dislikes -= 1;
          //             });
          //             likeFlag = 2;
          //           } else {
          //             setState(() {
          //               widget.review.likes -= 1;
          //               widget.review.dislikes += 1;
          //             });
          //             likeFlag = 1;
          //           }
          //         }),
          //     Text("${widget.review.dislikes}"),
          //   ],
          // ),
        ],
      ),
    );
  }
}
