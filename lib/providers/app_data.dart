import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/card_data.dart';
import '../models/cities_areas.dart';
import '../utils/enumerations.dart';
import '../main.dart';

class AppData with ChangeNotifier {
  String language;
  bool notifications;
  bool isFirstRun;
  List<bool> sortingVars = [false, false];
  List<FiltrationHospital> hospitals = [];
  List<FiltrationHospital> updatedHospitals = [];
  List<City> cities = [];
  List<Area> areas = [];
  List<Area> updatedAreas = [];
  List clinics = [];
  List services = [];

  String entityTranslation(String multilingualString, String langCode) {
    int dashIndex = multilingualString.indexOf("-");
    if (dashIndex == -1) {
      return multilingualString;
    } else {
      if (langCode == 'ar') {
        return multilingualString.substring(dashIndex + 2);
      } else {
        return multilingualString.substring(0, dashIndex);
      }
    }
  }

  Future<void> setLanguage(BuildContext context, String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('language', languageCode);
    language = languageCode;
    MyApp.setLocale(context, Locale(languageCode));
  }

  Future<void> setNotifications(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('notifications', val);
    notifications = val;
    notifyListeners();
  }

  Future<void> load(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('isFirstRun')) {
      prefs.setBool('isFirstRun', false);
      isFirstRun = true;
      setNotifications(true);
      setLanguage(context, Localizations.localeOf(context).languageCode);
    } else {
      isFirstRun = false;
      language = prefs.getString('language');
      notifications = prefs.getBool('notifications');
    }
  }

  void setEntities(Entity entity, List list) {
    switch (entity) {
      case Entity.clinic:
        clinics = list;
        break;
      case Entity.service:
        services = list;
        break;
    }
    notifyListeners();
  }

  void setCities(List list, BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    for (int i = 0; i < list.length; i++) {
      list[i].name = entityTranslation(list[i].name, langCode);
    }
    cities = list;
    notifyListeners();
  }

  void setAreas(List<Area> list, BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    for (int i = 0; i < list.length; i++) {
      list[i].name = entityTranslation(list[i].name, langCode);
    }
    areas = list;
    updatedAreas = list;
    notifyListeners();
  }

  void setHospitals(List<FiltrationHospital> list) {
    hospitals = list;
    updatedHospitals = list;
    notifyListeners();
  }

  List getEntities(BuildContext context, Entity entity) {
    List list = [];
    switch (entity) {
      case Entity.clinic:
        list = json.decode(json.encode(clinics));
        break;
      case Entity.service:
        list = json.decode(json.encode(services));
        break;
    }

    final langCode = Localizations.localeOf(context).languageCode;
    if (entity == Entity.clinic) {
      if (langCode == 'en') {
        list.forEach((entity) {
          if (entity['name'].contains('-')) {
            entity['name'] = entity['name']
                .substring(0, entity['name'].lastIndexOf('-') - 1);
          }
        });
      } else {
        list.forEach((entity) {
          if (entity['name'].contains('-')) {
            entity['name'] =
                entity['name'].substring(entity['name'].lastIndexOf('-') + 2);
          }
        });
        list.sort((a, b) => a['name'].compareTo(b['name']));
      }
    }
    return list;
  }

  List getCities(BuildContext context) {
    List<City> list = [];
    list = cities;
    //  final langCode = Localizations.localeOf(context).languageCode;
    return list;
  }

  List getAreas(BuildContext context) {
    List<Area> list = [];
    list = areas;
    //  final langCode = Localizations.localeOf(context).languageCode;
    return list;
  }

  void changeSortPriceLowHigh() {
    sortingVars[0] = !sortingVars[0];
    if (sortingVars[0] == true) {
      sortingVars[1] = false;
      // sortingVars[2] = false;
    }
    notifyListeners();
  }

  void changeSortPriceHighLow() {
    sortingVars[1] = !sortingVars[1];
    if (sortingVars[1] == true) {
      sortingVars[0] = false;
      // sortingVars[2] = false;
    }
    notifyListeners();
  }

  List getUpdatedAreas(BuildContext context) {
    List<Area> list = [];
    list = updatedAreas;
    //  final langCode = Localizations.localeOf(context).languageCode;
    return list;
  }

  List getUpdatedHospitals(BuildContext context) {
    List<FiltrationHospital> list = [];
    list = updatedHospitals;
    //  final langCode = Localizations.localeOf(context).languageCode;
    return list;
  }

  List getHospitals(BuildContext context) {
    List<FiltrationHospital> list = [];
    list = hospitals;
    //  final langCode = Localizations.localeOf(context).languageCode;
    return list;
  }

  List<Area> updateAreas(City city) {
    updatedAreas = areas.where((element) => element.city == city.id).toList();

    notifyListeners();

    return updatedAreas;
  }

  List<FiltrationHospital> updateHospitals(City city, Area area) {
    if (area == null) {
      updatedHospitals =
          hospitals.where((element) => element.city == city.id).toList();
      notifyListeners();

      return updatedHospitals;
    } else {
      updatedHospitals = hospitals
          .where(
              (element) => element.city == city.id && element.area == area.id)
          .toList();
      notifyListeners();

      return updatedHospitals;
    }
  }

  int maxID(Entity entity) {
    switch (entity) {
      case Entity.clinic:
        return 29;
      case Entity.service:
        return 40;
      default:
        return 0;
    }
  }
}
