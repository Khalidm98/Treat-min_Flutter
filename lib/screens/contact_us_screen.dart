import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../localizations/app_localizations.dart';
import '../widgets/background_image.dart';

class ContactUsScreen extends StatelessWidget {
  static const String routeName = '/contact-us';

  static const treatMinEmail = "noreply@treat-min.com";
  static const khalidEmail = "khalid.refaat98@gmail.com";
  static const ahmedEmail = "ahmedkhaled11119999@gmail.com";
  static const url = 'https://www.facebook.com/Treatmin';

  _openURL() async {
    await launch(url);
  }

  _launchEmail(String email) async {
    await launch("mailto:$email");
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    setAppLocalization(context);

    return Scaffold(
      appBar: AppBar(title: Text(t('contact_us'))),
      body: BackgroundImage(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.indigo[600],
                ),
                child: ListTile(
                  leading: Image.asset(
                    'assets/icons/facebook.png',
                    height: 35,
                    width: 40,
                  ),
                  title: Text(
                    t('visit_us'),
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: _openURL,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.cyan[500],
                ),
                child: ListTile(
                  leading: const Icon(Icons.alternate_email, size: 40),
                  title: Text(
                    t("send_us_email"),
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    treatMinEmail,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    _launchEmail(treatMinEmail);
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey,
                ),
                child: ListTile(
                  leading: Image.asset(
                    'assets/icons/dev_clean.png',
                    height: 30,
                    color: Colors.white,
                  ),
                  title: Text(
                    t("developers"),
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  trailing: Image.asset(
                    'assets/icons/dev.png',
                    height: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: theme.primaryColor,
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: Image.asset('assets/images/ahmed.png'),
                  title: Text(
                    t("ahmed_name"),
                    style: theme.textTheme.subtitle1
                        .copyWith(fontSize: 17, color: Colors.white),
                  ),
                  subtitle: Text(
                    ahmedEmail,
                    style: theme.textTheme.subtitle1
                        .copyWith(fontSize: 11, color: Colors.white),
                  ),
                  onTap: () {
                    _launchEmail(ahmedEmail);
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: theme.primaryColor,
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: Image.asset('assets/images/khalid.png'),
                  title: Text(
                    t("khalid_name"),
                    style: theme.textTheme.subtitle1
                        .copyWith(fontSize: 17, color: Colors.white),
                  ),
                  subtitle: Text(
                    khalidEmail,
                    style: theme.textTheme.subtitle1
                        .copyWith(fontSize: 11, color: Colors.white),
                  ),
                  onTap: () {
                    _launchEmail(khalidEmail);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
