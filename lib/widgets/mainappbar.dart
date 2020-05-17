import 'package:chatapp/provider/user_provider.dart';
import 'package:chatapp/resources/authentication_methods.dart';
import 'package:chatapp/screens/login.dart';
import 'package:chatapp/widgets/user_circle.dart';
import 'package:chatapp/screens/contact_search_screen.dart';
import 'package:chatapp/utils/universal_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/screens/dashboard.dart';
import 'package:chatapp/widgets/mainappbar_style.dart';
import 'package:chatapp/enum/user_state.dart';
import 'package:provider/provider.dart';

Color green = Color(0xFF6B8449);
Color darkgreen = Color(0xFF4C5B39);
Color black = Color(0xFF000000);
Color grey = Color(0xFF808184);
Color greyShadow = Color(0xFF33808184);
Color red = Color(0XFFFD3131);
Color white = Color(0xFFFFFFFF);

class MainAppBar extends StatelessWidget {
  final String title, back, initials;
  static const String wavingHandEmoji = "\uD83D\uDC4B";
  static const String whiteSkinTone = "\uD83C\uDFFB";

  const MainAppBar({Key key, this.title, this.back, this.initials})
      : super(key: key);

  static final AuthenticationMethods _authenticationMethods =
      AuthenticationMethods();
  static String alertdialogTitle,
      alertdialogDescription,
      alertdialogOkButton,
      alertdialogCancelButton;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        elevation: 8,
        child: Container(
          height: appBarHeight(context),
          color: UniversalVariables.appBar,
          child: Padding(
            padding: EdgeInsets.all(0.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.center,
                    child: _buildleading(context),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _buildLabel(context),
                  ),
                ),
                // Expanded(
                //   flex: 1,
                //   child: Align(
                //     alignment: Alignment.centerRight,
                //     child: _buildsearch(context),
                //   ),
                // ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _buildaction(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Builder _buildleading(BuildContext context) {
    IconData _leadingiconData;
    switch (back.toString()) {
      case "dashboard":
        {
          return Builder(
            builder: (context) => UserCircle(),
          );
        }
      case "chatscreen":
        {
          _leadingiconData = Icons.arrow_back;
        }
        break;
      case "userprofile":
        {
          _leadingiconData = Icons.arrow_back;
        }
        break;
      default:
        {
          Navigator.pop(context);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => Dashboard()));
        }
        break;
    }
    return Builder(
      builder: (context) => IconButton(
        color: green,
        icon: new Icon(
          _leadingiconData,
          color: white,
        ),
        onPressed: () {
          Navigator.pop(context);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => Dashboard()));
        },
      ),
    );
  }

  RichText _buildLabel(BuildContext context) {
    String _getEmoji;
    if (title == 'Hi there!') {
      _getEmoji = getEmoji(context);
    } else {
      _getEmoji = '';
    }
    return RichText(
      text: TextSpan(
        style: new TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          fontSize: 18.0,
          color: Colors.white,
        ),
        children: [
          TextSpan(
            text: title,
          ),
          TextSpan(text: _getEmoji),
        ],
      ),
    );
  }

  Builder _buildsearch(BuildContext context) {
    return Builder(
      builder: (context) => IconButton(
        color: Colors.white,
        icon: new Icon(Icons.search),
        onPressed: () {
          Navigator.pop(context);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => ContactSearchScreen()));
        },
      ),
    );
  }

  Builder _buildaction(BuildContext context) {
    IconData _actioniconData;
    switch (back.toString()) {
      case "dashboard":
        {
          _actioniconData = Icons.notifications;
          alertdialogTitle = 'Notifications';
          alertdialogDescription = 'This feature has not been implemented yet!';
          alertdialogOkButton = '';
          alertdialogCancelButton = 'Cancel';
        }
        break;
      case "userprofile":
        {
          _actioniconData = Icons.exit_to_app;
          alertdialogTitle = 'Logout';
          alertdialogDescription = 'Are you sure you want to logout?';
          alertdialogOkButton = 'Ok';
          alertdialogCancelButton = 'Cancel';
        }
        break;
      default:
        {
          _actioniconData = Icons.notifications;

          alertdialogTitle = 'Notifications';
          alertdialogDescription = 'This feature has not been implemented yet!';
          alertdialogOkButton = '';
          alertdialogCancelButton = 'Cancel';
        }
        break;
    }
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Builder(
      builder: (context) => IconButton(
        color: UniversalVariables.whiteColor,
        icon: new Icon(_actioniconData),
        onPressed: () {
          showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: UniversalVariables.separatorColor,
                title: Text(
                  alertdialogTitle,
                  style: TextStyle(
                    color: UniversalVariables.blueColor,
                  ),
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(
                        alertdialogDescription,
                        style: TextStyle(
                          color: UniversalVariables.blueColor,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                      child: Text(
                        alertdialogOkButton,
                        style: TextStyle(
                          color: UniversalVariables.blueColor,
                        ),
                      ),
                      onPressed: () async {
                        if (alertdialogOkButton == "Ok") {
                          final bool isLoggedOut =
                              await _authenticationMethods.signOut();
                          if (isLoggedOut) {
                            _authenticationMethods.setUserState(
                                userId: userProvider.getUser.uid,
                                userState: UserState.Offline);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()),
                                (Route<dynamic> route) => false);
                          }
                        } else {
                          Navigator.pop(context);
                        }
                      }),
                  FlatButton(
                      child: Text(
                        alertdialogCancelButton,
                        style: TextStyle(
                          color: UniversalVariables.blueColor,
                        ),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                      }),
                ],
              );
            },
          );
        },
      ),
    );
  }

  // https://github.com/flutter/flutter/issues/9652
  String getEmoji(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS
        ? wavingHandEmoji
        : wavingHandEmoji + whiteSkinTone;
  }
}
