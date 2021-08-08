import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../localizations/app_localizations.dart';
import '../providers/user_data.dart';
import '../utils/dialogs.dart';

class ActionAPI {
  static final String _baseURL = 'https://www.treat-min.com/api';

  static String token(BuildContext context) {
    return Provider.of<UserData>(context, listen: false).token;
  }

  static void refreshToken(BuildContext context) async {
    await Provider.of<UserData>(context, listen: false).refreshToken();
  }

  static Future<String> getEntityDetail(String entity, String entityId) async {
    final response = await http.get(
      '$_baseURL/$entity/$entityId/details/',
    );
    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    }
    return "Something went wrong";
  }

  static Future<String> getEntitySchedule(
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

  static Future reserveAppointment(
      BuildContext context,
      String entity,
      String entityId,
      String entityDetailId,
      String scheduleId,
      String appointmentDate) async {
    final response = await http.post(
      '$_baseURL/$entity/$entityId/details/$entityDetailId/reserve/',
      headers: {
        "Authorization": "Token ${token(context)}",
        "content-type": "application/json",
        "accept": "application/json"
      },
      body: json.encode(
          {"schedule": scheduleId, "appointment_date": appointmentDate}),
    );
    refreshToken(context);
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    if (response.statusCode == 401) {
      return "Invalid Token";
    }
    return jsonResponse["details"];
  }

  static Future<bool> getUserAppointments(BuildContext context) async {
    final response = await http.get(
      '$_baseURL/user/appointments/',
      headers: {
        "Authorization": "Token ${token(context)}",
        "content-type": "application/json",
        "accept": "application/json"
      },
    );
    refreshToken(context);

    if (response.statusCode == 200) {
      Provider.of<UserData>(context, listen: false)
          .setAppointments(utf8.decode(response.bodyBytes));
      return true;
    } else if (response.statusCode == 401) {
      alert(context, t('invalid_token'));
    } else {
      somethingWentWrong(context);
    }
    return false;
  }

  static Future cancelAppointment(
      BuildContext context, String entity, int appointmentId) async {
    final response = await http.delete(
      '$_baseURL/user/appointments/$entity/$appointmentId/cancel/',
      headers: {
        "Authorization": "Token ${token(context)}",
        "content-type": "application/json",
        "accept": "application/json"
      },
    );
    refreshToken(context);

    if (response.statusCode == 401) {
      return "Invalid Token";
    }
    if (response.statusCode == 200) {
      return response.body;
    }
    return "Something went wrong";
  }

  static Future rateAppointment(
      BuildContext context,
      String entity,
      String entityId,
      String entityDetailId,
      String rating,
      String review) async {
    final response = await http.post(
      '$_baseURL/$entity/$entityId/details/$entityDetailId/rate/',
      headers: {
        "Authorization": "Token ${token(context)}",
        "content-type": "application/json",
        "accept": "application/json"
      },
      body: json.encode({"rating": rating, "review": review}),
    );
    refreshToken(context);
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    if (response.statusCode == 401) {
      return "Invalid Token";
    }
    return jsonResponse["details"];
  }
}
