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

  Review.fromJson(Map<String, dynamic> json)
      : userId = json['user_id'],
        name = json['name'],
        date = json['date'],
        rating = json['rating'],
        review = json['review'];
}
