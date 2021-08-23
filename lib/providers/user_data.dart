import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/appointments.dart';
import '../models/appointment.dart';

class UserData with ChangeNotifier {
  bool isLoggedIn = false;

  // Token
  String token;
  DateTime expiry;

  // Info
  String name;
  String email;
  String gender;
  String phone;
  String photo;
  DateTime birth;

  // User Appointments
  List<Appointment> current;
  List<Appointment> past;

  void setAppointments(Map<String, dynamic> jsonData) {
    current = jsonData['current']['clinics'].map<Appointment>((json) {
      return Appointment.fromJson(json);
    }).toList();
    current += jsonData['current']['services'].map<Appointment>((json) {
      return Appointment.fromJson(json);
    }).toList();

    past = jsonData['past']['clinics'].map<Appointment>((json) {
      return Appointment.fromJson(json);
    }).toList();
    past += jsonData['past']['services'].map<Appointment>((json) {
      return Appointment.fromJson(json);
    }).toList();

    notifyListeners();
  }

  Future<void> refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return;
    }

    final userData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    userData['expiry'] = DateTime.now().add(const Duration(days: 182));
    expiry = userData['expiry'];
  }

  Future<void> tryAutoLogin(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return;
    }

    final userData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    if (!userData.containsKey('expiry')) {
      prefs.remove('userData');
      return;
    }

    expiry = DateTime.parse(userData['expiry']);
    if (expiry.isBefore(DateTime.now())) {
      prefs.remove('userData');
      return;
    }

    token = userData['token'];
    await AppointmentAPI.getUserAppointments(context);
    login();
  }

  Future<void> login() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return;
    }

    final userData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    token = userData['token'];
    expiry = DateTime.parse(userData['expiry']);
    name = userData['name'];
    email = userData['email'];
    gender = userData['gender'];
    phone = userData['phone'];
    photo = userData['photo'];
    birth = DateTime.parse(userData['birth']);
    isLoggedIn = true;
    notifyListeners();
  }

  Future<void> saveData(Map<String, String> data) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode(data);
    if (prefs.containsKey('userData')) {
      prefs.remove('userData');
    }
    prefs.setString('userData', userData);
    login();
    notifyListeners();
  }

  Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    isLoggedIn = false;
  }
}
