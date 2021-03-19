import 'package:lter/data/summary.dart';

/// This class represents a provincial summary, which represents the situation in
/// a province of a specific country and is updated daily

class ProvincialSummary extends AbstractSummary {

  /// This is the constructor of the class

  const ProvincialSummary(String name, int totalConfirmed, int newConfirmed, int totalDeaths, int newDeaths, int totalRecovered, int newRecovered)
      : super(name, newConfirmed, totalDeaths, newDeaths, totalRecovered, newRecovered);

  /// This is the constructor of the class which accepts a json

  ProvincialSummary.fromJson(Map<String, dynamic> json) : super(
      "${json["denominazione_provincia"]}, ${json["denominazione_regione"]}",
      json["totale_casi"]
  );
}

