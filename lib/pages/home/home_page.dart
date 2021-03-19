import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lter/pages/common_widgets.dart';

import '../../main.dart';
import 'home_widgets.dart';

/// This class represents the state of the home page of the application

class HomePage extends StatelessWidget {

  /// This method builds and returns the widget

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: Image.asset(
              "resources/images/virus.png",
              height: height / 17.5,
            )
        ),
        bottomNavigationBar: CupertinoTabBar(
          onTap: (index) {
            if (index != 0) Navigator.pushReplacement(context, PageRouteBuilder(
              pageBuilder: (_, __, ___) => routes["/$index"](context),
              transitionDuration: Duration(seconds: 0)));
          },
          backgroundColor: Colors.white,
          currentIndex: 0,
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
        body: Body(
          [
            CustomClipPath(),
            CustomTitle(language["global"]),
            CustomSubTitle(language["globalSubTitle"]),
            GlobalDashboard(),
            DashboardRow("countries"),
            PlaceDashboard("countries"),
            DashboardRow("regions"),
            PlaceDashboard("regions"),
            DashboardRow("provinces"),
            PlaceDashboard("provinces")
          ],
          0.7
        )
    );
  }
}

/// This class represents the body of the home page of the application

class Body extends StatefulWidget {

  final List<Widget> children;

  final double heightFactor;

  Body(this.children, this.heightFactor);

  /// This method creates and returns the state of the page

  @override
  State<StatefulWidget> createState() {
    return _BodyState(children, heightFactor);
  }
}

/// This class represents the state of the body of the home page of the application

class _BodyState extends State<Body> {

  final double heightFactor;

  /// This variable represents the controller of the main list view of the page

  ScrollController _controller;

  /// This variable represents the body of the page

  var _body;

  /// This variable represents the color of the background of the page, which is used to handle colors
  /// with the bouncing scroll physics of the list view

  var _color = Colors.white;

  final List<Widget> children;

  _BodyState(this.children, this.heightFactor);

  /// This method initializes the controller and the body once and avoids that they get rebuilt
  /// every time the background color changes

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_listener);
    this._body = ListView(
        controller: _controller,
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Container(
              color: Colors.white,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ...children
                  ]
              )
          )
        ]
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// This method builds and returns the widget

  @override
  Widget build(BuildContext context) {
    return Container(
        color: _color,
        child: _body
    );
  }

  /// This method handles the scrolling so that colors don't fuck up because of the
  /// bouncing scroll physics

  void _listener() {
    if (_controller.offset < 0 && _color == Colors.white) {
      setState(() {
        _color = Colors.red;
      });
    }
    if (_controller.offset > height * heightFactor && _color == Colors.red) {
      setState(() {
        _color = Colors.white;
      });
    }
  }
}