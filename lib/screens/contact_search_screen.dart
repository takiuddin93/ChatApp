import 'package:chatapp/provider/user_provider.dart';
import 'package:chatapp/resources/contact_methods.dart';
import 'package:chatapp/screens/dashboard.dart';
import 'package:chatapp/widgets/mainappbar_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/models/user.dart';
import 'package:chatapp/resources/authentication_methods.dart';
import 'package:chatapp/screens/callscreens/pickup/pickup_layout.dart';
import 'package:chatapp/screens/chatscreens/chat_screen.dart';
import 'package:chatapp/utils/universal_variables.dart';
import 'package:chatapp/widgets/custom_tile.dart';
import 'package:provider/provider.dart';

import 'chatscreens/chat_screen.dart';

class ContactSearchScreen extends StatefulWidget {
  @override
  _ContactSearchScreenState createState() => _ContactSearchScreenState();
}

class _ContactSearchScreenState extends State<ContactSearchScreen> {
  final AuthenticationMethods _authenticationMethods = AuthenticationMethods();

  final ContactMethods _contactMethods = ContactMethods();

  List<User> userList;
  String query = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _authenticationMethods.getCurrentUser().then((FirebaseUser user) {
      _authenticationMethods.fetchAllUsers(user).then((List<User> list) {
        setState(() {
          userList = list;
        });
      });
    });
  }

  searchAppBar(BuildContext context) {
    return Container(
      height: appBarHeight(context),
      color: UniversalVariables.appBar,
      child: Padding(
        padding: EdgeInsets.all(0.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.center,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: UniversalVariables.whiteColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => Dashboard()));
                  },
                ),
              ),
            ),
            Expanded(
              flex: 9,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: TextField(
                    controller: searchController,
                    onChanged: (val) {
                      setState(() {
                        query = val;
                      });
                    },
                    cursorColor: UniversalVariables.blackColor,
                    autofocus: true,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: UniversalVariables.whiteColor,
                      fontSize: 24,
                    ),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: UniversalVariables.whiteColor,
                        ),
                        onPressed: () {
                          WidgetsBinding.instance.addPostFrameCallback(
                              (_) => searchController.clear());
                        },
                      ),
                      border: InputBorder.none,
                      hintText: "Search to add to contact",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Color(0x88ffffff),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildSuggestions(UserProvider userProvider, String query) {
    final List<User> suggestionList = query.isEmpty
        ? []
        : userList != null
            ? userList.where((User user) {
                String _getUsername = user.username.toLowerCase();
                String _query = query.toLowerCase();
                String _getName = user.name.toLowerCase();
                bool matchesUsername = _getUsername.contains(_query);
                bool matchesName = _getName.contains(_query);

                return (matchesUsername || matchesName);
              }).toList()
            : [];

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: ((context, index) {
        User searchedUser = User(
            uid: suggestionList[index].uid,
            profilePhoto: suggestionList[index].profilePhoto,
            name: suggestionList[index].name,
            username: suggestionList[index].username,
            firebaseToken: suggestionList[index].firebaseToken);
        // print("Role: " + searchedUser.role);
        return CustomTile(
          mini: false,
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatScreen(
                        receiver: searchedUser,
                      ))),
          title: Padding(
            padding: EdgeInsets.only(left: 8, top: 0, right: 0, bottom: 0),
            child: Text(
              searchedUser.name,
              style: TextStyle(
                color: UniversalVariables.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(left: 8, top: 0, right: 0, bottom: 0),
            child: Text(
              searchedUser.username,
              style: TextStyle(color: UniversalVariables.subtextColor),
            ),
          ),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(searchedUser.profilePhoto),
            backgroundColor: UniversalVariables.greyColor,
          ),
          trailing: Container(
              decoration: BoxDecoration(
                  color: UniversalVariables.blueColor,
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              // color: UniversalVariables.blueColor,
              child: FlatButton(
                  onPressed: () => _contactMethods.addContactToDb(
                      userProvider.getUser, searchedUser),
                  child: Text(
                    "Add Contact",
                    style: TextStyle(
                      color: UniversalVariables.whiteColor,
                    ),
                  ))),
        );

        // return searchedUser.role == 'doctor'
        //     ? CustomTile(
        //         mini: false,
        //         onTap: () => Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //                 builder: (context) => ChatScreen(
        //                       receiver: searchedUser,
        //                     ))),
        //         title: Padding(
        //           padding:
        //               EdgeInsets.only(left: 8, top: 0, right: 0, bottom: 0),
        //           child: Text(
        //             searchedUser.name,
        //             style: TextStyle(
        //               color: UniversalVariables.textColor,
        //               fontWeight: FontWeight.bold,
        //             ),
        //           ),
        //         ),
        //         subtitle: Padding(
        //           padding:
        //               EdgeInsets.only(left: 8, top: 0, right: 0, bottom: 0),
        //           child: Text(
        //             searchedUser.username,
        //             style: TextStyle(color: UniversalVariables.subtextColor),
        //           ),
        //         ),
        //         leading: CircleAvatar(
        //           backgroundImage: NetworkImage(searchedUser.profilePhoto),
        //           backgroundColor: UniversalVariables.greyColor,
        //         ),
        //         trailing: Container(
        //             decoration: BoxDecoration(
        //                 color: UniversalVariables.blueColor,
        //                 borderRadius: BorderRadius.all(Radius.circular(4))),
        //             // color: UniversalVariables.blueColor,
        //             child: FlatButton(
        //                 onPressed: () => _contactMethods.addContactToDb(
        //                     userProvider.getUser, searchedUser),
        //                 child: Text(
        //                   "Add Contact",
        //                   style: TextStyle(
        //                     color: UniversalVariables.whiteColor,
        //                   ),
        //                 ))),
        //       )
        //     : null;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.whiteColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: searchAppBar(context),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: buildSuggestions(userProvider, query),
        ),
      ),
    );
  }
}
