import 'dart:convert';

Schedules schedulesFromJson(String str) => Schedules.fromJson(json.decode(str));

class Schedules {
  Schedules({
    this.schedules,
  });

  List<Schedule> schedules;

  factory Schedules.fromJson(Map<String, dynamic> json) => Schedules(
        schedules: List<Schedule>.from(
            json["schedules"].map((x) => Schedule.fromJson(x))),
      );
}

class Schedule {
  Schedule({
    this.id,
    this.day,
    this.start,
    this.end,
  });

  int id;
  String day;
  String start;
  String end;

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        id: json["id"] == null ? null : json["id"],
        day: json["day"] == null ? null : json["day"],
        start: json["start"],
        end: json["end"],
      );
}
