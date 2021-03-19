import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lter/pages/common_widgets.dart';
import 'package:lter/pages/home/home_page.dart';
import 'package:lter/pages/home/home_widgets.dart';

import '../../main.dart';
import 'info_widgets.dart';

class InfoPage extends StatelessWidget {

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
          if (index != 2) Navigator.pushReplacement(context, PageRouteBuilder(
              pageBuilder: (_, __, ___) => routes["/$index"](context),
              transitionDuration: Duration(seconds: 0)));
        },
        backgroundColor: Colors.white,
        currentIndex: 2,
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
            CustomTitle(
               language["preventions"]
            ),
            CustomSubTitle(
                language["againstCoronavirus"]
            ),
            Container(
              margin: EdgeInsets.only(bottom: height / 50),
              height: height/ 5.5,
              child: Row(
                children: [
                  SymptomCard(
                    language["mask"],
                    "resources/images/mask.png"
                  ),
                  SymptomCard(
                      language["hygiene"],
                      "resources/images/hands.png"
                  ),
                  SymptomCard(
                      language["distance"],
                      "resources/images/distance.png"
                  )
                ],
              ),
            ),
            CustomTitle(
              language["symptoms"]
            ),
            CustomSubTitle(
              language["causedByCoronavirus"]
            ),
            Container(
              margin: EdgeInsets.only(bottom: height / 50),
              height: height/ 5.5,
              child: Row(
                children: [
                  SymptomCard(
                      language["fever"],
                      "resources/images/fever.png"
                  ),
                  SymptomCard(
                      language["cough"],
                      "resources/images/cough.png"
                  ),
                  SymptomCard(
                      language["fatigue"],
                      "resources/images/fatigue.png"
                  )
                ],
              ),
            ),
            CustomTitle(
                language["usefulReferences"]
            ),
            CustomSubTitle(
                language["toDeepenTheTopic"]
            ),
            Container(
              margin: EdgeInsets.only(bottom: height / 50),
              height: height/ 5.85,
              child: Row(
                  children: [
                    LinkCard(
                      name: language["who"],
                      image: "who",
                      link: "https://www.who.int",
                    ),
                    LinkCard(
                      name: language["jhu"],
                      image: "jhu",
                      link: "https://www.jhu.edu",
                    ),
                    LinkCard(
                      name: language["ms"],
                      image: "ms",
                      link: "http://www.salute.gov.it/portale/home.html",
                    )
                  ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15, bottom: 25),
              child: Center(
                child: Text(
                  language["font"],
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black87
                  ),
                ),
              ),
            )
          ],
        0.23
      ),
    );
  }
}