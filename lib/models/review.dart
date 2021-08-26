class Review {
  int? userId;
  String? name;
  String? date;
  String? review;
  String rating;

  Review({required this.rating, required this.review});

  Review.fromJson(Map<String, dynamic> json)
      : userId = json['user_id'],
        name = json['name'],
        date = json['date'],
        rating = json['rating'],
        review = json['review'];
}
