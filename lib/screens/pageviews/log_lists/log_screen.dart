import 'package:flutter/material.dart';
import 'package:chatapp/screens/callscreens/pickup/pickup_layout.dart';
import 'package:chatapp/screens/pageviews/log_lists/widgets/floating_column.dart';

import 'widgets/log_list_container.dart';

class LogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return PickupLayout(
      scaffold: Scaffold(
        floatingActionButton: FloatingColumn(),
        body: Center(
          child: LogListContainer(),
        ),
      ),
    );
  }
}
