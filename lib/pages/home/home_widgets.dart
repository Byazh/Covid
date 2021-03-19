import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lter/data/summary.dart';
import 'package:lter/models/dashboard_model.dart';
import 'package:lter/pages/details/details_page.dart';
import 'package:lter/places/places.dart';
import 'package:lter/utils/string_utils.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../common_widgets.dart';

/// This class represents the custom title located at the top of each dashboard of the page

class CustomTitle extends StatelessWidget {

  /// This constant represents the text of the title

  final String _text;

  /// This is the constructor of the class

  CustomTitle(this._text);

  /// This method builds and returns the widget

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
          padding: EdgeInsets.only(
              left: width / 25
          ),
          child: Text(
              _text,
              style: TextStyle(
                  color: Theme.of(context).accentColor.withOpacity(0.65),
                  fontSize: width / 30,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Calibri"
              )
          )
      ),
    );
  }
}

/// This class represents the custom subtitle located at the bottom of each title of the page

class CustomSubTitle extends StatelessWidget {

  /// This constant represents the text of the subtitle

  final String _text;

  /// This is the constructor of the class

  CustomSubTitle(this._text);

  /// This method builds and returns the widget

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
          padding: EdgeInsets.only(
              left: width / 25,
              top: height / 400
          ),
          child: Text(
              _text,
              style: TextStyle(
                  color: Theme.of(context).accentColor.withOpacity(0.55),
                  fontSize: width / 32,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Calibri"
              )
          )
      ),
    );
  }
}

/// This constant represents the map containing the different categories of statistics and their representing color

const categories = {
  "currentCases": Colors.orange,
  "deaths": Colors.red,
  "recoveries": Colors.green,
  "totalCases": Colors.grey
};

/// This class represents the global dashboard located in the middle of the page, which contains all information about the global summary

class GlobalDashboard extends StatelessWidget {

  /// This method builds and returns the widget

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    /// The external shadowed container
    return GestureDetector(
      onTap: ()=> Navigator.pushNamed(context, "/Details", arguments: DetailsArguments("world", Place("World", "resources/flags/earth.png"))),
      child: LargeSummaryContainer(
          3.75,
          Stack(
              children: <Widget>[
                /// The total confirmed cases board
                _GlobalBoard(
                    number: globalSummary.totalConfirmed - globalSummary.totalRecovered - globalSummary.totalDeaths,
                    category: "currentCases",
                    top: true,
                    left: true
                ),
                /// The total deaths board
                _GlobalBoard(
                    number: globalSummary.totalDeaths,
                    category: "deaths",
                    top: true,
                    left: false
                ),
                /// The total recoveries board
                _GlobalBoard(
                    number: globalSummary.totalRecovered,
                    category: "recoveries",
                    top: false,
                    left: true
                ),
                /// The current infections board
                _GlobalBoard(
                    number: globalSummary.totalConfirmed,
                    category: "totalCases",
                    top: false,
                    left: false
                ),
                /// The horizontal divider
                Positioned(
                    top: height / 7.75,
                    left: width / 20,
                    child: Container(
                        width: width / 1.23,
                        height: 1,
                        color: Colors.grey.withOpacity(0.2)
                    )
                ),
                /// The vertical divider
                Positioned(
                    top: height / 50,
                    left: width / 2.15,
                    child: Container(
                        width: 1,
                        height: height / 4.55,
                        color: Colors.grey.withOpacity(0.2)
                    )
                )
              ]
          )
      ),
    );
  }
}

/// This class represents one of the boards located inside the global dashboard, which contains information about a category

class _GlobalBoard extends StatelessWidget {

  /// This constant represents the number to display on the board

  final int number;

  /// This constant represents the category of statistic of the board

  final String category;

  /// These constants represent the position of the board inside the dashboard

  final bool top, left;

  /// This is the constructor of the class

  _GlobalBoard({this.number, this.category, this.top, this.left});

  /// This method builds and returns the widget

  @override
  Widget build(BuildContext context) {
    var color = categories[category];
    return Positioned(
        left: left ? width / 30 : width / 2.0,
        top: top ? 0 : height / 7.75,
        /// The board itself
        child: Container(
            width: width / 2.25,
            height: height / 8,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  /// The sparkling circle at the top of the board
                  DecorationDot(color),
                  /// The row containing the text and the graph
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        /// The text
                        RichText(
                          /// The number
                            text: TextSpan(
                                text: "${format(number)}\n",
                                style: TextStyle(
                                    color: color,
                                    fontSize: width / 23,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: "Calibri"
                                ),
                                children: <TextSpan>[
                                  /// The name of the category
                                  TextSpan(
                                      text: language[category],
                                      style: TextStyle(
                                          color: Colors.grey.withOpacity(0.7),
                                          fontSize: width / 30,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Calibri"
                                      )
                                  )
                                ]
                            )
                        ),
                        /// The graph
                        Container(
                            margin: EdgeInsets.only(
                                right: width / 40
                            ),
                            child: Image.asset(
                                "resources/images/graph.png",
                                width: width / 7.5
                            )
                        )
                      ]
                  )
                ]
            )
        )
    );
  }
}

