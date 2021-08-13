import '../utils/enumerations.dart';

class NamedEntity {
  int id;
  String name;

  NamedEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];
}

class Clinic extends NamedEntity {
  Clinic.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  @override
  String toString() => 'clinics/$id';
}

class Service extends NamedEntity {
  Service.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  @override
  String toString() => 'services/$id';
}

class Doctor extends NamedEntity {
  String title;

  Doctor.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        super.fromJson(json);
}

class City extends NamedEntity {
  City.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}

class Area extends NamedEntity {
  int city;

  Area.fromJson(Map<String, dynamic> json)
      : city = json['city'],
        super.fromJson(json);
}

class Hospital extends NamedEntity {
  int city;
  int area;
  String phone;
  double latitude;
  double longitude;

  Hospital.fromJson(Map<String, dynamic> json)
      : city = json['city'],
        area = json['area'],
        phone = json['phone'],
        latitude = double.parse(json['latitude']),
        longitude = double.parse(json['longitude']),
        super.fromJson(json);

  Hospital.asFilter(Map<String, dynamic> json)
      : city = json['city'],
        area = json['area'],
        super.fromJson(json);
}

class BookNowScreenData {
  final String entityId;
  final Entity entity;
  final dynamic cardDetail;

  BookNowScreenData({this.entity, this.entityId, this.cardDetail});
}
