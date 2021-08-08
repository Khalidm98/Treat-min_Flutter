import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';

import './tabs_screen.dart';
import '../api/actions.dart';
import '../localizations/app_localizations.dart';
import '../models/reviews.dart';
import '../models/schedule.dart';
import '../models/screens_data.dart';
import '../utils/enumerations.dart';
import '../widgets/background_image.dart';
import '../widgets/book_now_dropdown_list.dart';
import '../widgets/review_box.dart';
import '../widgets/rating_hearts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/auth_screen.dart';

class BookNowScreen extends StatefulWidget {
  static const String routeName = '/booking';

  @override
  _BookNowScreenState createState() => _BookNowScreenState();
}

class _BookNowScreenState extends State<BookNowScreen> {
  bool expansionListChanger = false;
  bool ddvExists = true;
  bool pickedDateCheck = true;
  bool pickedDate = false;
  Schedule dropDownValue = Schedule(day: null, start: null, end: null);
  Future<String> schedulesResponse;
  Future<String> reviewsResponse;
  String reserveResponse;
  Reviews reviews;
  Schedules schedules;
  String scheduleId;
  String address;
  DateTime appointmentDate = DateTime.now();

  static const Map<int, String> weekDays = {
    1: "MON",
    2: "TUE",
    3: "WED",
    4: "THU",
    5: "FRI",
    6: "SAT",
    7: "SUN"
  };

