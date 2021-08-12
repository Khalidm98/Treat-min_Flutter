import '../utils/enumerations.dart';

class EntityClass {
  int id;
  String name;

  EntityClass.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];
}

class Clinic extends EntityClass {
  Clinic.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  @override
  String toString() => 'clinics/$id';
}

class Service extends EntityClass {
  Service.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  @override
  String toString() => 'services/$id';
}

class BookNowScreenData {
  final String entityId;
  final Entity entity;
  final dynamic cardDetail;

  BookNowScreenData({this.entity, this.entityId, this.cardDetail});
}
