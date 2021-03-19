import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lter/data/summary.dart';
import 'package:lter/main.dart';
import 'package:lter/pages/common_widgets.dart';
import 'package:lter/pages/home/home_widgets.dart';
import 'package:lter/places/places.dart';
import 'package:lter/utils/string_utils.dart';

import 'details_page.dart';

/// This constant represents the different types of places and their sub-places type

const subPlacesHelper = {
  "world": "countries",
  "countries": "regions",
  "regions": "provinces"
};

/// This constant represents the different types of places and their sub-places search functions

final subPlacesSearchFunctions = {
  "countries": regionsByCountry,
  "regions": provincesByRegion
};

/// This class represents the leaderboard of the sub-places of a place (for example each country has regions, each region has provinces etc.)

class SubLeaderboard extends StatelessWidget {

  /// This constant represents the type of the clicked place

  final String _placeType;

  /// This constant represents the clicked place

  final Place _place;

  /// This constant represents the sorting method

  final int Function(AbstractSummary a, AbstractSummary b) sort;

  final String stat;
  
  /// This is the constructor of the class

  SubLeaderboard(this._placeType, this._place, this.sort, this.stat);

  /// This method builds and returns the widget

  @override
  Widget build(BuildContext context) {
    var subPlaces = _place.name != "World" ? subPlacesSearchFunctions[_placeType][_place.name] : countries.map((e) => Place(e.name, e.flag));
    if (subPlaces == null) {
      return Container(
        height: height / 6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
                Icons.error_outline,
                size: 40
            ),
            SizedBox(
                height: 10
            ),
            Text(
              "This place has't got any available \n${subPlacesHelper[_placeType]} right now",
              textAlign: TextAlign.center
            )
          ]
        )
      );
    }
    var summaries = List<AbstractSummary>();
    subPlaces.forEach((element) {
      summaries.add(placesSummaryFunctions[subPlacesHelper[_placeType]](element.name));
    });
    summaries.sort(sort);
    return Container(
      height: height / 4.9,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: subPlaces.length,
        itemBuilder: (context, index) {
          var summary = summaries.elementAt(index);
          var helper = {
            "totalCases": summary.totalConfirmed,
            "currentCases": summary.currentCases,
            "deaths": summary.totalDeaths,
            "recoveries": summary.totalRecovered
          };
          var place = placesSearchFunctions[subPlacesHelper[_placeType]](summaries.elementAt(index).name);
          return GestureDetector(
            onTap: () { if (place is !Province) Navigator.pushNamed(
                context, 
                "/Details", 
                arguments: DetailsArguments(
                    subPlacesHelper[_placeType], 
                    place
                ));
            },
            child: PlaceContainer(
              place,
              [
                PlaceStatistic(
                  helper[stat],
                  stat
                )
              ],
              index + 1
            )
          );
        }
      )
    );
  }
}

/// This constant represents the map containing the different categories of statistics and their representing color

const _categories = {
  "newDeaths": Colors.red,
  "newCases": Colors.orange,
  "newRecoveries": Colors.green
};

/// This class represents a statistic of the daily summary of each state's details

class DailySummaryStatistic extends StatelessWidget {

  /// This constant represents the category of the statistic
  
  final String _category;
  
  /// This constant represents the summary of the place
  
  final AbstractSummary _summary;

  /// This is the constructor of the class

  DailySummaryStatistic(this._category, this._summary);

  /// This method builds and returns the widget

  @override
  Widget build(BuildContext context) {
    var color = _categories[_category];
    var map = {
      "newDeaths": [_summary.newDeaths, _summary.totalDeaths],
      "newCases": [_summary.newConfirmed, _summary.totalConfirmed],
      "newRecoveries": [_summary.newRecovered, _summary.totalRecovered]
    };
    return Expanded(
      flex: 1,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DecorationDot(color),
            Container(
              margin: EdgeInsets.only(
                top: height / 35,
                bottom: height / 45
              ),
              child: CustomText(language[_category], color, map[_category][0], 23, 30, FontWeight.w900)
            ),/// RICORDAaaaa non 0 1
            CustomText("total ${language[_category].split(" ")[1]}", color, map[_category][1], 30, 42, FontWeight.w600)
          ]
        )
      )
    );
  }
}

