import 'package:flutter/material.dart';
import '../api/actions.dart';
import '../localizations/app_localizations.dart';
import '../models/reservations.dart';
import '../utils/enumerations.dart';
import 'clickable_rating_hearts.dart';
import 'input_field.dart';

class ReservationCard extends StatefulWidget {
  final ReservedEntityDetails reservedEntityDetails;
  final bool isCurrentRes;
  final Entity entity;
  final int entityId;
  final int entityDetailId;
  final int appointmentId;
  final VoidCallback onCancel;

  ReservationCard(
      {this.reservedEntityDetails,
      this.isCurrentRes,
      this.onCancel,
      this.entity,
      this.entityId,
      this.entityDetailId,
      this.appointmentId});

  @override
  _ReservationCardState createState() => _ReservationCardState();
}

class _ReservationCardState extends State<ReservationCard> {
  final myController = TextEditingController();
  int ratingVal = 1;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  void confirmReservationCancellation(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(t('cancel_message')),
            actions: [
              TextButton(
                  onPressed: () async {
                    await ActionAPI.cancelAppointment(context,
                        entityToString(widget.entity), widget.appointmentId);
                    widget.onCancel();
                    Navigator.pop(context);
                  },
                  child: Text(t('yes'))),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(t('no')),
              )
            ],
          );
        });
  }

  void updateRatingValue(int ratingValue) {
    ratingVal = ratingValue;
  }

  void rateBox(BuildContext context, ThemeData theme) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              side: BorderSide(width: 4.0, color: theme.primaryColor),
            ),
            title: Text(
              t('Rate Your Appointment'),
              textAlign: TextAlign.center,
            ),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              ClickableRatingHearts(
                  iconHeight: 30,
                  iconWidth: 30,
                  ratingGetter: updateRatingValue),
              SizedBox(height: 10),
              Theme(
                data: inputTheme(context),
                child: TextField(
                  controller: myController,
                  keyboardType: TextInputType.multiline,
                  minLines: 4, //Normal textInputField will be displayed
                  maxLines: 5, // when user presses enter it will adapt to it
                ),
              ),
              SizedBox(height: 10),
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
                    onPressed: () async {
                      await ActionAPI.rateAppointment(
                          context,
                          entityToString(widget.entity),
                          widget.entityId.toString(),
                          widget.entityDetailId.toString(),
                          ratingVal.toString(),
                          myController.text);
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              content: Text(
                                t("review_share"),
                                style: theme.textTheme.headline6,
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(t("close")))
                              ],
                            );
                          });
                    },
                    child: Text(t('Submit Review'), maxLines: 1),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(t('cancel'), maxLines: 1),
                  )
                ],
              )
            ]),
          );
        });
  }

  String entityTranslation(String multilingualString, String langCode) {
    int dashIndex = multilingualString.indexOf("-");
    if (langCode == 'ar') {
      return multilingualString.substring(dashIndex + 2);
    } else {
      return multilingualString.substring(0, dashIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final langCode = Localizations.localeOf(context).languageCode;
    setAppLocalization(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: RotatedBox(
                child: Text(
                  widget.reservedEntityDetails.status == "W"
                      ? t("waiting")
                      : widget.reservedEntityDetails.status == "R"
                          ? t("rejected")
                          : t("accepted"),
                  style: theme.textTheme.button.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                quarterTurns: 3,
              ),
              decoration: BoxDecoration(
                color: widget.reservedEntityDetails.status == "W"
                    ? Colors.grey[500]
                    : widget.reservedEntityDetails.status == "R"
                        ? Colors.red
                        : theme.primaryColorLight,
                borderRadius: BorderRadius.only(
                  topLeft: langCode == 'en'
                      ? Radius.circular(4)
                      : Radius.circular(0),
                  bottomLeft: langCode == 'en'
                      ? Radius.circular(4)
                      : Radius.circular(0),
                  topRight: langCode == 'ar'
                      ? Radius.circular(4)
                      : Radius.circular(0),
                  bottomRight: langCode == 'ar'
                      ? Radius.circular(4)
                      : Radius.circular(0),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.accentColor,
                      borderRadius: langCode == 'en'
                          ? BorderRadius.only(topRight: Radius.circular(4))
                          : BorderRadius.only(topLeft: Radius.circular(4)),
                    ),
                    child: Text(
                      widget.reservedEntityDetails.hospital,
                      style: theme.textTheme.headline5
                          .copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.reservedEntityDetails.clinic != null)
                                Text(
                                  widget.reservedEntityDetails.doctor,
                                  style: theme.textTheme.headline5
                                      .copyWith(fontSize: 18),
                                ),
                              Text(
                                widget.reservedEntityDetails.clinic != null
                                    ? entityTranslation(
                                        widget.reservedEntityDetails.clinic,
                                        langCode)
                                    : entityTranslation(
                                        widget.reservedEntityDetails.service,
                                        langCode),
                                style:
                                    widget.reservedEntityDetails.clinic != null
                                        ? theme.textTheme.button
                                        : theme.textTheme.headline5
                                            .copyWith(fontSize: 18),
                              )
                            ],
                          ),
                          flex: 2,
                        ),
                        Expanded(
                          child: widget.isCurrentRes
                              ? OutlinedButton(
                                  onPressed: () {
                                    confirmReservationCancellation(context);
                                  },
                                  child: Text(t('cancel'), maxLines: 1),
                                )
                              : widget.reservedEntityDetails.status == "A"
                                  ? OutlinedButton(
                                      style: ButtonStyle(
                                        side: MaterialStateProperty.all<
                                            BorderSide>(
                                          BorderSide(color: theme.primaryColor),
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                          theme.primaryColor.withOpacity(0.2),
                                        ),
                                        overlayColor:
                                            MaterialStateProperty.all<Color>(
                                          theme.primaryColor.withOpacity(0.4),
                                        ),
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                theme.primaryColor),
                                        textStyle: MaterialStateProperty.all<
                                            TextStyle>(
                                          const TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        rateBox(context, theme);
                                      },
                                      child: Text(t('rate'), maxLines: 1),
                                    )
                                  : Container(),
                          flex: 1,
                        )
                      ],
                    ),
                    padding: const EdgeInsets.all(10),
                    // decoration: BoxDecoration(
                    //     border: Border(
                    //   right: BorderSide(color: theme.accentColor, width: 2),
                    // )),
                  ),
                  Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.date_range_rounded,
                                color: Colors.orange,
                                size: 20,
                              ),
                              Text(
                                widget.reservedEntityDetails.appointmentDate,
                                style: theme.textTheme.headline6.copyWith(
                                    fontSize: 12, color: Colors.white),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.access_time_outlined,
                                color: theme.primaryColorLight,
                                size: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${widget.reservedEntityDetails.schedule.start.substring(0, 5)} ",
                                    style: theme.textTheme.headline6.copyWith(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                  Text(
                                    t("to"),
                                    style: theme.textTheme.headline6.copyWith(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                  Text(
                                    " ${widget.reservedEntityDetails.schedule.end.substring(0, 5)}",
                                    style: theme.textTheme.headline6.copyWith(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.monetization_on,
                                color: Colors.lightGreen,
                                size: 20,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "${widget.reservedEntityDetails.price} ",
                                    style: theme.textTheme.headline6.copyWith(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                  Text(
                                    t("egp"),
                                    style: theme.textTheme.headline6.copyWith(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.accentColor,
                        borderRadius: langCode == 'en'
                            ? BorderRadius.only(bottomRight: Radius.circular(4))
                            : BorderRadius.only(bottomLeft: Radius.circular(4)),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