  void _bookFail(ThemeData theme, BuildContext context) {
    setAppLocalization(context);
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

  void _bookSuccess(ThemeData theme, BuildContext context) {
    setAppLocalization(context);
    showDialog(
      context: context,
      builder: (_) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: GestureDetector(
            onTap: () async {
              await ActionAPI.getUserAppointments(context);
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

  int getDayNumber(Schedule dropDownValue) {
    if (dropDownValue.day == "MON") {
      return 1;
    }
    if (dropDownValue.day == "TUE") {
      return 2;
    }
    if (dropDownValue.day == "WED") {
      return 3;
    }
    if (dropDownValue.day == "THU") {
      return 4;
    }
    if (dropDownValue.day == "FRI") {
      return 5;
    }
    if (dropDownValue.day == "SAT") {
      return 6;
    }
    return 7;
  }

  int daysToAdd(int todayIndex, int targetIndex) {
    if (todayIndex < targetIndex) {
      // jump to target day in same week
      return targetIndex - todayIndex;
    } else if (todayIndex > targetIndex) {
      // must jump to next week
      return 7 + targetIndex - todayIndex;
    } else {
      return 0; // date is matched
    }
  }

  DateTime defineInitialDate() {
    DateTime now = DateTime.now();
    int dayOffset = daysToAdd(now.weekday, getDayNumber(dropDownValue));
    return now.add(Duration(days: dayOffset));
  }

  bool defineSelectable(DateTime val) {
    DateTime now = DateTime.now();
    if (val.isBefore(now)) {
      return false;
    }

    if (weekDays[val.weekday] == dropDownValue.day) {
      return true;
    }
    return false;
  }

  Future<void> _selectDate(BuildContext context, Schedule ddv) async {
    final DateTime picked = await showDatePicker(
        selectableDayPredicate: defineSelectable,
        context: context,
        initialDate: defineInitialDate(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)));
    if (picked != null)
      setState(() {
        pickedDate = true;
        appointmentDate = picked;
      });
  }

  void updateDropDownValue(Schedule dpv) {
    dropDownValue = dpv;
    if (dropDownValue.start != null) {
      ddvExists = true;
    }
  }

  void checkToBook(String entity, String entityId, String detailId,
      ThemeData theme, BuildContext context) async {
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
    } else {
      if (dropDownValue.start == null) {
        setState(() {
          ddvExists = false;
        });
      } else {
        setState(() {
          ddvExists = true;
        });
        if (pickedDate == true) {
          setState(() {
            pickedDateCheck = true;
          });
        } else {
          setState(() {
            pickedDateCheck = false;
          });
        }
      }
      if (ddvExists == true && pickedDate == true) {
        scheduleId = dropDownValue.id.toString();
        reserveResponse = await ActionAPI.reserveAppointment(
            context,
            entity,
            entityId,
            detailId,
            scheduleId,
            appointmentDate.toString().substring(0, 10));
        if (reserveResponse == "Your appointment was reserved successfully.") {
          _bookSuccess(theme, context);
        } else if (reserveResponse ==
            "User cannot reserve the same schedule twice in the same day!") {
          _bookFail(theme, context);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((callback) {
      if (ModalRoute.of(context).settings.arguments != null) {
        dynamic receivedData = ModalRoute.of(context).settings.arguments;
        String entity = entityToString(receivedData.entity);
        String entityId = receivedData.entityId;
        String detailId = receivedData.cardDetail.id.toString();
        schedulesResponse =
            ActionAPI.getEntitySchedule(entity, entityId, detailId);
        reviewsResponse =
            ActionAPI.getEntityReviews(entity, entityId, detailId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    final theme = Theme.of(context);
    BookNowScreenData receivedData = ModalRoute.of(context).settings.arguments;
    String entity = entityToString(receivedData.entity);
    String entityId = receivedData.entityId;
    String detailId = receivedData.cardDetail.id.toString();

    setAppLocalization(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(t('book_now'))),
      body: BackgroundImage(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: CircleAvatar(
                          backgroundColor: theme.accentColor,
                          radius: 75,
                          child: CircleAvatar(
                              radius: 70,
                              child: ClipOval(
                                  child: Image.network(
                                "http://treat-min.com/media/photos/hospitals/${receivedData.cardDetail.hospital.id}.png",
                                fit: BoxFit.fill,
                                errorBuilder: (_, __, ___) {
                                  return Image.asset(
                                    'assets/icons/default.png',
                                    fit: BoxFit.fill,
                                  );
                                },
                              ))),
                        ),
                      ),
                      FittedBox(
                        child: Text(
                          receivedData.entity == Entity.service
                              ? receivedData.cardDetail.hospital.name
                              : receivedData.cardDetail.doctor.name,
                          style: theme.textTheme.headline4,
                        ),
                      ),
                      if (receivedData.entity == Entity.clinic)
                        FittedBox(
                          child: Text(
                            receivedData.cardDetail.doctor.title,
                            style: theme.textTheme.headline5
                                .copyWith(fontWeight: FontWeight.w500),
                            textScaleFactor: 0.9,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      const SizedBox(height: 10),
                      address == null
                          ? const SizedBox()
                          : Text(
                              address,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              style: theme.textTheme.headline6,
                            ),
                      const SizedBox(height: 10),
                      RatingHearts(
                        iconHeight: 25,
                        iconWidth: 25,
                        rating: receivedData.cardDetail.ratingUsers != 0
                            ? (receivedData.cardDetail.ratingTotal ~/
                                receivedData.cardDetail.ratingUsers)
                            : 0,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            t("rating_from"),
                            style: theme.textTheme.headline6,
                          ),
                          Text(
                            "${receivedData.cardDetail.ratingUsers == null ? 0 : receivedData.cardDetail.ratingUsers} ",
                            style: theme.textTheme.headline6,
                          ),
                          Text(
                            t("visitors"),
                            style: theme.textTheme.headline6,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                FutureBuilder(
                  future: schedulesResponse,
                  builder: (_, response) {
                    if (response.data == "Something went wrong") {
                      return Center(
                        child: Text(
                          t("wrong"),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headline6
                              .copyWith(color: theme.errorColor),
                        ),
                      );
                    }
                    if (response.hasData) {
                      address = json.decode(response.data.toString())['address'];
                      schedules = schedulesFromJson(response.data);
                      return Container(
                        child: BookNowDropDownList(
                          dropDownValueGetter: updateDropDownValue,
                          scheduleList: schedules.schedules,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: theme.accentColor),
                          ),
                        ),
                      );
                    }
                    return CircularProgressIndicator();
                  },
                ),
                if (!ddvExists)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      t('schedule_error'),
                      style:
                          theme.textTheme.subtitle2.copyWith(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 10),
                Container(
                    child: ListTile(
                      leading: Text(
                        !pickedDate
                            ? t("choose_appointment")
                            : appointmentDate.toString().substring(0, 10),
                        style: theme.textTheme.headline6.copyWith(fontSize: 16),
                      ),
                      trailing: Icon(
                        Icons.date_range,
                        size: 30,
                        color: theme.primaryColor,
                      ),
                      onTap: () async {
                        if (dropDownValue.day != null) {
                          await _selectDate(context, dropDownValue);
                        } else {
                          setState(() {
                            ddvExists = false;
                          });
                        }
                      },
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: theme.accentColor),
                      ),
                    )),
                if (!pickedDateCheck)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      t('date_error'),
                      style:
                          theme.textTheme.subtitle2.copyWith(color: Colors.red),
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
                    checkToBook(entity, entityId, detailId, theme, context);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      color: !expansionListChanger
                          ? theme.primaryColorLight
                          : Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      boxShadow: [
                        BoxShadow(
                          color: theme.primaryColorLight
                              .withOpacity(!expansionListChanger ? 0.5 : 0),
                          blurRadius: !expansionListChanger ? 3 : 0,
                        ),
                      ],
                    ),
                    child: ExpansionTile(
                      onExpansionChanged: (bool) {
                        setState(() {
                          expansionListChanger = bool;
                        });
                      },
                      title: Text(
                        t(
                          expansionListChanger
                              ? 'hide_reviews'
                              : 'view_reviews',
                        ),
                        style: theme.textTheme.button.copyWith(fontSize: 16),
                        textAlign: TextAlign.start,
                      ),
                      children: [
                        FutureBuilder(
                          future: reviewsResponse,
                          builder: (_, response) {
                            if (response.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (response.data == "Something went wrong") {
                              return Card(child: Text(t("wrong")));
                            }
                            if (response.hasData) {
                              reviews = reviewsFromJson(response.data);
                              return reviews.reviews.length != 0
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      physics: ClampingScrollPhysics(),
                                      itemCount: reviews.reviews.length,
                                      itemBuilder: (_, index) {
                                        return ReviewBox(
                                            reviews.reviews[index]);
                                      })
                                  : Card(
                                      margin: EdgeInsets.zero,
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 15),
                                        trailing: Icon(
                                          Icons.rate_review,
                                          color: theme.accentColor,
                                        ),
                                        title: Text(
                                          t("no_current_reviews"),
                                          style: theme.textTheme.subtitle2
                                              .copyWith(
                                                  fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    );
                            }
                            return Center(
                              child: Text(
                                t("wrong"),
                                textAlign: TextAlign.center,
                                style: theme.textTheme.headline6
                                    .copyWith(color: theme.errorColor),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
