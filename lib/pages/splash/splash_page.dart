import 'package:flutter/material.dart';

import '../../main.dart';

/// This class represents the splash screen

class SplashScreen extends StatefulWidget {

  /// This method creates and returns the state of the page

  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

/// This class represents the state of the splash screen

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {

  /// This variable represents the controller of the init fade animation

  var _controller;

  /// This variable represents the controller of the logo's rotation animation

  var _rotationController;

  /// This variable represents the init fade animation

  var _animation;

  /// This method defines the initial state of the page

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500)
    );
    _rotationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 6)
    )..repeat();
    _animation = Tween(
        begin: 0.0,
        end: 1.0
    ).animate(_controller);
  }

  /// This method disposes the controllers and the page

  @override
  void dispose() {
    _controller.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  /// This method builds and returns the widget

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    _controller.forward();
    return Scaffold(
      body: Center(
          child: FadeTransition(
            opacity: _animation,
            child: Image.asset(
              "resources/images/virus.png",
              height: height / 9,
            )
          )
      )
    );
  }
}