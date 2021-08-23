import 'package:flutter/material.dart';

import 'rating_hearts.dart';
import '../api/appointments.dart';
import '../localizations/app_localizations.dart';
import '../models/review.dart';
import '../models/appointment.dart';
import '../utils/dialogs.dart';
import '../utils/field_theme.dart';

class AppointmentCard extends StatefulWidget {
  final Appointment appointment;
  final bool isCurrent;

  AppointmentCard({this.appointment, this.isCurrent});

  @override
  _AppointmentCardState createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  final _controller = TextEditingController();
  int _rating;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _translateEntity() {
    if (widget.appointment.doctor == null) {
      return widget.appointment.entity;
    }

    final langCode = Localizations.localeOf(context).languageCode;
    final name = widget.appointment.entity;
    final dashIndex = name.indexOf('-');
    if (langCode == 'ar') {
      return name.substring(dashIndex + 2);
    } else {
      return name.substring(0, dashIndex - 1);
    }
  }

  void _cancel() {
    prompt(
      context,
      t('cancel_message'),
      onYes: () async {
        await AppointmentAPI.cancel(
          context,
          widget.appointment.doctor == null ? 'services' : 'clinics',
          widget.appointment.id,
        );
        await AppointmentAPI.getUserAppointments(context);
      },
    );
  }

  void _review() {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            side: BorderSide(width: 4.0, color: theme.primaryColor),
          ),
          title: Text(t('review'), textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RatingHearts(
                size: 30,
                active: true,
                onChanged: (rating) => _rating = rating,
              ),
              const SizedBox(height: 10),
              Theme(
                data: inputTheme(context),
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.multiline,
                  minLines: 4,
                  maxLines: 5,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    style: ButtonStyle(
                      side: MaterialStateProperty.all<BorderSide>(
                        BorderSide(color: theme.primaryColor),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        theme.primaryColor.withOpacity(0.2),
                      ),
                      overlayColor: MaterialStateProperty.all<Color>(
                        theme.primaryColor.withOpacity(0.4),
                      ),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(theme.primaryColor),
                      textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    child: Text(t('submit_review')),
                    onPressed: () async {
                      Navigator.pop(context);
                      final response = await AppointmentAPI.review(
                        context,
                        widget.appointment.doctor == null
                            ? 'services'
                            : 'clinics',
                        widget.appointment.id,
                        Review(
                          rating: _rating.toString(),
                          review: _controller.text,
                        ),
                      );

                      if (response) {
                        alert(context, t('review_share'));
                      }
                      _controller.clear();
                    },
                  ),
                  OutlinedButton(
                    child: Text(t('cancel')),
                    onPressed: () {
                      _controller.clear();
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final langCode = Localizations.localeOf(context).languageCode;
    setAppLocalization(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: widget.appointment.status == 'W'
                  ? Colors.grey[500]
                  : widget.appointment.status == 'R'
                      ? theme.errorColor
                      : theme.primaryColorLight,
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(langCode == 'en' ? 5 : 0),
                right: Radius.circular(langCode == 'en' ? 0 : 5),
              ),
            ),
            child: RotatedBox(
              quarterTurns: 3,
              child: Text(
                widget.appointment.status == 'W'
                    ? t('waiting')
                    : widget.appointment.status == 'R'
                        ? t('rejected')
                        : t('accepted'),
                style: theme.textTheme.button.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.accentColor,
                    borderRadius: langCode == 'en'
                        ? BorderRadius.only(topRight: Radius.circular(5))
                        : BorderRadius.only(topLeft: Radius.circular(5)),
                  ),
                  child: Text(
                    widget.appointment.hospital,
                    style: theme.textTheme.button.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                ListTile(
                  dense: true,
                  tileColor: Colors.white,
                  title: widget.appointment.doctor == null
                      ? Text(_translateEntity())
                      : Text(widget.appointment.doctor),
                  subtitle: widget.appointment.doctor == null
                      ? null
                      : Text(_translateEntity()),
                  trailing: widget.isCurrent
                      ? OutlinedButton(
                          onPressed: _cancel,
                          child: Text(t('cancel')),
                        )
                      : widget.appointment.status == "A"
                          ? OutlinedButton(
                              style: theme.outlinedButtonTheme.style.copyWith(
                                side: MaterialStateProperty.all<BorderSide>(
                                  BorderSide(color: theme.primaryColor),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  theme.primaryColor.withOpacity(0.2),
                                ),
                                overlayColor: MaterialStateProperty.all<Color>(
                                  theme.primaryColor.withOpacity(0.4),
                                ),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        theme.primaryColor),
                              ),
                              onPressed: _review,
                              child: Text(t('rate')),
                            )
                          : const SizedBox(),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.accentColor,
                    borderRadius: langCode == 'en'
                        ? BorderRadius.only(bottomRight: Radius.circular(5))
                        : BorderRadius.only(bottomLeft: Radius.circular(5)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Icon(
                            Icons.date_range_rounded,
                            color: Colors.orange,
                            size: 20,
                          ),
                          Text(
                            widget.appointment.appointmentDate,
                            style: theme.textTheme.caption
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(
                            Icons.access_time_outlined,
                            color: theme.primaryColorLight,
                            size: 20,
                          ),
                          Text(
                            '${widget.appointment.schedule.start.substring(0, 5)} - ${widget.appointment.schedule.end.substring(0, 5)}',
                            style: theme.textTheme.caption
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(
                            Icons.monetization_on,
                            color: Colors.lightGreen,
                            size: 20,
                          ),
                          Text(
                            '${widget.appointment.price} ' + t('egp'),
                            style: theme.textTheme.caption
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
