import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  Map<String, String> _jsonMap;
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  Future<void> load() async {
    Map<String, dynamic> jsonDynamic = json.decode(
      await rootBundle.loadString('assets/lang/${locale.languageCode}.json'),
    );
    _jsonMap = jsonDynamic.map((key, value) => MapEntry(key, value.toString()));
  }

  String getText(String key) {
    if (_jsonMap.containsKey(key)) {
      return _jsonMap[key];
    }
    return 'No Translation Found!';
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localization = AppLocalizations(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations appLocalizations;

void setAppLocalization(BuildContext context) {
  appLocalizations = AppLocalizations.of(context);
}

String t(String jsonKey) {
  return appLocalizations.getText(jsonKey);
}
