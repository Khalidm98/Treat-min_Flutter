import 'entity.dart';

class Detail {
  int id;
  int price;
  int ratingTotal;
  int ratingUsers;
  Hospital hospital;

  Detail.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        price = json['price'],
        ratingTotal = json['rating_total'],
        ratingUsers = json['rating_users'],
        hospital = Hospital.fromJson(json['hospital']);

  @override
  String toString() => 'details/$id';
}

class ClinicDetail extends Detail {
  Doctor doctor;

  ClinicDetail.fromJson(Map<String, dynamic> json)
      : doctor = Doctor.fromJson(json['doctor']),
        super.fromJson(json);
}

class ServiceDetail extends Detail {
  ServiceDetail.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}
