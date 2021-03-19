import 'package:lter/data/summary.dart';

/// This class represents a regional summary, which contains information about a
/// region of a specific country and is updated daily

class RegionalSummary extends AbstractSummary {

  /// This is the constructor of the class

  const RegionalSummary(String name, int totalConfirmed, int newConfirmed, int totalDeaths, int newDeaths, int totalRecovered, int newRecovered)
      : super(name, newConfirmed, totalDeaths, newDeaths, totalRecovered, newRecovered);

  /// This is the constructor of the class which accepts a list from a .csv file

  RegionalSummary.fromList(List<dynamic> list) : super(
      list[11],
      list[7] is !String ? list[7] : -1,
      -1,
      list[8] is !String ? list[8] : -1,
      -1,
      list[9] is !String ? list[9] : -1,
      -1,
      list[10] is !String ? list[10] : -1
  );

  /// This is the constructor of the class which accepts a list from a .csv file, only used for us regions

  RegionalSummary.usFromList(List<dynamic> list) : super(
      list[0] + ", United States of America",
      list[5] is !String ? list[5] : -1,
      -1,
      list[6] is !String ? list[6] : -1,
      -1,
      list[7] is !String ? list[7] : -1,
      -1,
      (list[8] as double).round()
  );
}