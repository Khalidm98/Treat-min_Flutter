import 'entity.dart';

class Detail {
  int id;
  int price;
  int ratingTotal;
  int ratingUsers;
  Hospital hospital;

  Detail(
      this.id, this.price, this.ratingTotal, this.ratingUsers, this.hospital);

  Detail.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        price = json['price'],
        ratingTotal = json['rating_total'],
        ratingUsers = json['rating_users'],
        hospital = Hospital.fromJson(json['hospital']);
}

class ClinicDetail extends Detail {
  Doctor doctor;

  ClinicDetail({id, price, ratingTotal, ratingUsers, hospital, this.doctor})
      : super(id, price, ratingTotal, ratingUsers, hospital);

  ClinicDetail.fromJson(Map<String, dynamic> json)
      : doctor = Doctor.fromJson(json['doctor']),
        super.fromJson(json);
}

class ServiceDetail extends Detail {
  ServiceDetail({id, price, ratingTotal, ratingUsers, hospital})
      : super(id, price, ratingTotal, ratingUsers, hospital);

  ServiceDetail.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}