/// This class represents the row located at the top of each dashboard, which contains the title, the subtitle and the add icon

class DashboardRow extends StatelessWidget {

  /// This constant represents the title of the dashboard

  final String _title;

  /// This is the constructor of the class

  DashboardRow(this._title);

  /// This method builds and return the widget

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CustomTitle(language[_title]),
              CustomSubTitle(language["globalSubTitle"]),
            ],
          ),
          Container(
              margin: EdgeInsets.only(
                  right: width / 25
              ),
              child: IconButton(
                  icon: Icon(Icons.add),
                  color: Theme.of(context).accentColor.withOpacity(0.45),
                  onPressed: () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => routes["/$_title"].call(context),
                      )
                  )
              )
          )
        ]
    );
  }
}

/// This constant represents the types of place and their search functions

const placesSearchFunctions = {
  "countries": countryByName,
  "regions": regionByName,
  "provinces": provinceByName
};

/// This constant represents the types of place and their summaries' search functions

const placesSummaryFunctions = {
  "countries": nationalSummaryByName,
  "regions": regionalSummaryByName,
  "provinces": provincialSummaryByName
};

/// This class represents a national, regional or provincial dashboard, which contains information about the places selected by the user

class PlaceDashboard extends StatelessWidget {

  /// This constant represents the type of the place

  final String _placeType;

  /// This is the constructor of the class

  PlaceDashboard(this._placeType);

  /// This method builds and returns the widget

  @override
  Widget build(BuildContext context) {
    /// The scrollable dashboard
    return Consumer<DashboardModel>(
      builder: (context, model, child) {
        var places = model.selectedPlaces[_placeType];
        var customHeight = height < 700 ? 250.0 : height / 3.05;
        return Container(
          height: _placeType != "provinces" ? customHeight : height / 5.25,
          child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: places.length,
              /// The default countries of the dashboard
              itemBuilder: (context, index) {
                var place = placesSearchFunctions[_placeType](places[index]);
                return GestureDetector(
                  onTap: () { if (place is !Province) Navigator.pushNamed(context, "/Details", arguments: DetailsArguments(_placeType, place));},
                  child: _PlaceContainer(
                      place,
                      placesSummaryFunctions[_placeType](places[index])
                  ),
                );
              }
          ),
        );
      },
    );
  }
}

/// This class represents the external container of a country, region or province located inside a dashboard

class _PlaceContainer extends StatelessWidget {

  /// This constant represents the place

  final Place _place;

  /// This constant represents the summary of the place

  final AbstractSummary _summary;

  final int index;

  /// This is the constructor of the class

  _PlaceContainer(this._place, this._summary, [this.index = -1]);

  /// This method builds and returns the widget

  @override
  Widget build(BuildContext context) {
    /// The container
    return PlaceContainer(
      _place,
      statistics()
    );
  }

  /// This method returns the statistics to display

  List<PlaceStatistic> statistics() {
    var totalConfirmed = _summary.totalConfirmed;
    var totalDeaths = _summary.totalDeaths;
    var totalRecovered = _summary.totalRecovered;
    var currentCases = _summary.currentCases;
    if (currentCases < 0 && ![totalConfirmed, totalDeaths, totalRecovered].contains(-1)) {
      currentCases = totalConfirmed - totalDeaths - totalRecovered;
    }
    if (_place is Country || _place is Region) {
      return [
        PlaceStatistic(
            currentCases,
            "currentCases"
        ),
        PlaceStatistic(
            totalDeaths,
            "deaths"
        ),
        PlaceStatistic(
            totalRecovered,
            "recoveries"
        ),
        PlaceStatistic(
            totalConfirmed,
            "totalCases"
        )
      ];
    }
    return [
      PlaceStatistic(
          totalConfirmed,
          "totalCases"
      )
    ];
  }
}

/// This class represents the statistic of a country, region or province located inside a summary

class PlaceStatistic extends StatelessWidget {

  /// This constant represents the number of the statistic

  final dynamic _number;

  /// This constant represents the category of the statistic

  final String _category;

  /// This is the constructor of the class

  PlaceStatistic(this._number, this._category);

  /// This method builds and returns the widget

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
              format(_number),
              style: TextStyle(
                  color: categories[_category],
                  fontSize: width / 32,
                  fontWeight: FontWeight.w700
              )
          ),
          Text(
              language[_category],
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: width / 35
              )
          )
        ]
    );
  }
}