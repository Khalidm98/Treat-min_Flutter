import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './auth_screen.dart';
import './info_screen.dart';
import '../api/actions.dart';
import '../localizations/app_localizations.dart';
import '../providers/user_data.dart';
import '../utils/enumerations.dart';
import '../widgets/background_image.dart';
import '../widgets/reservation_card.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  noReservation(ThemeData theme) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        trailing: Icon(
          Icons.book,
          color: theme.accentColor,
        ),
        title: Text(
          t('no_reservations'),
          style:
              theme.textTheme.subtitle2.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.accentColor;
    final userData = Provider.of<UserData>(context);
    final current = userData.current;
    final past = userData.past;
    setAppLocalization(context);

    if (!userData.isLoggedIn) {
      return BackgroundImage(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Image.asset('assets/images/logo.png'),
              ),
              const SizedBox(height: 50),
              Text(t('not_logged_in'), style: theme.textTheme.headline5),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ElevatedButton(
                  child: Text(t('log_in')),
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(AuthScreen.routeName);
                  },
                ),
              )
            ],
          ),
        ),
      );
    }
    return BackgroundImage(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            Container(
              height: 140,
              margin: const EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: theme.accentColor, width: 2),
                image: DecorationImage(
                  image: userData.photo.isEmpty
                      ? AssetImage('assets/images/placeholder.png')
                      : FileImage(File(userData.photo)),
                ),
              ),
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).pushNamed(InfoScreen.routeName);
                },
                tooltip: t('edit'),
                splashRadius: 20,
              ),
            ),
            const Divider(height: 0),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.account_circle, color: accent, size: 40),
              title: Text(t('name')),
              subtitle: Text(userData.name),
            ),
            const Divider(height: 0),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.alternate_email, color: accent, size: 40),
              title: Text(t('email')),
              subtitle: Text(userData.email),
            ),
            const Divider(height: 0),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.phone_android, color: accent, size: 40),
              title: Text(t('phone')),
              subtitle: Text(userData.phone),
            ),
            const Divider(height: 0),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.date_range, color: accent, size: 40),
              title: Text(t('birth')),
              subtitle: Text(userData.birth.toString().substring(0, 10)),
            ),
            const Divider(height: 0),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                t('current_reservations'),
                style: theme.textTheme.headline5,
              ),
            ),
            current.length == 0
                ? noReservation(theme)
                : ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: current.length,
                    itemBuilder: (_, index) {
                      return ReservationCard(
                        reservedEntityDetails: current[index],
                        isCurrentRes: true,
                        entity: current[index].clinic != null
                            ? Entity.clinic
                            : Entity.service,
                        appointmentId: current[index].id,
                        onCancel: () async {
                          await ActionAPI.getUserAppointments(context);
                        },
                      );
                    },
                  ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                t('past_reservations'),
                style: theme.textTheme.headline5,
              ),
            ),
            past.length == 0
                ? noReservation(theme)
                : ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: past.length,
                    itemBuilder: (_, index) {
                      return ReservationCard(
                        reservedEntityDetails: past[index],
                        isCurrentRes: false,
                        entity: past[index].clinic != null
                            ? Entity.clinic
                            : Entity.service,
                        entityId: past[index].clinicId != null
                            ? past[index].clinicId
                            : past[index].serviceId,
                        entityDetailId: past[index].clinicDetailId != null
                            ? past[index].clinicDetailId
                            : past[index].serviceDetailId,
                      );
                    },
                  ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
