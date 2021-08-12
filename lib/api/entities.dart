import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/card_data.dart';
import '../models/entity.dart';
import '../providers/app_data.dart';
import '../utils/dialogs.dart';
import '../utils/enumerations.dart';

class EntityAPI {
  static final String _baseURL = 'https://www.treat-min.com/api';

  // static final Map<String, String> _headers = {
  //   "content-type": "application/json",
  //   "accept": "application/json"
  // };

  static Future<void> getCities(BuildContext context) async {
    final response = await http.get('$_baseURL/cities/');
    if (response.statusCode == 200) {
      Provider.of<AppData>(context, listen: false).setCities(
        json.decode(utf8.decode(response.bodyBytes))['cities'],
      );
    } else {
      somethingWentWrong(context);
    }
  }

  static Future<void> getAreas(BuildContext context) async {
    final response = await http.get('$_baseURL/areas/');
    if (response.statusCode == 200) {
      Provider.of<AppData>(context, listen: false).setAreas(
        json.decode(utf8.decode(response.bodyBytes))['areas'],
      );
    } else {
      somethingWentWrong(context);
    }
  }

  static Future<bool> getHospitals(BuildContext context) async {
    final response = await http.get('$_baseURL/hospitals/');
    if (response.statusCode == 200) {
      Provider.of<AppData>(context, listen: false).setHospitals(
        Hospitals.fromJson(json.decode(utf8.decode(response.bodyBytes)))
            .hospitals,
      );
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

  static Future<void> getEntities(BuildContext context, Entity entity) async {
    final response = await http.get('$_baseURL/${entityToString(entity)}/');
    if (response.statusCode == 200) {
      Provider.of<AppData>(context, listen: false).setEntities(
        entity,
        json.decode(utf8.decode(response.bodyBytes))[entityToString(entity)],
      );
    } else {
      somethingWentWrongPop(context);
    }
  }

  static Future<String> getEntityDetails(
      BuildContext context, EntityClass entity) async {
    final response = await http.get(
      '$_baseURL/${entity.toString()}/details/',
    );

    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    } else {
      somethingWentWrongPop(context);
    }
    return '';
  }

  static Future<String> getEntitySchedules(
      String entity, String entityId, String entityDetailId) async {
    final response = await http.get(
      '$_baseURL/$entity/$entityId/details/$entityDetailId/schedules/',
    );
    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    }
    return "Something went wrong";
  }

  static Future<String> getEntityReviews(
      String entity, String entityId, String entityDetailId) async {
    final response = await http.get(
      '$_baseURL/$entity/$entityId/details/$entityDetailId/reviews/',
    );
    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    }
    return "Something went wrong";
  }
}
