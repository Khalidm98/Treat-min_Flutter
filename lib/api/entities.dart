import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// import '../localizations/app_localizations.dart';
import '../models/card_data.dart';
import '../models/cities_areas.dart';
import '../providers/app_data.dart';
import '../utils/dialogs.dart';
import '../utils/enumerations.dart';

class EntityAPI {
  static final String _baseURL = 'https://www.treat-min.com/api';

  // static final Map<String, String> _headers = {
  //   "content-type": "application/json",
  //   "accept": "application/json"
  // };

  static Future<bool> getEntities(BuildContext context, Entity entity) async {
    final response = await http.get('$_baseURL/${entityToString(entity)}/');
    if (response.statusCode == 200) {
      Provider.of<AppData>(context, listen: false).setEntities(
        entity,
        json.decode(utf8.decode(response.bodyBytes))[entityToString(entity)],
      );
      return true;
    } else {
      somethingWentWrong(context);
    }
    return false;
  }

  static Future<bool> getCities(BuildContext context) async {
    final response = await http.get('$_baseURL/cities/');
    if (response.statusCode == 200) {
      Provider.of<AppData>(context, listen: false).setCities(
          citiesFromJson(utf8.decode(response.bodyBytes)).cities, context);
      return true;
    } else {
      somethingWentWrong(context);
    }
    return false;
  }

  static Future<bool> getAreas(BuildContext context) async {
    final response = await http.get('$_baseURL/areas/');
    if (response.statusCode == 200) {
      Provider.of<AppData>(context, listen: false).setAreas(
          areasFromJson(utf8.decode(response.bodyBytes)).areas, context);
      return true;
    } else {
      somethingWentWrong(context);
    }
    return false;
  }

  static Future<bool> getHospitals(BuildContext context) async {
    final response = await http.get('$_baseURL/hospitals/');
    if (response.statusCode == 200) {
      Provider.of<AppData>(context, listen: false).setHospitals(
          hospitalsFromJson(utf8.decode(response.bodyBytes)).hospitals);
      return true;
    } else {
      somethingWentWrong(context);
    }
    return false;
  }

  static Future<String> getCityAreaHospitals(int cityId, int areaId) async {
    final response =
        await http.get('$_baseURL/cities/$cityId/areas/$areaId/hospitals/');
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "Something went wrong!";
    }
  }
}
