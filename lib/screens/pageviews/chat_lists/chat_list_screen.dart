import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chatapp/models/contact.dart';
import 'package:chatapp/provider/user_provider.dart';
// import 'package:chatapp/resources/authentication_methods.dart';
import 'package:chatapp/resources/chat_methods.dart';
import 'package:chatapp/screens/callscreens/pickup/pickup_layout.dart';
import 'package:chatapp/screens/pageviews/chat_lists/widgets/contact_view.dart';
import 'package:chatapp/screens/pageviews/chat_lists/widgets/new_chat_button.dart';
import 'package:chatapp/screens/pageviews/chat_lists/widgets/quiet_box.dart';
// import 'package:chatapp/screens/pageviews/chat_lists/widgets/user_circle.dart';
import 'package:chatapp/utils/universal_variables.dart';
// import 'package:chatapp/utils/utilities.dart';
// import 'package:chatapp/widgets/custom_tile.dart';

class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        body: ChatListContainer(),
        floatingActionButton: NewChatButton(),
      ),
    );
  }
}

class ChatListContainer extends StatelessWidget {
  final ChatMethods _chatMethods = ChatMethods();

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: _chatMethods.fetchContacts(
            userId: userProvider.getUser.uid,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var docList = snapshot.data.documents;

              if (docList.isEmpty) {
                return QuietBox();
              }
              return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  Contact contact = Contact.fromMap(docList[index].data);

                  return ContactView(contact);
                },
              );
            }

            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
