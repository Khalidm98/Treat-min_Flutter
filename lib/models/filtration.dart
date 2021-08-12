class Filtration {
  int id;
  String name;

  Filtration.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];
}

class City extends Filtration {
  City.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}

class Area extends Filtration {
  int city;

  Area.fromJson(Map<String, dynamic> json)
      : city = json['city'],
        super.fromJson(json);
}

class Cities {
  Cities({
    this.cities,
  });

  List<City> cities;

  factory Cities.fromJson(Map<String, dynamic> json) => Cities(
        cities: List<City>.from(json["cities"].map((x) => City.fromJson(x))),
      );
}

class Areas {
  Areas({
    this.areas,
  });

  List<Area> areas;

  factory Areas.fromJson(Map<String, dynamic> json) => Areas(
        areas: List<Area>.from(json["areas"].map((x) => Area.fromJson(x))),
      );
}
