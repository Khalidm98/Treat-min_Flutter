class Schedule {
  int id;
  String day;
  String start;
  String end;

  Schedule({this.id, this.day, this.start, this.end});

  Schedule.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        day = json['day'],
        start = json['start'],
        end = json['end'];
}
