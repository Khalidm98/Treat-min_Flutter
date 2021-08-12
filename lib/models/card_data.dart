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
  List<ServiceDetail> details;

  factory SORCardData.fromJson(Map<String, dynamic> json) => SORCardData(
        entity: json["entity"],
        details: List<ServiceDetail>.from(
            json["details"].map((x) => ServiceDetail.fromJson(x))),
      );
}

class Hospital {
  int id;
  String name;
  String phone;
  String city;
  String area;
  double lat;
  double lng;

  Hospital.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        phone = json['phone'],
        city = json['city'],
        area = json['area'],
        lat = double.parse(json['latitude']),
        lng = double.parse(json['longitude']);
}

class Doctor {
  int id;
  String name;
  String title;

  Doctor.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        title = json['title'];
}

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
