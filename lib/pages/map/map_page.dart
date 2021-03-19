import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lter/data/summary.dart';
import 'package:lter/geo/geo_place.dart';
import 'package:lter/places/places.dart';

import '../../main.dart';

class MapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MapPageState();
  }

}

class _MapPageState extends State<MapPage> with SingleTickerProviderStateMixin {

  Set<Polygon> polygons = {};

  var future;

  var _controller;

  var _animation;

  @override
  void initState() {
    future = fetchCoordinates();
    _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 2000)
    );
    _animation = Tween<double>(
        begin: 0.0,
        end: 1.0
    ).animate(_controller);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CupertinoTabBar(
        onTap: (index) {
          if (index != 1) Navigator.pushReplacement(context, PageRouteBuilder(
            pageBuilder: (_, __, ___) => routes["/$index"](context),
            transitionDuration: Duration(seconds: 0),
          ),);
        },
        backgroundColor: Colors.white,
        currentIndex: 1,
        activeColor: Colors.red,
        inactiveColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),

          )
        ],
      ),
      body: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _controller.forward();
            return FadeTransition(
              opacity: _animation,
              child: GoogleMap(
                onMapCreated: (controller) => mapController = controller..setMapStyle('''
                [
  {
          "elementType": "labels",
          "stylers": [
              {
                "visibility": "off"
              }
          ]
  },
  {
          "featureType": "administrative",
          "elementType": "geometry",
          "stylers": [
              {
                "visibility": "off"
              }
          ]
  },
  {
          "featureType": "administrative.neighborhood",
          "stylers": [
              {
                "visibility": "off"
              }
          ]
  },
  {
          "featureType": "poi",
          "stylers": [
              {
                "visibility": "off"
              }
          ]
  },
  {
          "featureType": "road",
          "stylers": [
              {
                "visibility": "off"
              }
          ]
  },
  {
          "featureType": "road",
          "elementType": "labels.icon",
          "stylers": [
              {
                "visibility": "off"
              }
          ]
  },
  {
          "featureType": "transit",
          "stylers": [
              {
                "visibility": "off"
              }
          ]
  }
]
                '''),
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(target: LatLng(41.87,12.56), zoom: 3),
                compassEnabled: false,
                mapToolbarEnabled: false,
                minMaxZoomPreference: MinMaxZoomPreference(0, 5),
                tiltGesturesEnabled: false,
                myLocationButtonEnabled: false,
                buildingsEnabled: false,
                trafficEnabled: false,
                polygons: polygons,
              ),
            );
          }
            return SafeArea(child: Center(child: CupertinoActivityIndicator(radius: 12,)));
        },
      ),
    );
  }

  Future<String> fetchCoordinates() async {
    var a = await rootBundle.loadString("resources/geo/custom_geo.json");
    var json = jsonDecode(a)["features"] as List;
    List<GeoCountry> geoCountries = json.map((e) => GeoCountry.fromJson(e))
        .toList();
    geoCountries.forEach((geoCountry) {
      var a = geoCountry.coordinates;
      if (geoCountry.coordinates[0][0][0] is List) {
        a = geoCountry.coordinates.expand((element) => element).toList();
      }
      a.forEach((element) {
        List<LatLng> points = [];
        for (int i = 0; i < element.length; i++) {
          points.add(LatLng(double.parse(element[i][1].toString()),
              double.parse(element[i][0].toString())));
        }
        polygons.add(Polygon(
            polygonId: PolygonId(geoCountry.name),
            points: points,
            consumeTapEvents: true,
            strokeColor: Colors.white.withOpacity(0.3),
            strokeWidth: 1,
            fillColor: Colors.red.withOpacity(List.from(nationalSummaries.reversed).indexOf(nationalSummaryByName(geoCountry.name)) / 200)
        ));
      });
    });
    return "";
  }
}