import 'package:flutter/material.dart';
import 'package:wwjd_chat/util/color.dart';

import 'nav_drawer_header.dart';
import 'nav_drawer_item_list.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key, required this.baseContext});

  final BuildContext baseContext;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: bgColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const NavDrawerHeader(),
              NavDrawerItemList(context: baseContext)
            ],
          ),
        ),
      ),
    );
  }
}
