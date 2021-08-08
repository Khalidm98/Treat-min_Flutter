enum Entity { clinic, service }

String entityToString(Entity entity) {
  switch (entity) {
    case Entity.clinic:
      return 'clinics';
    case Entity.service:
      return 'services';
    default:
      return 'Entity Enum';
  }
}
