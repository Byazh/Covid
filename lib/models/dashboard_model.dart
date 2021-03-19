import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:lter/cache/cache.dart';

/// This constant represents the default places used on the first launch of the
/// application

const defaultSelectedPlaces = {
  "countries": [
    "Italy",
    "United States of America",
    "Brazil"
  ],
  "regions": [
    "Lombardia, Italy",
    "Delhi, India",
    "Hong Kong, China"
  ],
  "provinces": [
    "Milano, Lombardia",
    "Roma, Lazio",
    "Venezia, Veneto"
  ]
};

/// This class represents the model of the national, regional and provincial dashboards

class DashboardModel extends ChangeNotifier {

  /// This constant represents the current places selected by the user

  var selectedPlaces = <String, dynamic>{
    "countries": [],
    "regions": [],
    "provinces": []
  };

  /// This method adds a place to its category in the selected places map and rebuilds the dashboards

  void add(String name, String category) {
    selectedPlaces[category].add(name);
    _savePlaces();
    notifyListeners();
  }

  /// This method removes a place from its category in the selected places map and rebuilds the dashboards

  void remove(String name, String category) {
    selectedPlaces[category].remove(name);
    _savePlaces();
    notifyListeners();
  }
  /// This method saves the selected places by writing them in the cache file

  void _savePlaces() async {
    SELECTED_PLACES_CACHE.write(jsonEncode(selectedPlaces));
  }
}