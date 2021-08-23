import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/entity.dart';
import '../models/entity_details.dart';
import '../models/review.dart';
import '../providers/user_data.dart';
import '../utils/dialogs.dart';

class AppointmentAPI {
  static const _baseURL = 'https://www.treat-min.com/api';

  static String _token(BuildContext context) {
    return Provider.of<UserData>(context, listen: false).token;
  }

  static Map<String, String> _headers(BuildContext context) {
    return {
      "Authorization": "Token ${_token(context)}",
      "content-type": "application/json",
      "accept": "application/json"
    };
  }

  static void _refreshToken(BuildContext context) async {
    await Provider.of<UserData>(context, listen: false).refreshToken();
  }

  static Future<bool> reserve(
    BuildContext context,
    NamedEntity entity,
    Detail detail,
    Map<String, dynamic> appointment,
    Function onBadRequest,
  ) async {
    loading(context);
    final response = await http.post(
      '$_baseURL/${entity.toString()}/${detail.toString()}/reserve/',
      headers: _headers(context),
      body: json.encode(appointment),
    );
    Navigator.pop(context);
    _refreshToken(context);

    if (response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 400) {
      onBadRequest();
    } else if (response.statusCode == 401) {
      invalidToken(context);
    } else {
      somethingWentWrong(context);
    }
    return false;
  }

  static Future<bool> getUserAppointments(BuildContext context) async {
    final response = await http.get(
      '$_baseURL/user/appointments/',
      headers: _headers(context),
    );
    _refreshToken(context);

    if (response.statusCode == 200) {
      Provider.of<UserData>(context, listen: false)
          .setAppointments(json.decode(utf8.decode(response.bodyBytes)));
      return true;
    } else if (response.statusCode == 401) {
      invalidToken(context);
    } else {
      somethingWentWrong(context);
    }
    return false;
  }

  static Future<bool> cancel(
      BuildContext context, String entity, int appointmentId) async {
    loading(context);
    final response = await http.delete(
      '$_baseURL/user/appointments/$entity/$appointmentId/cancel/',
      headers: _headers(context),
    );
    Navigator.pop(context);
    _refreshToken(context);

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      invalidToken(context);
    } else {
      somethingWentWrong(context);
    }
    return false;
  }

  static Future<bool> review(BuildContext context, String entity,
      int appointmentId, Review review) async {
    loading(context);
    final response = await http.post(
      '$_baseURL/user/appointments/$entity/$appointmentId/review/',
      headers: _headers(context),
      body: json.encode({"rating": review.rating, "review": review.review}),
    );
    Navigator.pop(context);
    _refreshToken(context);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 401) {
      invalidToken(context);
    } else {
      somethingWentWrong(context);
    }
    return false;
  }
}
