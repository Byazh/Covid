import '../summary.dart';

/// This class represents a global summary, which contains information about the
/// situation in the world and is updated daily

class GlobalSummary extends AbstractSummary {

  /// This is the constructor of the class

  const GlobalSummary(int totalConfirmed, int newConfirmed, int totalDeaths, int newDeaths, int totalRecovered, int newRecovered)
      : super("World", totalConfirmed, newConfirmed, totalDeaths, newDeaths, totalRecovered, newRecovered);

  /// This is the constructor of the class which accepts a json

  GlobalSummary.fromJson(Map<String, dynamic> json) : super(
      "World",
      json["TotalConfirmed"],
      json["NewConfirmed"],
      json["TotalDeaths"],
      json["NewDeaths"],
      json["TotalRecovered"],
      json["NewRecovered"]
  );
}