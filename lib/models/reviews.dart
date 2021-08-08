import 'dart:convert';

Reviews reviewsFromJson(String str) => Reviews.fromJson(json.decode(str));

class Reviews {
  Reviews({
    this.reviews,
  });

  List<Review> reviews;

  factory Reviews.fromJson(Map<String, dynamic> json) => Reviews(
        reviews:
            List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
      );
}

class Review {
  Review({
    this.userId,
    this.name,
    this.date,
    this.rating,
    this.review,
  });

  int userId;
  String name;
  String date;
  String rating;
  String review;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        userId: json["user_id"],
        name: json["name"],
        date: json["date"],
        rating: json["rating"],
        review: json["review"],
      );
}
