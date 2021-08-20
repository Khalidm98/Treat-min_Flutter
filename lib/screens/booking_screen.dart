import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_screen.dart';
import 'tabs_screen.dart';
import '../api/appointments.dart';
import '../api/entities.dart';
import '../localizations/app_localizations.dart';
import '../models/entity.dart';
import '../models/review.dart';
import '../models/schedule.dart';
import '../widgets/background_image.dart';
import '../widgets/schedule_drop_down.dart';
import '../widgets/rating_hearts.dart';
import '../widgets/review_box.dart';

class BookingScreen extends StatefulWidget {
  static const routeName = '/booking';

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  static const Map<String, int> weekDays = {
    'MON': DateTime.monday,
    'TUE': DateTime.tuesday,
    'WED': DateTime.wednesday,
    'THU': DateTime.thursday,
    'FRI': DateTime.friday,
    'SAT': DateTime.saturday,
    'SUN': DateTime.sunday
  };

  var _entity;
  var _detail;

  List<Schedule> _schedules = [];
  List<Review> _reviews = [];

  Schedule _schedule = Schedule();
  DateTime _date = DateTime(2000);

  bool expansionListChanger = false;
  bool pickedDateCheck = true;
  String reserveResponse;
  String scheduleId;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final detail = ModalRoute.of(context).settings.arguments as Map;
      _entity = detail['entity'];
      _detail = detail['detail'];
      var list = await EntityAPI.getEntitySchedules(context, _entity, _detail);
      list.forEach((json) => _schedules.add(Schedule.fromJson(json)));
      list = await EntityAPI.getEntityReviews(context, _entity, _detail);
      list.forEach((json) => _reviews.add(Review.fromJson(json)));
      setState(() {});
      Future.delayed(const Duration(seconds: 1), () => _schedule = null);
    });
  }

  DateTime _defineFirstDate() {
    final now = DateTime.now();
    final first =
        now.add(Duration(days: weekDays[_schedule.day] - now.weekday));
    if (first.isBefore(now)) {
      return first.add(Duration(days: 7));
    }
    return first;
  }

  Future<void> _selectDate(Schedule schedule) async {
    final first = _defineFirstDate();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date == null ? first : _date,
      firstDate: first,
      lastDate: first.add(Duration(days: 365)),
      selectableDayPredicate: (date) {
        return date.weekday == weekDays[_schedule.day];
      },
    );

    if (picked != null)
      setState(() {
        _date = picked;
      });
  }

  void _bookFail() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (_) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: AlertDialog(
              insetPadding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: theme.errorColor,
                    radius: 60,
                    child: Image.asset(
                      'assets/images/wrong_icon.png',
                      fit: BoxFit.fitWidth,
                      width: 60,
                      height: 60,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 20,
                    ),
                    child: Text(
                      t("reserve_twice"),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headline5
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _bookSuccess() {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (_) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: GestureDetector(
            onTap: () async {
              await AppointmentAPI.getUserAppointments(context);
              Navigator.pop(context);
              Navigator.of(context).pushNamedAndRemoveUntil(
                  TabsScreen.routeName, (route) => false,
                  arguments: 2);
            },
            child: AlertDialog(
              insetPadding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: theme.primaryColor,
                    radius: 60,
                    child: Image.asset(
                      'assets/images/correct_icon.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 20,
                    ),
                    child: Text(
                      t('reserved_successfully'),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headline5
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void checkToBook(String entity, String entityId, String detailId) async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      showDialog(
        context: context,
        child: AlertDialog(
          title: Text(t('must_log_in')),
          actions: [
            TextButton(
              child: Text(t('cancel')),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text(t('log_in')),
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AuthScreen.routeName,
                  (route) => false,
                );
              },
            ),
          ],
        ),
      );
      return;
    }

    if (_schedule == null || _date == null) {
      setState(() {});
      return;
    }

    scheduleId = _schedule.id.toString();
    reserveResponse = await AppointmentAPI.reserve(context, entity, entityId,
        detailId, scheduleId, _date.toString().substring(0, 10));
    if (reserveResponse == "Your appointment was reserved successfully.") {
      _bookSuccess();
    } else if (reserveResponse ==
        "User cannot reserve the same schedule twice in the same day!") {
      _bookFail();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    setAppLocalization(context);

    if (_schedules.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(t('book_now'))),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(t('book_now'))),
      body: BackgroundImage(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            CircleAvatar(
              backgroundColor: theme.accentColor,
              radius: 75,
              child: CircleAvatar(
                radius: 70,
                child: ClipOval(
                  child: Image.network(
                    'https://treat-min.com/media/photos/hospitals/${_detail.hospital.id}.png',
                    fit: BoxFit.fill,
                    errorBuilder: (_, __, ___) {
                      return Image.asset(
                        'assets/icons/default.png',
                        fit: BoxFit.fill,
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              _entity is Clinic ? _detail.doctor.name : _detail.hospital.name,
              style: theme.textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            if (_entity is Clinic)
              Text(
                _detail.doctor.title,
                style: theme.textTheme.headline6,
                textAlign: TextAlign.center,
              ),
            Text(
              _detail.hospital.address,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 15),
            Center(
              child: RatingHearts(
                size: 25,
                rating: _detail.ratingUsers == 0
                    ? 0
                    : _detail.ratingTotal ~/ _detail.ratingUsers,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              t('rating_from') + '${_detail.ratingUsers}' + t('visitors'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: ScheduleDropDown(
                schedules: _schedules,
                updateValue: (schedule) {
                  _schedule = schedule;
                  _date = null;
                },
              ),
            ),
            Divider(height: 1, thickness: 1),
            if (_schedule == null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  t('schedule_error'),
                  style: TextStyle(color: theme.errorColor),
                ),
              ),
            const SizedBox(height: 10),
            ListTile(
              title: Text(
                _date == null || _date == DateTime(2000)
                    ? t('choose_date')
                    : _date.toString().substring(0, 10),
                style: theme.textTheme.subtitle2,
              ),
              trailing:
                  Icon(Icons.date_range, color: theme.primaryColor, size: 30),
              onTap: () async {
                if (_schedule == null) {
                  setState(() {});
                } else {
                  await _selectDate(_schedule);
                }
              },
            ),
            Divider(height: 1, thickness: 1),
            if (_date == null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  t('date_error'),
                  style: TextStyle(color: theme.errorColor),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: Text(t('book_now')),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  theme.accentColor,
                ),
              ),
              onPressed: () {
                checkToBook(_entity is Clinic ? 'clinics' : 'services',
                    _entity.id.toString(), _detail.id.toString());
              },
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: !expansionListChanger
                    ? theme.primaryColorLight
                    : Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: ExpansionTile(
                onExpansionChanged: (bool) {
                  setState(() {
                    expansionListChanger = bool;
                  });
                },
                title: Text(
                  t(expansionListChanger ? 'hide_reviews' : 'view_reviews'),
                ),
                children: [
                  _reviews.length != 0
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: _reviews.length,
                          itemBuilder: (_, index) {
                            return ReviewBox(_reviews[index]);
                          })
                      : ListTile(
                          trailing:
                              Icon(Icons.rate_review, color: theme.accentColor),
                          title: Text(
                            t('no_current_reviews'),
                            style: theme.textTheme.subtitle2,
                          ),
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
