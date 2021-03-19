import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:lter/pages/common_widgets.dart';
import 'package:lter/pages/places/places_widgets.dart';
import 'package:lter/places/places.dart';
import 'package:lter/utils/search_bar.dart';

import '../../main.dart';

/// This constant represents the list of available places and their categories

final placesHelper = {
  "countries": countries,
  "regions": regions,
  "provinces": provinces
};

/// This class represents the page containing all the available countries, regions or provinces

class PlacesPage extends StatelessWidget {

  /// This constant represents the type of the places

  final String _placeType;

  /// This is the constructor of the page

  PlacesPage(this._placeType);

  /// This method builds and returns the widget

  @override
  Widget build(BuildContext context) {
    var places = placesHelper[_placeType];
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Image.asset(
            "resources/images/virus.png",
            height: height / 17.5,
          ),
        actions: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: EdgeInsets.only(
                right: width / 25
              ),
              child: Center(
                child: Text(
                  language["finish"],
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      /// Search bar
      body: SearchBar<Place>(
        /// Results from the search
        onSearch: (search) async {
          return places.where((element) => element.name.toLowerCase().startsWith(search.toLowerCase())).toList();
        },
        onItemFound: (place, index) {
          return PlaceTile(_placeType, place);
        },
        searchBarStyle: SearchBarStyle(
            borderRadius: BorderRadius.circular(20)
        ),
        /// No results
        emptyWidget: Center(
          child: Text("There are no $_placeType with that name"),
        ),
        searchBarPadding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: 20
        ),
          hintText: language["search"],
        /// Builds results
        /// No input
        placeHolder: GridView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: places.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemBuilder: (context, index) => PlaceTile(_placeType, places.elementAt(index))
        )
      ),
      resizeToAvoidBottomPadding: false,
    );
  }
}