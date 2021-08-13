import '../utils/enumerations.dart';

class NamedEntity {
  int id;
  String name;

  NamedEntity(this.id, this.name);

  NamedEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  NamedEntity clone() => NamedEntity(id, name);
}

class Clinic extends NamedEntity {
  Clinic(id, name) : super(id, name);

  Clinic.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  @override
  String toString() => 'clinics/$id';

  Clinic clone() => Clinic(id, name);
}

class Service extends NamedEntity {
  Service(id, name) : super(id, name);

  Service.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  @override
  String toString() => 'services/$id';

  Service clone() => Service(id, name);
}

class Doctor extends NamedEntity {
  String title;

  Doctor.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        super.fromJson(json);
}

class City extends NamedEntity {
  City(id, name) : super(id, name);

  City.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  City clone() => City(id, name);
}

class Area extends NamedEntity {
  int city;

  Area(id, name, this.city) : super(id, name);

  Area.fromJson(Map<String, dynamic> json)
      : city = json['city'],
        super.fromJson(json);

  Area clone() => Area(id, name, city);
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
