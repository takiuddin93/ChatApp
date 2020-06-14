import 'package:chatapp/utils/universal_variables.dart';
import 'package:flutter/material.dart';

class CustomDialog {
  static Future showScaleAlertBox({
    @required BuildContext context,
    @required String title,
    IconData icon,
    @required String text,
    @required String firstButton,
  }) {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.7),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                backgroundColor: UniversalVariables.separatorColor,
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                title: Center(
                    child: Text(
                  title,
                  style: TextStyle(color: UniversalVariables.blueColor),
                )),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      icon,
                      color: UniversalVariables.blueColor,
                    ),
                    Container(
                      height: 10,
                    ),
                    Container(
                      child: Text(
                        text,
                        style: TextStyle(color: UniversalVariables.blueColor),
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  MaterialButton(
                    // OPTIONAL BUTTON
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                    color: UniversalVariables.blueColor,
                    child: Text(
                      firstButton,
                      style: TextStyle(color: UniversalVariables.whiteColor),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 128),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return null;
        });
  }
}
