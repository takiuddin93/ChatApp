import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chatapp/provider/user_provider.dart';
import 'package:chatapp/widgets/mainappbar.dart';
import 'package:chatapp/utils/universal_variables.dart';
import 'package:chatapp/screens/chatscreens/widgets/cached_image.dart';
import 'package:chatapp/models/users.dart';

double itemHeight;
double itemWidth;

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    Size media = MediaQuery.of(context).size;
    itemHeight = media.height;
    itemWidth = media.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: UniversalVariables.whiteColor),
        child: Column(
          children: <Widget>[
            PreferredSize(
              child: MainAppBar(
                  title: userProvider.getUser.name, back: "userprofile"),
              preferredSize: Size.fromHeight(itemHeight),
            ),
            UserDetailsBody(),
          ],
        ),
      ),
    );
  }
}

class UserDetailsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final Users users = userProvider.getUser;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          CachedImage(
            users.profilePhoto,
            isRound: true,
            radius: 80,
          ),
          SizedBox(width: itemWidth * 0.01),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                users.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: UniversalVariables.blueColor,
                ),
              ),
              SizedBox(height: 10),
              Text(
                users.email,
                style: TextStyle(
                  fontSize: 14,
                  color: UniversalVariables.subtextColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
