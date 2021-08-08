import 'dart:convert';
import 'schedule.dart';

Reservations reservationsFromJson(String str) =>
    Reservations.fromJson(json.decode(str));

class Reservations {
  Reservations({
    this.current,
    this.past,
  });

  CurrentOrPast current;
  CurrentOrPast past;

  factory Reservations.fromJson(Map<String, dynamic> json) => Reservations(
        current: CurrentOrPast.fromJson(json["current"]),
        past: CurrentOrPast.fromJson(json["past"]),
      );
}

class CurrentOrPast {
  CurrentOrPast({
    this.clinics,
    this.services,
  });

  List<ReservedEntityDetails> clinics;
  List<ReservedEntityDetails> services;

  factory CurrentOrPast.fromJson(Map<String, dynamic> json) => CurrentOrPast(
        clinics: List<ReservedEntityDetails>.from(
            json["clinics"].map((x) => ReservedEntityDetails.fromJson(x))),
        services: List<ReservedEntityDetails>.from(
            json["services"].map((x) => ReservedEntityDetails.fromJson(x))),
      );
}

class ReservedEntityDetails {
  ReservedEntityDetails(
      {this.id,
      this.hospital,
      this.price,
      this.schedule,
      this.status,
      this.appointmentDate,
      this.service,
      this.doctor,
      this.clinic,
      this.clinicId,
      this.clinicDetailId,
      this.serviceId,
      this.serviceDetailId});

  int id;
  String hospital;
  int clinicId;
  int clinicDetailId;
  int serviceId;
  int serviceDetailId;
  int price;
  Schedule schedule;
  String status;
  String appointmentDate;
  String service;
  String doctor;
  String clinic;

  factory ReservedEntityDetails.fromJson(Map<String, dynamic> json) =>
      ReservedEntityDetails(
          id: json["id"],
          hospital: json["hospital"],
          price: json["price"],
          schedule: Schedule.fromJson(json["schedule"]),
          status: json["status"],
          appointmentDate: json["appointment_date"],
          service: json["service"] == null ? null : json["service"],
          doctor: json["doctor"] == null ? null : json["doctor"],
          clinic: json["clinic"] == null ? null : json["clinic"],
          clinicId: json["clinic_id"] == null ? null : json["clinic_id"],
          clinicDetailId: json["clinic_detail_id"] == null
              ? null
              : json["clinic_detail_id"],
          serviceId: json["service_id"] == null ? null : json["service_id"],
          serviceDetailId: json["service_detail_id"] == null
              ? null
              : json["service_detail_id"]);
}
