import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lter/data/summary.dart';
import 'package:lter/places/places.dart';

import '../main.dart';
import 'home/home_widgets.dart';

/// This class represents a large container containing a global summary or a daily national or regional summary in the details page

class LargeSummaryContainer extends StatelessWidget {

  /// This constant represents the factor used to determine the height of the container

  final double _heightFactor;

  /// This constant represents the child of the container

  final Widget _child;

  /// This is the constructor of the class

  LargeSummaryContainer(this._heightFactor, this._child);

  /// This method builds and returns the widget

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(
            horizontal: width / 25,
            vertical: height / 50
        ),
        width: width,
        height: height / _heightFactor,
        /// The decoration of the external container
        decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.circular(25),
            boxShadow: <BoxShadow>[
              /// The shadow of the external container
              BoxShadow(
                  color: Colors.grey.withOpacity(0.25),
                  spreadRadius: 3,
                  blurRadius: 15
              )
            ]
        ),
        child: _child
    );
  }
}

/// This class represents the circled decoration located over a main statistic

class DecorationDot extends StatelessWidget {

  /// This constant represents the color of the dot

  final Color color;

  /// This is the constructor of the class

  DecorationDot(this.color);

  /// This method builds and returns the widget

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width / 20,
        height: height / 75,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: <BoxShadow>[
              /// The shadow of the circle at the of the board
              BoxShadow(
                  color: color,
                  spreadRadius: 1,
                  blurRadius: 15
              )
            ]
        )
    );
  }
}

/// This class represents the external container of a country, region or province located inside a dashboard

class PlaceContainer extends StatelessWidget {

  /// This constant represents the place

  final Place _place;

  final int index;

  final List<PlaceStatistic> stats;

  /// This is the constructor of the class

  PlaceContainer(this._place, this.stats, [this.index = -1]);

  /// This method builds and returns the widget

  @override
  Widget build(BuildContext context) {
    /// The container
    return Container(
        margin: EdgeInsets.symmetric(
            horizontal: width / 30,
            vertical: height / 50
        ),
        width: index == -1 ? width / 3.3 : width / 3.1,
        /// The decoration of the container
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
                color: Theme.of(context).backgroundColor
            ),
            boxShadow: <BoxShadow>[
              /// The shadow of the container
              BoxShadow(
                color: Colors.grey.withOpacity(0.25),
                spreadRadius: 3,
                blurRadius: 15,
              )
            ]
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              /// The flag of the place
              Image.asset(
                  _place.flag,
                  width: width / 13
              ),
              /// The name of the place
              Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: 1
                  ),
                  child: Text(
                      _place.name.split(", ")[0],
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: width / 32,
                          fontWeight: FontWeight.w800,
                          fontFamily: "Calibri"
                      )
                  )
              ),
              /*if(index != -1) Text(
                  "#" + index.toString(),
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 11
                  )
              ),*/
              /// The horizontal divider
              Container(
                  height: 1,
                  width: width / 8,
                  color: Colors.grey.withOpacity(0.5)
              ),
              /// The available statistics
              ...stats
            ]
        )
    );
  }
}

/// This class represents the clip path located at the top of the page, which contains the image of the doctor and the text

class CustomClipPath extends StatelessWidget {

  /// This method builds and returns the widget

  @override
  Widget build(BuildContext context) {
    return ClipPath(
        clipper: _CustomClipper(),
        child: Container(
            width: width,
            height: height / 3.75,
            color: Theme.of(context).primaryColor,
            child: Align(
                alignment: Alignment.topCenter,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      /// The image of the doctor
                      Container(
                          width: width / 4.2,
                          height: width / 2.9,
                          margin: EdgeInsets.only(
                              top: height / 100
                          ),
                          child: Image.asset(
                              "resources/images/doctor.png",
                              fit: BoxFit.fill
                          )
                      ),
                      SizedBox(
                        width: width / 25,
                      ),
                      /// The text
                      Text(
                          language["clipTitle"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: width / 25,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Corbel"
                          )
                      )
                    ]
                )
            )
        )
    );
  }
}

/// This class represents the custom clipper of the clip path located at the top of the page

class _CustomClipper extends CustomClipper<Path> {

  /// This method creates and returns the clip of the clipper

  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0, size.height / 1.4)
      ..quadraticBezierTo(size.width / 2, size.height, size.width, size.height / 1.4)
      ..lineTo(size.width, 0);
  }

  /// This method returns whether the clipper should reclip or not

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}