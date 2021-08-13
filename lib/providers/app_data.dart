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

  List<bool> sortingVars = [false, false];

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

  List<City> getCities(BuildContext context) {
    final list = cities.map((entity) => entity).toList();
    return translate(context, list);
  }

  List<Area> getAreas(BuildContext context) {
    final list = areas.map((entity) => entity).toList();
    return translate(context, list);
  }

  List<FiltrationHospital> getHospitals(BuildContext context) {
    List<FiltrationHospital> list = [];
    list = hospitals;
    //  final langCode = Localizations.localeOf(context).languageCode;
    return list;
  }

  List<Area> getCityAreas(int cityId) {
    return areas.where((area) => area.city == cityId).toList();
  }

  List<FiltrationHospital> getCityHospitals(int cityId) {
    return hospitals.where((hospital) => hospital.city == cityId).toList();
  }

  List<FiltrationHospital> getAreaHospitals(int areaId) {
    return hospitals.where((hospital) => hospital.area == areaId).toList();
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
}
