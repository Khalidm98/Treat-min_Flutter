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
import '../widgets/review_card.dart';

class BookingScreen extends StatefulWidget {
  static const routeName = '/booking';

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  static const Map<String, int> _weekDays = {
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

  Schedule _schedule = Schedule(id: -1);
  DateTime _date = DateTime(2000);

  bool _showReviews = false;

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
    });
  }

  DateTime _defineFirstDate() {
    final now = DateTime.now();
    final first =
        now.add(Duration(days: _weekDays[_schedule.day] - now.weekday));
    if (first.isBefore(now)) {
      return first.add(Duration(days: 7));
    }
    return first;
  }

  Future<void> _selectDate(Schedule schedule) async {
    final first = _defineFirstDate();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date == null || _date == DateTime(2000) ? first : _date,
      firstDate: first,
      lastDate: first.add(Duration(days: 365)),
      selectableDayPredicate: (date) {
        return date.weekday == _weekDays[_schedule.day];
      },
    );

    if (picked != null)
      setState(() {
        _date = picked;
      });
  }

  Future<void> _book() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      _mustLogin();
      return;
    }

    if (_schedule == null || _schedule.id == -1) {
      setState(() => _schedule = null);
      return;
    } else if (_date == null || _date == DateTime(2000)) {
      setState(() => _date = null);
      return;
    }

    final appointment = {
      'schedule': _schedule.id,
      'appointment_date': _date.toIso8601String().substring(0, 10)
    };
    final response = await AppointmentAPI.reserve(
        context, _entity, _detail, appointment, _twice);
    if (response) {
      _bookSuccess();
    }
  }

  void _mustLogin() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t('must_log_in')),
        actions: [
          TextButton(
            child: Text(t('cancel')),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text(t('log_in')),
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                AuthScreen.routeName,
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  void _twice() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (_) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
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
                      width: 60,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 20,
                    ),
                    child: Text(
                      t('reserve_twice'),
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
              Navigator.of(context).pushNamedAndRemoveUntil(
                TabsScreen.routeName,
                (route) => false,
                arguments: 2,
              );
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
                      width: 60,
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
                active: false,
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
                  setState(() => _schedule = schedule);
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
                if (_schedule == null || _schedule.id == -1) {
                  setState(() => _schedule = null);
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
              onPressed: () async => await _book(),
              child: Text(t('book_now')),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  theme.accentColor,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ExpansionTile(
                onExpansionChanged: (boolean) {
                  setState(() {
                    _showReviews = boolean;
                  });
                },
                iconColor: Colors.black,
                textColor: Colors.black,
                backgroundColor: theme.primaryColorLight,
                collapsedBackgroundColor: theme.primaryColorLight,
                childrenPadding: _reviews.isEmpty
                    ? const EdgeInsets.all(0)
                    : const EdgeInsets.symmetric(horizontal: 10),
                title: Text(t(_showReviews ? 'hide_reviews' : 'view_reviews')),
                children: _reviews.isEmpty
                    ? [
                        ListTile(
                          dense: true,
                          title: Text(
                            t('no_current_reviews'),
                            style: theme.textTheme.subtitle2,
                          ),
                          trailing: Icon(
                            Icons.rate_review,
                            color: theme.accentColor,
                          ),
                        )
                      ]
                    : _reviews.map((review) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ReviewCard(review),
                        );
                      }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
