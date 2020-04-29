import 'package:chatapp/enum/user_state.dart';
import 'package:chatapp/resources/authentication_methods.dart';
import 'package:chatapp/screens/pageviews/contact_lists/contact_list_screen.dart';
import 'package:chatapp/utils/utilities.dart';
import 'package:chatapp/widgets/mainappbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:chatapp/provider/user_provider.dart';
import 'package:chatapp/screens/callscreens/pickup/pickup_layout.dart';
import 'package:chatapp/screens/pageviews/chat_lists/chat_list_screen.dart';
import 'package:chatapp/utils/universal_variables.dart';

void main() async {
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(Dashboard());
}

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyDashboard(title: 'Hi there!'),
    );
  }
}

class MyDashboard extends StatefulWidget {
  MyDashboard({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _MyDashboardState createState() => _MyDashboardState();
}

class _MyDashboardState extends State<MyDashboard> with WidgetsBindingObserver {
  PageController pageController;
  int _page = 0;

  UserProvider userProvider;

  String currentUserId;
  String initials;

  final AuthenticationMethods _authenticationMethods = AuthenticationMethods();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.refreshUser();

      _authenticationMethods.setUserState(
        userId: userProvider.getUser.uid,
        userState: UserState.Online,
      );
    });

    WidgetsBinding.instance.addObserver(this);

    pageController = PageController();

    _authenticationMethods.getCurrentUser().then((user) {
      setState(() {
        currentUserId = user.uid;
        initials = Utils.getInitials(user.displayName);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    String currentUserId =
        (userProvider != null && userProvider.getUser != null)
            ? userProvider.getUser.uid
            : "";

    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        currentUserId != null
            ? _authenticationMethods.setUserState(
                userId: currentUserId, userState: UserState.Online)
            : print("resume state");
        break;
      case AppLifecycleState.inactive:
        currentUserId != null
            ? _authenticationMethods.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print("inactive state");
        break;
      case AppLifecycleState.paused:
        currentUserId != null
            ? _authenticationMethods.setUserState(
                userId: currentUserId, userState: UserState.Waiting)
            : print("paused state");
        break;
      case AppLifecycleState.detached:
        currentUserId != null
            ? _authenticationMethods.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print("detached state");
        break;
    }
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    double _labelFontSize = 10;

    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.whiteColor,
        appBar: PreferredSize(
          child: MainAppBar(
              title: widget.title, back: "dashboard", initials: initials),
          preferredSize: Size.fromHeight(media.height),
        ),
        body: PageView(
          children: <Widget>[
            Container(
              child: ChatListScreen(),
            ),
            Center(
                child: Text(
              "Group Chats",
              style: TextStyle(
                color: UniversalVariables.blueColor,
              ),
            )),
            Center(
                child: Text(
              "Call Logs",
              style: TextStyle(
                color: UniversalVariables.blueColor,
              ),
            )),
            Center(child: ContactListScreen()),
          ],
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 0),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: UniversalVariables.whiteColor,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat,
                      color: (_page == 0)
                          ? UniversalVariables.blueColor
                          : UniversalVariables.greyColor),
                  title: Text(
                    "",
                    style: TextStyle(
                        fontSize: _labelFontSize,
                        color: (_page == 0)
                            ? UniversalVariables.blueColor
                            : Colors.grey,
                        height: 0.0),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.group_add,
                      color: (_page == 1)
                          ? UniversalVariables.blueColor
                          : UniversalVariables.greyColor),
                  title: Text(
                    "",
                    style: TextStyle(
                        fontSize: _labelFontSize,
                        color: (_page == 1)
                            ? UniversalVariables.blueColor
                            : Colors.grey,
                        height: 0.0),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.call,
                      color: (_page == 1)
                          ? UniversalVariables.blueColor
                          : UniversalVariables.greyColor),
                  title: Text(
                    "",
                    style: TextStyle(
                        fontSize: _labelFontSize,
                        color: (_page == 1)
                            ? UniversalVariables.blueColor
                            : Colors.grey,
                        height: 0.0),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.contact_phone,
                      color: (_page == 2)
                          ? UniversalVariables.blueColor
                          : UniversalVariables.greyColor),
                  title: Text(
                    "",
                    style: TextStyle(
                        fontSize: _labelFontSize,
                        color: (_page == 2)
                            ? UniversalVariables.blueColor
                            : Colors.grey,
                        height: 0.0),
                  ),
                ),
              ],
              onTap: navigationTapped,
              currentIndex: _page,
            ),
          ),
        ),
      ),
    );
  }
}
