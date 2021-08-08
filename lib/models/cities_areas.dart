import 'dart:convert';

Cities citiesFromJson(String str) => Cities.fromJson(json.decode(str));
Areas areasFromJson(String str) => Areas.fromJson(json.decode(str));

class Cities {
  Cities({
    this.cities,
  });

  List<City> cities;

  factory Cities.fromJson(Map<String, dynamic> json) => Cities(
        cities: List<City>.from(json["cities"].map((x) => City.fromJson(x))),
      );
}

class City {
  City({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        name: json["name"],
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

class Area {
  Area({this.id, this.name, this.city});

  int id;
  String name;
  int city;

  factory Area.fromJson(Map<String, dynamic> json) =>
      Area(id: json["id"], name: json["name"], city: json["city"]);
}
