import 'package:flutter/material.dart';

import '../localizations/app_localizations.dart';
import '../models/schedule.dart';

class ScheduleDropDown extends StatefulWidget {
  final List<Schedule> schedules;
  final ValueChanged<Schedule> updateValue;

  ScheduleDropDown({required this.schedules, required this.updateValue});

  @override
  _ScheduleDropDownState createState() => _ScheduleDropDownState();
}

class _ScheduleDropDownState extends State<ScheduleDropDown> {
  Schedule? _value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    setAppLocalization(context);

    return DropdownButton(
      value: _value,
      underline: const SizedBox(),
      hint: Text(t('choose_schedule'), style: theme.textTheme.subtitle2),
      icon: Icon(Icons.date_range, color: theme.primaryColor, size: 30),
      isExpanded: true,
      onChanged: (Schedule? newValue) {
        widget.updateValue(newValue!);
        setState(() {
          _value = newValue;
        });
      },
      items:
          widget.schedules.map<DropdownMenuItem<Schedule>>((Schedule schedule) {
        return DropdownMenuItem(
          value: schedule,
          child: Text(
            schedule.translate(context),
            style: theme.textTheme.subtitle2,
          ),
        );
      }).toList(),
    );
  }
}
