import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/entity.dart';
import '../models/entity_details.dart';
import '../providers/app_data.dart';
import '../utils/dialogs.dart';
import '../utils/enumerations.dart';

class EntityAPI {
  static final String _baseURL = 'https://www.treat-min.com/api';

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

  static Future<void> getHospitals(BuildContext context) async {
    final response = await http.get('$_baseURL/hospitals/');
    if (response.statusCode == 200) {
      Provider.of<AppData>(context, listen: false).setHospitals(
        json.decode(utf8.decode(response.bodyBytes))['hospitals'],
      );
    } else {
      somethingWentWrong(context);
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

  static Future<List> getEntityDetails(
      BuildContext context, NamedEntity entity) async {
    final response = await http.get(
      '$_baseURL/${entity.toString()}/details/',
    );

    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes))['details'];
    } else {
      somethingWentWrongPop(context);
    }
    return [];
  }

  static Future<List> getEntitySchedules(
      BuildContext context, NamedEntity entity, Detail detail) async {
    final response = await http.get(
      '$_baseURL/${entity.toString()}/${detail.toString()}/schedules/',
    );

    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes))['schedules'];
    } else {
      somethingWentWrongPop(context);
    }
    return [];
  }

  static Future<List> getEntityReviews(
      BuildContext context, NamedEntity entity, Detail detail) async {
    final response = await http.get(
      '$_baseURL/${entity.toString()}/${detail.toString()}/reviews/',
    );

    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes))['reviews'];
    } else {
      somethingWentWrongPop(context);
    }
    return [];
  }
}
