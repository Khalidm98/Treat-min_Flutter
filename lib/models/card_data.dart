import 'dart:convert';

ClinicCardData clinicCardFromJson(String str) =>
    ClinicCardData.fromJson(json.decode(str));

SORCardData sorCardFromJson(String str) =>
    SORCardData.fromJson(json.decode(str));

Hospitals hospitalsFromJson(String str) => Hospitals.fromJson(json.decode(str));

class ClinicCardData {
  ClinicCardData({
    this.entity,
    this.details,
  });

  String entity;
  List<ClinicDetail> details;

  factory ClinicCardData.fromJson(Map<String, dynamic> json) => ClinicCardData(
        entity: json["entity"],
        details: List<ClinicDetail>.from(
            json["details"].map((x) => ClinicDetail.fromJson(x))),
      );
}

class SORCardData {
  SORCardData({
    this.entity,
    this.details,
  });

  String entity;
  List<SORDetail> details;

  factory SORCardData.fromJson(Map<String, dynamic> json) => SORCardData(
        entity: json["entity"],
        details: List<SORDetail>.from(
            json["details"].map((x) => SORDetail.fromJson(x))),
      );
}

class ClinicDetail {
  ClinicDetail({
    this.id,
    this.hospital,
    this.price,
    this.ratingTotal,
    this.ratingUsers,
    this.doctor,
  });

  int id;
  Hospital hospital;
  int price;
  int ratingTotal;
  int ratingUsers;
  Doctor doctor;

  factory ClinicDetail.fromJson(Map<String, dynamic> json) => ClinicDetail(
        id: json["id"],
        hospital: Hospital.fromJson(json["hospital"]),
        price: json["price"],
        ratingTotal: json["rating_total"],
        ratingUsers: json["rating_users"],
        doctor: Doctor.fromJson(json["doctor"]),
      );
}

class SORDetail {
  SORDetail({
    this.id,
    this.hospital,
    this.price,
    this.ratingTotal,
    this.ratingUsers,
  });

  int id;
  Hospital hospital;
  int price;
  int ratingTotal;
  int ratingUsers;

  factory SORDetail.fromJson(Map<String, dynamic> json) => SORDetail(
        id: json["id"],
        hospital: Hospital.fromJson(json["hospital"]),
        price: json["price"],
        ratingTotal: json["rating_total"],
        ratingUsers: json["rating_users"],
      );
}

class Hospitals {
  Hospitals({
    this.hospitals,
  });

  List<FiltrationHospital> hospitals;

  factory Hospitals.fromJson(Map<String, dynamic> json) => Hospitals(
        hospitals: List<FiltrationHospital>.from(
            json["hospitals"].map((x) => FiltrationHospital.fromJson(x))),
      );
}

class Hospital {
  Hospital({
    this.id,
    this.name,
    this.phone,
    this.city,
    this.area,
    this.lat,
    this.lng,
  });

  int id;
  String name;
  String phone;
  String city;
  String area;
  double lat;
  double lng;

  factory Hospital.fromJson(Map<String, dynamic> json) => Hospital(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        city: json["city"],
        area: json["area"],
        lat: double.parse(json["latitude"]),
        lng: double.parse(json["longitude"]),
      );
}

class FiltrationHospital {
  FiltrationHospital({
    this.id,
    this.name,
    this.city,
    this.area,
  });

  int id;
  String name;
  int city;
  int area;

  factory FiltrationHospital.fromJson(Map<String, dynamic> json) =>
      FiltrationHospital(
        id: json["id"],
        name: json["name"],
        city: json["city"],
        area: json["area"],
      );
}

class Doctor {
  Doctor({
    this.id,
    this.name,
    this.title,
  });

  int id;
  String name;
  String title;

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        id: json["id"],
        name: json["name"],
        title: json["title"],
      );
}
