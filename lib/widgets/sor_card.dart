import 'dart:ui';
import 'package:flutter/material.dart';

import './rating_hearts.dart';
import '../localizations/app_localizations.dart';
import '../models/card_data.dart';
import '../models/screens_data.dart';
import '../screens/booking_screen.dart';
import '../utils/enumerations.dart';

const EdgeInsetsGeometry doctorCardIconsPadding = const EdgeInsets.all(2.0);
const double doctorCardIconsWidth = 12.0;
const double doctorCardIconsHeight = 12.0;

class SORCard extends StatefulWidget {
  final SORDetail sorCardData;
  final Entity entity;
  final int entityId;

  SORCard({@required this.sorCardData, this.entity, this.entityId});

  @override
  _SORCardState createState() => _SORCardState();
}

class _SORCardState extends State<SORCard> {
  goToBooking() {
    Navigator.of(context).pushNamed(
      BookNowScreen.routeName,
      arguments: BookNowScreenData(
        entityId: widget.entityId.toString(),
        entity: widget.entity,
        cardDetail: SORDetail(
          id: widget.sorCardData.id,
          hospital: widget.sorCardData.hospital,
          price: widget.sorCardData.price,
          ratingTotal: widget.sorCardData.ratingTotal,
          ratingUsers: widget.sorCardData.ratingUsers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    setAppLocalization(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 7),
            decoration: BoxDecoration(
              color: theme.primaryColor,
              border: Border(bottom: BorderSide(color: Colors.white)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  child: Text(
                    widget.sorCardData.hospital.name,
                    style:
                        theme.textTheme.headline5.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  width: double.infinity,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 7),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.white)),
              boxShadow: [
                BoxShadow(
                  color: theme.primaryColorLight.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(5, 20), // changes position of shadow
                ),
              ],
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      color: theme.primaryColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(
                              t("price"),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            child: Text(
                              t("rating"),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                              child: Text(
                            t("phone_hospital"),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          )),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${widget.sorCardData.price} ',
                              style: theme.textTheme.subtitle1
                                  .copyWith(color: theme.primaryColor),
                            ),
                            Text(
                              t("egp"),
                              style: theme.textTheme.subtitle1
                                  .copyWith(color: theme.primaryColor),
                            ),
                          ],
                        ),
                        RatingHearts(
                          iconHeight: doctorCardIconsHeight,
                          iconWidth: doctorCardIconsWidth,
                          rating: widget.sorCardData.ratingUsers != 0
                              ? (widget.sorCardData.ratingTotal ~/
                                  widget.sorCardData.ratingUsers)
                              : 0,
                        ),
                        Text(
                          "${widget.sorCardData.hospital.phone}",
                          style: theme.textTheme.subtitle1
                              .copyWith(color: theme.primaryColor),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            theme.primaryColor,
                          ),
                        ),
                        child: FittedBox(
                          child: Text(
                            t('view_details'),
                            textScaleFactor: 0.6,
                            style: theme.textTheme.headline5
                                .copyWith(color: Colors.white),
                          ),
                        ),
                        onPressed: goToBooking,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
