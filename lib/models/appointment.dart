import 'schedule.dart';

class Appointment {
  int id;
  String entity;
  String hospital;
  int price;
  Schedule schedule;
  String status;
  String appointmentDate;
  String? doctor;

  Appointment.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        entity = json['entity'],
        hospital = json['hospital'],
        price = json['price'],
        schedule = Schedule.fromJson(json['schedule']),
        status = json['status'],
        appointmentDate = json['appointment_date'],
        doctor = json['doctor'];
}
