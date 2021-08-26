import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_screen.dart';
import 'info_screen.dart';
import '../localizations/app_localizations.dart';
import '../providers/user_data.dart';
import '../widgets/background_image.dart';
import '../widgets/appointment_card.dart';

class AccountScreen extends StatelessWidget {
  Widget _noReservation(ThemeData theme) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        title: Text(t('no_reservations')),
        trailing: Icon(Icons.book, color: theme.accentColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.accentColor;
    final userData = Provider.of<UserData>(context);
    setAppLocalization(context);

    if (!userData.isLoggedIn) {
      return BackgroundImage(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png'),
                const SizedBox(height: 50),
                FittedBox(
                  child: Text(
                    t('not_logged_in'),
                    style: theme.textTheme.headline5,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: Text(t('log_in')),
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(AuthScreen.routeName);
                  },
                )
              ],
            ),
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
                border: Border.all(color: accent, width: 2),
                image: DecorationImage(
                  image: (userData.photo!.isEmpty
                      ? AssetImage('assets/images/placeholder.png')
                      : FileImage(File(userData.photo!))) as ImageProvider<Object>,
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
              subtitle: Text(userData.name!),
            ),
            const Divider(height: 0),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.alternate_email, color: accent, size: 40),
              title: Text(t('email')),
              subtitle: Text(userData.email!),
            ),
            const Divider(height: 0),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.phone_android, color: accent, size: 40),
              title: Text(t('phone')),
              subtitle: Text(userData.phone!),
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
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                t('current_reservations'),
                style: theme.textTheme.headline5,
              ),
            ),
            userData.current!.isEmpty
                ? _noReservation(theme)
                : Column(
                    children: userData.current!.map((appointment) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: AppointmentCard(
                          appointment: appointment,
                          isCurrent: true,
                        ),
                      );
                    }).toList(),
                  ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                t('past_reservations'),
                style: theme.textTheme.headline5,
              ),
            ),
            userData.past!.isEmpty
                ? _noReservation(theme)
                : Column(
                    children: userData.past!.map((appointment) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: AppointmentCard(
                          appointment: appointment,
                          isCurrent: false,
                        ),
                      );
                    }).toList(),
                  ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
