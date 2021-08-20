import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/entity.dart';
import '../models/entity_details.dart';
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
          .setAppointments(utf8.decode(response.bodyBytes));
      return true;
    } else if (response.statusCode == 401) {
      invalidToken(context);
    } else {
      somethingWentWrong(context);
    }
    return false;
  }

  static Future cancel(
      BuildContext context, String entity, int appointmentId) async {
    final response = await http.delete(
      '$_baseURL/user/appointments/$entity/$appointmentId/cancel/',
      headers: _headers(context),
    );
    _refreshToken(context);

    if (response.statusCode == 401) {
      return "Invalid Token";
    }
    if (response.statusCode == 200) {
      return response.body;
    }
    return "Something went wrong";
  }

  static Future review(BuildContext context, String entity, String entityId,
      String entityDetailId, String rating, String review) async {
    final response = await http.post(
      '$_baseURL/$entity/$entityId/details/$entityDetailId/rate/',
      headers: _headers(context),
      body: json.encode({"rating": rating, "review": review}),
    );
    _refreshToken(context);
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    if (response.statusCode == 401) {
      return "Invalid Token";
    }
    return jsonResponse["details"];
  }
}