/// This class represents a decorated text inside a daily summary's statistic

class CustomText extends StatelessWidget {

  /// This constant represents the text

  final String text;

  /// This constant represents the color of the text

  final Color color;

  /// This constant represents the number of the statistic

  final int number;

  /// This constant represents the size factor for the bigger text

  final int sizeFactor;

  /// This constant represents the size factor for the smaller text

  final int sizeFactor2;

  /// This constant represents the weight of the bigger text

  final FontWeight weight;

  /// This is the constructor of the class

  CustomText(this.text, this.color, this.number, this.sizeFactor, this.sizeFactor2, this.weight);

  /// This method builds and returns the widget

  @override
  Widget build(BuildContext context) {
    return RichText(
        textAlign: TextAlign.center,
        /// The number
        text: TextSpan(
            text: "${sizeFactor == 23 ? "+" : ""}${format(number)}\n",
            style: TextStyle(
                color: color,
                fontSize: width / sizeFactor,
                fontWeight: weight,
                fontFamily: "Calibri"
            ),
            children: <TextSpan>[
              /// The name of the category
              TextSpan(
                  text: text,
                  style: TextStyle(
                      color: Colors.grey.withOpacity(0.7),
                      fontSize: width / sizeFactor2,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Calibri"
                  )
              )
            ]
        )
    );
  }
}

/// This class represents the divider located between the daily summary's statistics

class CustomDivider extends StatelessWidget {

  /// This method builds and returns the widget

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1,
        height: height / 8,
        color: Colors.grey.withOpacity(0.2)
    );
  }
}

class BarGraph extends StatelessWidget {


  /// This constant represents the type of the clicked place

  final String _placeType;

  /// This constant represents the clicked place

  final Place _place;
  
  final AbstractSummary _summary;
  

  const BarGraph(this._summary, this._placeType, this._place);
  
  @override
  Widget build(BuildContext context) {
    final total = width - width / 11.5;
    final totalCases = _summary.totalConfirmed;
    var percentageDeaths = (_summary.totalDeaths / totalCases) * 100;
    var percentageRecoveries = (_summary.totalRecovered / totalCases) * 100;
    final deaths = total * (percentageDeaths / 100);
    final recoveries = total * (percentageRecoveries / 100);
    final enabled = [totalCases, deaths, recoveries].where((element) => element < 0).length == 0;
    return enabled ?
    /// Line graph about the deaths and recoveries ratio
    Container(
      margin: EdgeInsets.only(
          top: 35,
          bottom: 40,
          left: width / 23,
          right: width / 23
      ),
      child: Column(
        children: [
          Container(
            height: height / 39,
            child: Row(
              children: [
                /// Recoveries
                Container(
                  width: deaths,
                  decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.75),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          topLeft: Radius.circular(30)
                      )
                  ),
                ),
                /// Deaths
                Container(
                  width: total - deaths - recoveries,
                  color: Colors.orange.withOpacity(0.85),
                ),
                /// Active cases
                Container(
                  width: recoveries,
                  decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.65),
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(30),
                          topRight: Radius.circular(30)
                      )
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BarGraphStatistic(
                  (percentageDeaths as double)
              ),
              BarGraphStatistic(
                  ((100 - percentageRecoveries - percentageDeaths) as double)
              ),
              BarGraphStatistic(
                  (percentageRecoveries as double)
              )
            ],
          )
        ],
      ),
    )
        :
    /// If there isn't enough data for the line graph, this will replace it
    SizedBox(
        height: height / 35
    );
  }
}

class BarGraphStatistic extends StatelessWidget {

  final double number;

  BarGraphStatistic(this.number);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Text(
        number.toStringAsFixed(1) + "%",
        style: TextStyle(
          color: Colors.black54,
          fontSize: 13,
          fontWeight: FontWeight.w600
        ),
      )
    );
  }
}

