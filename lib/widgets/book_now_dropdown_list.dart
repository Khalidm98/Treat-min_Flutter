import 'package:flutter/material.dart';

import '../localizations/app_localizations.dart';
import '../models/schedule.dart';

class BookNowDropDownList extends StatefulWidget {
  final List<Schedule> scheduleList;
  final Function(Schedule) dropDownValueGetter;
  BookNowDropDownList({this.scheduleList, this.dropDownValueGetter});
  @override
  _BookNowDropDownListState createState() =>
      _BookNowDropDownListState(scheduleList, dropDownValueGetter);
}

class _BookNowDropDownListState extends State<BookNowDropDownList> {
  Function dropDownValueGetter;
  List<Schedule> scheduleList;
  Schedule dropDownValue;
  _BookNowDropDownListState(this.scheduleList, this.dropDownValueGetter);

  String getDaysTranslated(Schedule schedule) {
    if (schedule.day == "SUN") {
      return t("sun");
    }
    if (schedule.day == "MON") {
      return t("mon");
    }
    if (schedule.day == "TUE") {
      return t("tue");
    }
    if (schedule.day == "WED") {
      return t("wed");
    }
    if (schedule.day == "THU") {
      return t("thu");
    }
    if (schedule.day == "FRI") {
      return t("fri");
    }
    return t("sat");
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    setAppLocalization(context);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 9),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          dropdownColor: Colors.white,
          isExpanded: true,
          hint: Text(t('choose_date'),
              style: theme.textTheme.headline6.copyWith(fontSize: 16)),
          value: dropDownValue,
          icon: Icon(
            Icons.date_range,
            color: theme.primaryColor,
          ),
          iconSize: 30,
          elevation: 1,
          style: theme.textTheme.headline6,
          onChanged: (newValue) {
            dropDownValueGetter(newValue);
            setState(() {
              dropDownValue = newValue;
            });
          },
          items: scheduleList.map<DropdownMenuItem>((Schedule schedule) {
            return DropdownMenuItem(
              value: schedule,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "${getDaysTranslated(schedule)} - ",
                      style: theme.textTheme.headline6.copyWith(fontSize: 16),
                    ),
                    Text(
                      t("from"),
                      style: theme.textTheme.headline6.copyWith(fontSize: 16),
                    ),
                    Text(
                      " ${schedule.start.substring(0, 5)} ",
                      style: theme.textTheme.headline6.copyWith(fontSize: 16),
                    ),
                    Text(
                      t("to"),
                      style: theme.textTheme.headline6.copyWith(fontSize: 16),
                    ),
                    Text(
                      " ${schedule.end.substring(0, 5)}",
                      style: theme.textTheme.headline6.copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
