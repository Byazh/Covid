class GeoCountry {

  final String name;
  final List coordinates;

  GeoCountry(this.name, this.coordinates);

  GeoCountry.fromJson(Map<String, dynamic> json)
    : name = json["properties"]["name"],
      coordinates = json["geometry"]["coordinates"];
}