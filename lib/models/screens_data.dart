import '../utils/enumerations.dart';

class AvailableScreenData {
  final Map<String, dynamic> entityMap;
  final Entity entity;

  AvailableScreenData(this.entityMap, this.entity);
}

class BookNowScreenData {
  final String entityId;
  final Entity entity;
  final dynamic cardDetail;

  BookNowScreenData({this.entity, this.entityId, this.cardDetail});
}
