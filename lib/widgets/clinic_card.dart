import 'package:flutter/material.dart';

import 'rating_hearts.dart';
import '../localizations/app_localizations.dart';
import '../models/card_data.dart';
import '../models/entity.dart';
import '../screens/booking_screen.dart';

class ClinicCard extends StatelessWidget {
  final ClinicDetail detail;
  final int clinicId;

  const ClinicCard({@required this.detail, @required this.clinicId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    setAppLocalization(context);

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.all(10),
          color: theme.primaryColor,
          width: double.infinity,
          child: Text(
            detail.hospital.name,
            style: theme.textTheme.headline6.copyWith(color: Colors.white),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(2.0),
            border: Border.all(color: theme.primaryColorLight),
          ),
          child: Column(
            children: [
              Text(
                detail.doctor.name,
                style: theme.textTheme.headline5,
                textAlign: TextAlign.center,
              ),
              Text(
                detail.doctor.title,
                style: theme.textTheme.subtitle2,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          color: Colors.white,
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  color: theme.primaryColor,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t('price'),
                        style: const TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Text(
                        t('rating'),
                        style: const TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Text(
                        t('phone_hospital'),
                        style: const TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${detail.price} ' + t('egp'),
                          style: theme.textTheme.subtitle1
                              .copyWith(color: theme.primaryColor),
                        ),
                        RatingHearts(
                          size: 15,
                          rating: detail.ratingUsers != 0
                              ? (detail.ratingTotal ~/ detail.ratingUsers)
                              : 0,
                        ),
                        Text(
                          detail.hospital.phone,
                          style: theme.textTheme.subtitle1
                              .copyWith(color: theme.primaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          theme.primaryColor,
                        ),
                      ),
                      child: FittedBox(
                        child: Text(
                          t('view_details'),
                          style: theme.textTheme.headline5
                              .copyWith(color: Colors.white),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          BookingScreen.routeName,
                          arguments: BookNowScreenData(
                            entityId: clinicId.toString(),
                            cardDetail: detail,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
