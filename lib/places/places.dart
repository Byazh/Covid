/// This variable represents the available countries

List<Country> countries;

/// This variable represents the available regions

List<Region> regions;

/// This variable represents the available provinces

List<Province> provinces;

/// This constant represents the map containing the regions mapped by country

Map<String, Set<Region>> regionsByCountry;

/// This constant represents the map containing the provinces mapped by region

Map<String, Set<Province>> provincesByRegion;

/// This class represents an abstract concept of a place

class Place {
  
  /// This constant represents the name of the place
  
  final String name;
  
  /// This constant represents the path to the flag of the place
  
  final String flag;

  /// This is the constructor of the class
  
  Place(this.name, this.flag);
}

/// This class represents a country

class Country extends Place {

  /// This constant represents the slug of the country

  final String slug;

  /// This constant represents the code of the country

  final String code;

  /// This is the constructor of the class

  Country(String name, this.slug, this.code)
      : super(
      name,
      "resources/flags/${code.toLowerCase()}.png"
  );

  /// This is the constructor of the class which accepts a json

  Country.fromJson(Map<String, dynamic> json)
      : slug = json["Slug"],
        code = json["CountryCode"],
        super(
          json["Country"],
          "resources/flags/${json["CountryCode"].toLowerCase()}.png"
      );
}

/// This class represents a region

class Region extends Place {

  /// This constant represents the name of the country of the region

  final String countryName;

  /// This constant represents the country of the region

  final Country country;

  /// This is the constructor of the class

  Region(String name, this.countryName, String flag)
      : country = countryByName(countryName),
        super(
          name,
          flag
      );
}

/// This class represents a province

class Province extends Place {

  /// This constant represents the region of the province

  final Region region;

  /// This constant represents the country of the province

  final Country country;

  /// This is the constructor of the class

  Province(String name, String countryName, String flag, String regionName)
      : country = countryByName(countryName),
        region =  regionByName(regionName),
        super(
          name,
          flag
      );
}

/// This method returns the country by the given name

Country countryByName(String name) {
  const alternatives = {
    "Russia": "Russian Federation",
    "US": "United States of America",
    "Brunei": "Brunei Darussalam"
  };
  return countries.firstWhere((element) => element.name == name,
      orElse: () => countries.firstWhere((element) => element.name == alternatives[name]));
}

/// This method returns the region by the given name and country

Region regionByName(String name) {
  return regions.firstWhere((element) => element.name == name);
}

/// This method returns the province by the given name

Province provinceByName(String name) {
  return provinces.firstWhere((element) => element.name == name);
}