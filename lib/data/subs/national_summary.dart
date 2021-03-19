import 'package:lter/data/summary.dart';

/// This class represents a national summary, which contains information about
/// the situation in a country and is updated daily

class NationalSummary extends AbstractSummary {

  /// This is the constructor of the class

  const NationalSummary(String name, int totalConfirmed, int newConfirmed, int totalDeaths, int newDeaths, int totalRecovered, int newRecovered)
      : super(name, totalConfirmed, newConfirmed, totalDeaths, newDeaths, totalRecovered, newRecovered);

  /// This is the constructor of the class which accepts a json

  NationalSummary.fromJson(Map<String, dynamic> json) : super(
      json["Country"],
      json["TotalConfirmed"],
      json["NewConfirmed"],
      json["TotalDeaths"],
      json["NewDeaths"],
      json["TotalRecovered"],
      json["NewRecovered"],
      json["TotalConfirmed"] - json["TotalDeaths"] - json["TotalRecovered"]
  );
}