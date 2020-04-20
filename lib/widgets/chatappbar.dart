import 'package:flutter/material.dart';
import 'package:chatapp/utils/universal_variables.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget> actions;
  final Widget leading;
  final bool centerTitle;

  const CustomAppBar({
    Key key,
    @required this.title,
    @required this.actions,
    @required this.leading,
    @required this.centerTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: UniversalVariables.appBar,
      elevation: 0,
      leading: leading,
      actions: actions,
      centerTitle: centerTitle,
      title: title,
    );
  }

  final Size preferredSize = const Size.fromHeight(kToolbarHeight + 10);
}
