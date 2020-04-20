import 'package:chatapp/screens/dashboard.dart';
import 'package:chatapp/widgets/mainappbar_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:chatapp/models/user.dart';
import 'package:chatapp/resources/authentication_methods.dart';
import 'package:chatapp/screens/callscreens/pickup/pickup_layout.dart';
import 'package:chatapp/screens/chatscreens/chat_screen.dart';
import 'package:chatapp/utils/universal_variables.dart';
import 'package:chatapp/widgets/custom_tile.dart';

import 'chatscreens/chat_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final AuthenticationMethods _authenticationMethods = AuthenticationMethods();

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
              flex: 2,
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
              flex: 8,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20),
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
                      fontSize: 35,
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
                      hintText: "Search",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
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

  buildSuggestions(String query) {
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
            username: suggestionList[index].username);

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
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.whiteColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: searchAppBar(context),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: buildSuggestions(query),
        ),
      ),
    );
  }
}
