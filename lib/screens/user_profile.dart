import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chatapp/provider/user_provider.dart';
import 'package:chatapp/widgets/mainappbar.dart';
import 'package:chatapp/utils/universal_variables.dart';
import 'package:chatapp/screens/chatscreens/widgets/cached_image.dart';
import 'package:chatapp/resources/authentication_methods.dart';
import 'package:chatapp/screens/login.dart';
import 'package:chatapp/models/user.dart';
import 'package:flutter/services.dart';

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    Size media = MediaQuery.of(context).size;
    final double itemHeight = media.height;
    final double itemWidth = media.width;
    signOut() async {
      final bool isLoggedOut = await AuthenticationMethods().signOut();
      if (isLoggedOut) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Login()),
            (Route<dynamic> route) => false);
      }
    }

    return Container(
      decoration: BoxDecoration(color: UniversalVariables.whiteColor),
      child: Column(
        children: <Widget>[
          PreferredSize(
            child: MainAppBar(
                title: userProvider.getUser.name, back: "userprofile"),
            preferredSize: Size.fromHeight(media.height),
          ),
          UserDetailsBody(),
        ],
      ),
    );
  }
}

class UserDetailsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final User user = userProvider.getUser;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          CachedImage(
            user.profilePhoto,
            isRound: true,
            radius: 50,
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                user.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: UniversalVariables.blueColor,
                ),
              ),
              SizedBox(height: 10),
              Text(
                user.email,
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
