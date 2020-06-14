import 'package:chatapp/provider/user_provider.dart';
import 'package:chatapp/resources/authentication_methods.dart';
import 'package:chatapp/screens/login.dart';
import 'package:chatapp/widgets/custom_notification_dialog_widget.dart';
import 'package:chatapp/widgets/user_circle.dart';
import 'package:chatapp/screens/contact_search_screen.dart';
import 'package:chatapp/utils/universal_variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/screens/dashboard.dart';
import 'package:chatapp/widgets/mainappbar_style.dart';
import 'package:chatapp/enum/user_state.dart';
import 'package:provider/provider.dart';

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
      case "log":
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
        color: UniversalVariables.appBarBackIcon,
        icon: new Icon(
          _leadingiconData,
          color: UniversalVariables.appBarBackIcon,
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
          color: UniversalVariables.textColor,
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
          alertdialogOkButton = 'Ok';
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
          alertdialogOkButton = 'Ok';
          alertdialogCancelButton = 'Cancel';
        }
        break;
    }
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return Builder(
      builder: (context) => IconButton(
        color: UniversalVariables.appBarNotificationsIcon,
        icon: new Icon(_actioniconData),
        onPressed: () {
          CustomDialog.showScaleAlertBox(
            context: context,
            title: alertdialogTitle,
            icon: Icons.info_outline, // IF YOU WANT TO ADD ICON
            text: alertdialogDescription, // IF YOU WANT TO ADD
            firstButton: back.toString() == 'userprofile'
                ? alertdialogOkButton
                : alertdialogCancelButton,
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
