import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:provider/provider.dart';

import './about_screen.dart';
import './auth_screen.dart';
import './contact_us_screen.dart';
import './tabs_screen.dart';
import '../api/accounts.dart';
import '../localizations/app_localizations.dart';
import '../providers/app_data.dart';
import '../providers/user_data.dart';
import '../utils/dialogs.dart';
import '../widgets/background_image.dart';

class SettingsScreen extends StatelessWidget {
  void _logOut(BuildContext context) {
    prompt(context, t('log_out_message'), onYes: () async {
      final response = await AccountAPI.logout(context);
      if (response) {
        Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appData = Provider.of<AppData>(context);
    final isLoggedIn = Provider.of<UserData>(context, listen: false).isLoggedIn;
    setAppLocalization(context);

    return Scaffold(
      appBar: AppBar(title: Text(t('settings'))),
      body: BackgroundImage(
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ListTile(
                tileColor: Colors.grey[300],
                title: Text(t('language'), style: theme.textTheme.headline6),
                trailing: ToggleSwitch(
                  labels: [t('english'), t('arabic')],
                  minWidth: 75,
                  minHeight: 30,
                  cornerRadius: 10,
                  initialLabelIndex: appData.language == 'en' ? 0 : 1,
                  activeBgColor: theme.primaryColorLight,
                  inactiveBgColor: Colors.white,
                  onToggle: (index) {
                    final lang = index == 0 ? 'en' : 'ar';
                    if (lang != appData.language) {
                      Navigator.of(context).pushReplacementNamed(
                        TabsScreen.routeName,
                        arguments: 1,
                      );
                      appData.setLanguage(context, lang);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Card(
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            //   margin: EdgeInsets.zero,
            //   color: Colors.grey[300],
            //   child: SwitchListTile(
            //     value: appData.notifications,
            //     onChanged: (val) => appData.setNotifications(val),
            //     title: Text(
            //       t('notifications'),
            //       style: theme.textTheme.headline6,
            //     ),
            //     activeColor: Colors.white,
            //     activeTrackColor: theme.primaryColorLight,
            //     inactiveThumbColor: theme.primaryColorLight,
            //     inactiveTrackColor: Colors.white,
            //   ),
            // ),
            // const SizedBox(height: 15),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed(AboutScreen.routeName);
                },
                tileColor: Colors.grey[300],
                title: Text(t('about_us'), style: theme.textTheme.headline6),
                trailing: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    Icon(Icons.help, size: 45, color: theme.primaryColorLight),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed(ContactUsScreen.routeName);
                },
                tileColor: Colors.grey[300],
                title: Text(t('contact_us'), style: theme.textTheme.headline6),
                trailing: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Container(
                      height: 30,
                      width: 35,
                      color: Colors.white,
                    ),
                    Icon(Icons.contact_mail,
                        size: 40, color: theme.primaryColorLight),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ListTile(
                onTap: isLoggedIn
                    ? () => _logOut(context)
                    : () {
                        Navigator.of(context)
                            .pushReplacementNamed(AuthScreen.routeName);
                      },
                tileColor: Colors.grey[300],
                title: Text(
                  t(isLoggedIn ? 'log_out' : 'log_in'),
                  style: theme.textTheme.headline6,
                ),
                trailing: CircleAvatar(
                  backgroundColor: theme.primaryColorLight,
                  child: Icon(
                    isLoggedIn ? Icons.logout : Icons.login,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
