import 'package:flutter/material.dart';

import 'rating_hearts.dart';
import '../localizations/app_localizations.dart';
import '../models/card_data.dart';
import '../models/entity.dart';
import '../screens/booking_screen.dart';

class ServiceCard extends StatelessWidget {
  final ServiceDetail detail;
  final int serviceId;

  const ServiceCard({@required this.detail, @required this.serviceId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    setAppLocalization(context);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          color: theme.primaryColor,
          width: double.infinity,
          child: Text(
            detail.hospital.name,
            style: theme.textTheme.headline6.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        Container(height: 2, color: Colors.white),
        Container(
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
                          iconHeight: 15,
                          iconWidth: 15,
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
                            entityId: serviceId.toString(),
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
