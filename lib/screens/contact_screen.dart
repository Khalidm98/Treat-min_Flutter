import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../localizations/app_localizations.dart';
import '../widgets/background_image.dart';

class ContactScreen extends StatelessWidget {
  static const routeName = '/contact-us';

  static const _treatMinEmail = 'noreply@treat-min.com';
  static const _khalidEmail = 'khalid.refaat98@gmail.com';
  static const _ahmedEmail = 'ahmedkhaled11119999@gmail.com';
  static const _facebookPage = 'https://www.facebook.com/Treatmin';

  void _launchEmail(String email) async {
    await launch('mailto:$email');
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
                  color: Colors.indigo[600],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  leading: Image.asset(
                    'assets/icons/facebook.png',
                    height: 35,
                    width: 35,
                  ),
                  title: Text(
                    t('visit_us'),
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () => launch(_facebookPage),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.cyan[500],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  leading: const Icon(Icons.alternate_email, size: 40),
                  title: Text(
                    t('send_us_email'),
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    _treatMinEmail,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () => _launchEmail(_treatMinEmail),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: Image.asset(
                    'assets/icons/dev_clean.png',
                    height: 30,
                    color: Colors.white,
                  ),
                  title: Text(
                    t('developers'),
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
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  leading: Image.asset('assets/images/ahmed.png'),
                  title: Text(
                    t('ahmed_name'),
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    _ahmedEmail,
                    style: theme.textTheme.subtitle1
                        .copyWith(fontSize: 11, color: Colors.white),
                  ),
                  onTap: () => _launchEmail(_ahmedEmail),
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  leading: Image.asset('assets/images/khalid.png'),
                  title: Text(
                    t('khalid_name'),
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    _khalidEmail,
                    style: theme.textTheme.subtitle1
                        .copyWith(fontSize: 11, color: Colors.white),
                  ),
                  onTap: () => _launchEmail(_khalidEmail),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
