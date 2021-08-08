import 'package:flutter/material.dart';
import '../localizations/app_localizations.dart';

class FirstAidScreen extends StatelessWidget {
  static const String routeName = '/first-aid';

  @override
  Widget build(BuildContext context) {
    setAppLocalization(context);

    return Scaffold(
      appBar: AppBar(title: Text(t('first_aid'))),
      body: Center(child: Image.asset('assets/images/first_aid.png')),
    );
  }
}
