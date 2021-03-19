import 'package:flutter/material.dart';
import 'package:lter/models/dashboard_model.dart';
import 'package:lter/places/places.dart';
import 'package:provider/provider.dart';

/// This class represents a single place tile in the places page

class PlaceTile extends StatefulWidget {

  /// This constant represents the type of the place

  final String _placeType;

  /// This constant represents the place

  final Place _place;

  /// This is the constructor of the class

  PlaceTile(this._placeType, this._place);

  @override
  State<StatefulWidget> createState() {
    return _PlaceTileState(_placeType, _place);
  }
}

class _PlaceTileState extends State<PlaceTile> {

  /// This constant represents the place

  final Place _place;

  /// This constant represents the type of the place

  final String _placeType;

  /// This is the constructor of the class

  _PlaceTileState(this._placeType, this._place);

  /// This variable is true if the country is selected, false if not

  var chosen;

  /// This method builds and returns the widget

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardModel>(
      builder: (context, model, child) {
        /// Whether it is selected or not
        chosen = model.selectedPlaces[_placeType].contains(_place.name);
        return GestureDetector(
            onTap: () {
              setState(() {
                /// Deselect
                if (chosen) {
                  chosen = false;
                  Provider.of<DashboardModel>(context, listen: true).remove(_place.name, _placeType);
                  /// Select
                } else {
                  chosen = true;
                  Provider.of<DashboardModel>(context, listen: true).add(_place.name, _placeType);
                }
              });
            },
            child: Container(
              height: 110,
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(250, 250, 250, 1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.withOpacity(0.15)),
                  boxShadow: [
                    BoxShadow(
                        color: chosen ? Colors.red.withOpacity(0.70) : Colors.grey.withOpacity(0.25),
                        spreadRadius: 4,
                        blurRadius: 15
                    )
                  ]
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.asset(
                    _place.flag,
                    height: 30,
                  ),
                  Container(
                    margin: EdgeInsets.all(2),
                    child: Text(
                      _place.name.split(", ")[0],
                      textAlign: TextAlign.center,
                    )
                  )
                ]
              )
            )
        );
      },
    );
  }
}