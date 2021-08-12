import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/card_data.dart';
import '../models/filtration.dart';
import '../models/entity.dart';
import '../utils/enumerations.dart';
import '../main.dart';

class AppData with ChangeNotifier {
  String language;
  bool notifications;
  bool isFirstRun;

  static const maxClinicID = 29;
  List<Clinic> clinics = [];
  List<Service> services = [];
  List<City> cities = [];
  List<Area> areas = [];
  List<FiltrationHospital> hospitals = [];

  List<Area> updatedAreas = [];
  List<FiltrationHospital> updatedHospitals = [];
  List<bool> sortingVars = [false, false];

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
        list.forEach((json) => clinics.add(Clinic.fromJson(json)));
        break;
      case Entity.service:
        list.forEach((json) => services.add(Service.fromJson(json)));
        break;
    }
    notifyListeners();
  }

  void setCities(List list) {
    list.forEach((json) => cities.add(City.fromJson(json)));
    notifyListeners();
  }

  void setAreas(List list) {
    list.forEach((json) => areas.add(Area.fromJson(json)));
    notifyListeners();
  }

  void setHospitals(List<FiltrationHospital> list) {
    hospitals = list;
    updatedHospitals = list;
    notifyListeners();
  }

  List translate(BuildContext context, List list) {
    final langCode = Localizations.localeOf(context).languageCode;
    if (langCode == 'en') {
      list.forEach((element) {
        if (element.name.contains('-')) {
          element.name =
              element.name.substring(0, element.name.lastIndexOf('-') - 1);
        }
      });
    } else {
      list.forEach((element) {
        if (element.name.contains('-')) {
          element.name =
              element.name.substring(element.name.lastIndexOf('-') + 2);
        }
      });
      list.sort((a, b) => a.name.compareTo(b.name));
    }
    return list;
  }

  List getEntities(BuildContext context, Entity entity) {
    List list = [];
    switch (entity) {
      case Entity.clinic:
        list = clinics.map((entity) => entity).toList();
        break;
      case Entity.service:
        list = services.map((entity) => entity).toList();
        break;
    }

    if (entity == Entity.clinic) {
      return translate(context, list);
    }
    return list;
  }

  List getCities(BuildContext context) {
    final list = cities.map((entity) => entity).toList();
    return translate(context, list);
  }

  List getAreas(BuildContext context) {
    final list = areas.map((entity) => entity).toList();
    return translate(context, list);
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
}
