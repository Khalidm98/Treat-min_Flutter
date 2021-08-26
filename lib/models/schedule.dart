import 'package:flutter/material.dart';
import '../localizations/app_localizations.dart';

class Schedule {
  int? id;
  String? day;
  String start;
  String end;

  Schedule({required this.start, required this.end});

  Schedule.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        day = json['day'],
        start = json['start'],
        end = json['end'];

  String translate(BuildContext context) {
    return t(day!) +
        ' - ' +
        t('from') +
        ' ${start.substring(0, 5)} ' +
        t('to') +
        ' ${end.substring(0, 5)}';
  }
}
