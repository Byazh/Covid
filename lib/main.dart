import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lter/models/dashboard_model.dart';
import 'package:lter/pages/details/details_page.dart';
import 'package:lter/pages/home/home_page.dart';
import 'package:lter/pages/info/info_page.dart';
import 'package:lter/pages/map/map_page.dart';
import 'package:lter/pages/places/places_page.dart';
import 'package:lter/pages/splash/splash_page.dart';
import 'package:provider/provider.dart';

import 'cache/cache.dart';
import 'data/summary.dart';

/// These variables represents the width and the height of the device

double width, height;

Map<String, dynamic> language;

/// This is the main method of the application

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final content = await SELECTED_PLACES_CACHE.read();
  runApp(
      ChangeNotifierProvider(
        create: (context) {
          var model = DashboardModel();
          if (content != null && content.contains("{") && content.contains("}")) {
            model.selectedPlaces = jsonDecode(content);
          } else {
            SELECTED_PLACES_CACHE.write(jsonEncode(defaultSelectedPlaces));
            model.selectedPlaces = defaultSelectedPlaces;
          }
          return model;
        },
        child: _Application(),
      )
  );
}

/// This constant represents the routes of the application

final routes = <String, WidgetBuilder>{
  "/0": (context) => HomePage(),
  "/1": (context) => MapPage(),
  "/2": (context) => InfoPage(),
  "/countries": (context) => PlacesPage("countries"),
  "/regions": (context) => PlacesPage("regions"),
  "/provinces": (context) => PlacesPage("provinces"),
  "/Details": (context) => DetailsPage()
};

/// This class represents the application itself

class _Application extends StatelessWidget {

  /// This method builds and returns the widget

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            scaffoldBackgroundColor: Colors.white,
            primaryColor: Colors.red,
            accentColor: Colors.black
        ),
        supportedLocales: [
          Locale("en"),
          Locale("it")
        ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
        routes: routes,
        title: "Iter",
        home: Builder(builder: (context) {
          Locale locale = Localizations.localeOf(context);
          print(locale.toString());
          rootBundle.loadString("resources/lang/${locale.toString()}.json").then((value) => language = jsonDecode(value));
          return _ApplicationFuture();
        }),
    );
  }
}

/// This class represents the future builder that handles the start of the application

class _ApplicationFuture extends StatefulWidget {

  /// This method creates and returns the state of the page

  @override
  State<StatefulWidget> createState() {
    return _ApplicationFutureState();
  }
}

/// This class represents the state of the future builder that handles the start of the application

class _ApplicationFutureState extends State<_ApplicationFuture> with SingleTickerProviderStateMixin {

  /// This variable represents the summary fetched from the internet

  var _summary;

  var screen;

  var _controller;

  var _animation;

  /// This method defines the initial state of the widget

  @override
  void initState() {
    _summary = fetchSummaries().timeout(Duration(seconds: 3), onTimeout: () => fetchCachedSummaries());
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500)
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0
    ).animate(_controller);
    screen = SplashScreen();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// This method builds and returns the widget

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _summary,
           builder: (context, snapshot) {
          if (snapshot.hasData) {
            Future.delayed(Duration(milliseconds: 500), () {
              if (mounted) {
                setState(() {
                  screen = Container(
                    color: Colors.white,
                    child: FadeTransition(
                        opacity: _animation,
                        child: HomePage()
                    ),
                  );
                  _controller.forward();
                });
              }
            });
          }
          return screen;
        }
    );
  }
}