import 'package:chatapp/models/user.dart';
import 'package:chatapp/screens/chatscreens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/resources/authentication_methods.dart';
import 'package:chatapp/screens/callscreens/pickup/pickup_layout.dart';
import 'package:chatapp/utils/universal_variables.dart';
import 'package:chatapp/utils/utilities.dart';
import 'package:chatapp/widgets/custom_tile.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

// Global
final AuthenticationMethods _authenticationMethods = AuthenticationMethods();
List<User> userList;
bool isUsersFetched = false;

class _ChatListScreenState extends State<ChatListScreen> {
  String currentUserId;
  String initials = "";

  @override
  void initState() {
    super.initState();
    _authenticationMethods.getCurrentUser().then((user) {
      _authenticationMethods.fetchAllUsers(user).then((List<User> list) {
        setState(() {
          userList = list;
        });
      });
      setState(() {
        currentUserId = user.uid;
        initials = Utils.getInitials(user.displayName);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        floatingActionButton: NewChatButton(),
        body: ChatListContainer(currentUserId, userList),
      ),
    );
  }
}

class ChatListContainer extends StatefulWidget {
  final String currentUserId;
  final List<User> userList;

  ChatListContainer(this.currentUserId, this.userList);

  @override
  _ChatListContainerState createState() => _ChatListContainerState();
}

class _ChatListContainerState extends State<ChatListContainer> {
  bool isUserFetched() {
    setState(() {
      isUsersFetched = userList != null ? true : false;
    });
    return isUsersFetched;
  }

  buildSuggestions() {
    final List<User> alluserList = userList != null
        ? userList.where((User user) {
            String _getUsername = user.username.toLowerCase();
            String _getName = user.name.toLowerCase();
            bool matchesUsername = _getUsername.contains(_getUsername);
            bool matchesName = _getName.contains(_getName);

            return (matchesUsername || matchesName);
          }).toList()
        : [];

    return ListView.builder(
      itemCount: alluserList.length,
      itemBuilder: ((context, index) {
        User fetchedUser = User(
            uid: alluserList[index].uid,
            profilePhoto: alluserList[index].profilePhoto,
            name: alluserList[index].name,
            username: alluserList[index].username);

        return CustomTile(
          mini: false,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(
                          receiver: fetchedUser,
                        )));
          },
          leading: CircleAvatar(
            backgroundImage: NetworkImage(fetchedUser.profilePhoto),
            backgroundColor: Colors.grey,
          ),
          title: Text(
            fetchedUser.name,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            fetchedUser.username,
            style: TextStyle(color: UniversalVariables.greyColor),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      isUserFetched()
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: buildSuggestions(),
            )
          : Center(
              child: CircularProgressIndicator(),
            )
    ]);
  }
}

class UserCircle extends StatelessWidget {
  final String text;

  UserCircle(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: UniversalVariables.separatorColor,
      ),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: UniversalVariables.lightBlueColor,
                fontSize: 13,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: UniversalVariables.blackColor, width: 2),
                  color: UniversalVariables.onlineDotColor),
            ),
          )
        ],
      ),
    );
  }
}

class NewChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: UniversalVariables.fabGradient,
          borderRadius: BorderRadius.circular(50)),
      child: Icon(
        Icons.edit,
        color: Colors.white,
        size: 25,
      ),
      padding: EdgeInsets.all(15),
    );
  }
}
