import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lter/main.dart';
import 'package:url_launcher/url_launcher.dart';

class SymptomCard extends StatelessWidget {

  final String title;

  final String image;

  const SymptomCard(
    this.title,
    this.image,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width / 3.55,
      margin: EdgeInsets.only(left: width / 25, top: width / 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25),
            spreadRadius: 3,
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Image.asset(image, height: height / 11),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class LinkCard extends StatelessWidget {

  final String name, image, link;

  LinkCard({this.name, this.image, this.link});

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () => _launchURL(link),
      child: Container(
        margin: EdgeInsets.only(
          left: width / 25,
          top: width / 25,
        ),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.withOpacity(0.15)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.25),
                    spreadRadius: 4,
                    blurRadius: 15
                )
              ]
          ),
          width: width / 3.55,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(
                "resources/images/$image.png"
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 4
              ),
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w500)
              ),
            )
          ],
        ),
      ),
    );
  }
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}