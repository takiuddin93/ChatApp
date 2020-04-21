import 'package:chatapp/utils/universal_variables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chatapp/models/contact.dart';
import 'package:chatapp/models/user.dart';
import 'package:chatapp/provider/user_provider.dart';
import 'package:chatapp/resources/authentication_methods.dart';
import 'package:chatapp/resources/chat_methods.dart';
import 'package:chatapp/screens/chatscreens/chat_screen.dart';
import 'package:chatapp/screens/chatscreens/widgets/cached_image.dart';
import 'package:chatapp/screens/pageviews/chat_lists/widgets/online_dot_indicator.dart';
// import 'package:chatapp/utils/universal_variables.dart';
import 'package:chatapp/widgets/custom_tile.dart';

import 'last_message_container.dart';

class ChatListView extends StatelessWidget {
  final Contact contact;
  final AuthenticationMethods _authenticationMethods = AuthenticationMethods();

  ChatListView(this.contact);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _authenticationMethods.getUserDetailsById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User user = snapshot.data;

          return ViewLayout(
            contact: user,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final User contact;
  final ChatMethods _chatMethods = ChatMethods();

  ViewLayout({
    @required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return CustomTile(
      mini: false,
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              receiver: contact,
            ),
          )),
      title: Padding(
        padding: EdgeInsets.only(left: 8, top: 0, right: 0, bottom: 0),
        child: Text(
          (contact != null ? contact.name : null) != null ? contact.name : "..",
          style: TextStyle(
              color: UniversalVariables.textColor,
              fontFamily: "Arial",
              fontSize: 19),
        ),
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(left: 8, top: 0, right: 0, bottom: 0),
        child: LastMessageContainer(
          stream: _chatMethods.fetchLastMessageBetween(
            senderId: userProvider.getUser.uid,
            receiverId: contact.uid,
          ),
        ),
      ),
      leading: Container(
        constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
        child: Stack(
          children: <Widget>[
            CachedImage(
              contact.profilePhoto,
              radius: 80,
              isRound: true,
            ),
            OnlineDotIndicator(
              uid: contact.uid,
            ),
          ],
        ),
      ),
    );
  }
}
