import '../utils/enumerations.dart';

class EntityClass {
  int id;
  String name;

  EntityClass(this.id, this.name);

  EntityClass.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];
}

class Clinic extends EntityClass {
  Clinic(id, name) : super(id, name);

  Clinic.fromJSON(Map<String, dynamic> json) : super.fromJSON(json);

  @override
  String toString() => 'clinics/$id';
}

class Service extends EntityClass {
  Service(id, name) : super(id, name);

  Service.fromJSON(Map<String, dynamic> json) : super.fromJSON(json);

  @override
  String toString() => 'services/$id';
}

class BookNowScreenData {
  final String entityId;
  final Entity entity;
  final dynamic cardDetail;

  BookNowScreenData({this.entity, this.entityId, this.cardDetail});
}
