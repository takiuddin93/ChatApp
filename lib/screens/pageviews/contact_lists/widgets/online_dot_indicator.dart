import 'package:chatapp/utils/universal_variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/enum/user_state.dart';
import 'package:chatapp/models/users.dart';
import 'package:chatapp/resources/authentication_methods.dart';
import 'package:chatapp/utils/utilities.dart';

class OnlineDotIndicator extends StatelessWidget {
  final String uid;
  final AuthenticationMethods _authenticationMethods = AuthenticationMethods();

  OnlineDotIndicator({
    @required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    getColor(int state) {
      switch (Utils.numToState(state)) {
        case UserState.Offline:
          return UniversalVariables.offlineDotColor;
        case UserState.Online:
          return UniversalVariables.onlineDotColor;
        case UserState.Waiting:
          return UniversalVariables.waitingDotColor;
        default:
          return UniversalVariables.waitingDotColor;
      }
    }

    return Align(
      alignment: Alignment.topRight,
      child: StreamBuilder<DocumentSnapshot>(
        stream: _authenticationMethods.getUserStream(
          uid: uid,
        ),
        builder: (context, snapshot) {
          Users users;

          if (snapshot.hasData && snapshot.data.data != null) {
            users = Users.fromMap(snapshot.data.data());
          }

          return Container(
            height: 10,
            width: 10,
            margin: EdgeInsets.only(right: 2, top: 46),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: getColor(users?.state),
            ),
          );
        },
      ),
    );
  }
}
