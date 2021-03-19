import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lter/data/summary.dart';
import 'package:lter/pages/common_widgets.dart';

import 'package:lter/pages/details/details_widgets.dart';
import 'package:lter/pages/home/home_widgets.dart';
import 'package:lter/places/places.dart';

import '../../main.dart';

/// This class represents the arguments passed to a details page

class DetailsArguments {

  /// This constant represents the type of the clicked place

  final String _placeType;

  /// This constant represents the clicked place

  final Place _place;

  /// This is the constructor of the class

  DetailsArguments(this._placeType, this._place);
}

/// This class represents the page containing detailed information about the situation
/// in the world, in a country or in a region

class DetailsPage extends StatelessWidget {

  /// This method builds and returns the widget

  @override
  Widget build(BuildContext context) {
    final DetailsArguments args = ModalRoute.of(context).settings.arguments;
    final place = args._place;
    final placeType = args._placeType;
    final summary = place.name != "World" ? placesSummaryFunctions[placeType](place.name) : globalSummary;
    final index = place is Country ? nationalSummaries.indexOf(summary) : -1;
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Image.asset(
            "resources/images/virus.png",
            height: height / 17.5
          )
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: height / 23
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Flag
                Container(
                  child: CircleAvatar(
                      backgroundImage: AssetImage(
                          place.flag
                      ),
                      radius: 30
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 5,
                      )
                    ]
                  )
                ),
                /// Country's name
                Container(
                  margin: EdgeInsets.only(
                      top: 20,
                      bottom: 20
                  ),
                  child: Text(
                    place.name == "World" ? language["world"] : place.name,
                    style: TextStyle(
                      color: Colors.black54,
                        fontSize: width / 21,
                        fontWeight: FontWeight.w800,
                        fontFamily: "Calibri"
                    ),
                  ),
                ),
                /// Danger level dots
                if (index != -1 ) Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 7
                    ),
                    SizedBox(
                        width: width / 42
                    ),
                    CircleAvatar(
                      backgroundColor: index < nationalSummaries.length ~/ 1.5 ? Colors.red : Colors.grey.withOpacity(0.5),
                      radius: 7
                    ),
                    SizedBox(
                        width: width / 42
                    ),
                    CircleAvatar(
                      backgroundColor: index < nationalSummaries.length ~/ 3 ? Colors.red : Colors.grey.withOpacity(0.5),
                      radius: 7
                    )
                  ]
                ),
                BarGraph(summary, placeType, place),
                /// Daily summary dashboard title
                CustomTitle(
                    language["dailySummary"]
                ),
                /// Daily summary dashboard subtitle
                CustomSubTitle(
                    language["yesterday"]
                ),
                /// Daily summary dashboard
                LargeSummaryContainer(
                  5,
                  Row(
                    children: [
                      /// New deaths
                      DailySummaryStatistic(
                        "newDeaths",
                        summary
                      ),
                      /// First vertical divider
                      CustomDivider(),
                      /// New cases
                      DailySummaryStatistic(
                          "newCases",
                          summary
                      ),
                      /// Second vertical divider
                      CustomDivider(),
                      /// New recoveries
                      DailySummaryStatistic(
                          "newRecoveries",
                          summary
                      )
                    ]
                  )
                ),
                SizedBox(
                    height: height / 50
                ),
                /// Sub-places leaderboard title
                CustomTitle(
                    language[subPlacesHelper[placeType]]
                ),
                /// Sub-places leaderboard subtitle
                CustomSubTitle(
                    language["sortedBy" + (placeType != "regions" ? "Current" : "Total") + "Cases"]
                ),
                /// Sub-places leaderboard
                SubLeaderboard(
                  placeType,
                  place,
                  placeType != "regions" ? (a, b) => b.currentCases - a.currentCases : (a, b) => b.totalConfirmed - a.totalConfirmed,
                  placeType != "regions" ? "currentCases" : "totalCases"
                ),
                SizedBox(
                    height: height / 40
                ),
                if (placeType != "regions" && (place.name != "World" ? subPlacesSearchFunctions[placeType][place.name] : countries.map((e) => Place(e.name, e.flag))) != null) ...[
                  CustomTitle(
                      language[subPlacesHelper[placeType]]
                  ),
                  /// Sub-places leaderboard subtitle
                  CustomSubTitle(
                      language["sortedByDeaths"]
                  ),
                  SubLeaderboard(
                      placeType,
                      place,
                      (a, b) => b.totalDeaths - a.totalDeaths,
                    "deaths"
                  ),
                  SizedBox(
                      height: height / 40
                  ),
                  CustomTitle(
                      language[subPlacesHelper[placeType]]
                  ),
                  /// Sub-places leaderboard subtitle
                  CustomSubTitle(
                     language["sortedByRecoveries"]
                  ),
                  SubLeaderboard(
                      placeType,
                      place,
                      (a, b) => b.totalRecovered - a.totalRecovered,
                    "recoveries"
                  )
                ]
              ]
            )
          )
        ]
      )
    );
  }
}
