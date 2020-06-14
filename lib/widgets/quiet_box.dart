import 'package:flutter/material.dart';
import 'package:chatapp/screens/contact_search_screen.dart';
import 'package:chatapp/screens/group_search_screen.dart';
import 'package:chatapp/utils/universal_variables.dart';

class ContactQuietBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: UniversalVariables.separatorColor,
          ),
          padding: EdgeInsets.symmetric(vertical: 35, horizontal: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "This is where all the contacts are listed",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: UniversalVariables.textColor,
                ),
              ),
              SizedBox(height: 25),
              Text(
                "Search for your friends and family to start calling or chatting with them",
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  color: UniversalVariables.textColor,
                ),
              ),
              SizedBox(height: 25),
              FlatButton(
                color: UniversalVariables.darkblueColor,
                child: Text(
                  "START SEARCHING",
                  style: TextStyle(
                    color: UniversalVariables.whiteColor,
                  ),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactSearchScreen(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GroupQuietBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          color: UniversalVariables.separatorColor,
          padding: EdgeInsets.symmetric(vertical: 35, horizontal: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "This is where all the contacts are listed",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: UniversalVariables.blueColor,
                ),
              ),
              SizedBox(height: 25),
              Text(
                "Search for your friends and family to start calling or chatting with them",
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  color: UniversalVariables.blueColor,
                ),
              ),
              SizedBox(height: 25),
              FlatButton(
                color: UniversalVariables.blueColor,
                child: Text(
                  "START SEARCHING",
                  style: TextStyle(
                    color: UniversalVariables.whiteColor,
                  ),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroupSearchScreen(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuietBox extends StatelessWidget {
  final String heading;
  final String subtitle;

  QuietBox({
    @required this.heading,
    @required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          color: UniversalVariables.separatorColor,
          padding: EdgeInsets.symmetric(vertical: 35, horizontal: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                heading,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 25),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 25),
              FlatButton(
                color: UniversalVariables.whiteColor,
                child: Text("START SEARCHING"),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactSearchScreen(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
