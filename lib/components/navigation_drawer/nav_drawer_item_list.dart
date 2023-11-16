import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wwjd_chat/data_source/local/secure_storage.dart';
import 'package:wwjd_chat/screens/feedback/feedback_screen.dart';
import 'package:wwjd_chat/screens/metrics/metric_screen.dart';
import 'package:wwjd_chat/util/constant.dart';

import '../../components/dialog_widgets/logout_confirmation_dialog.dart';
import '../../model/user.dart';
import '../../screens/auth/auth_screen.dart';
import '../../screens/chat/chat_screen.dart';
import '../../util/color.dart';

class NavDrawerItemList extends StatefulWidget {
  final BuildContext context;

  NavDrawerItemList({super.key, required this.context});

  @override
  State<NavDrawerItemList> createState() => _NavDrawerItemListState();
}

class _NavDrawerItemListState extends State<NavDrawerItemList> {
  final _controller = TextEditingController();

  User _user=User(isSuperuser: false);

  @override
  void initState() {
    super.initState();
    SecureStorage.getInstance().readSecureData(USER_KEY).then((value) {
      setState(() {
        _user = User.deserialize(value!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      padding: const EdgeInsets.only(top: 15.0),
      // margin: const EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "MENU",
            style:
                GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: Colors.grey,
          ),
          menuItem(1, "Chat", Icons.chat_outlined, true),
          if (_user.isSuperuser!)
            menuItem(2, "Metrics", FontAwesomeIcons.chartLine, true),
          if (_user.isSuperuser!)
            menuItem(3, "Feedback", Icons.feedback_outlined, true),
          menuItem(4, "Logout", Icons.logout_outlined, true),
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: bgColor,
      child: InkWell(
          onTap: () {
            navigate(id);
          },
          child: ListTile(
            leading: Icon(
              icon,
              size: 20,
              color: selected ? Colors.blue : Colors.grey.shade600,
            ),
            title: Text(
              title,
              style: GoogleFonts.roboto(
                  color: selected ? Colors.blue : Colors.grey, fontSize: 16),
            ),
          )),
    );
  }

  void navigate(int id) {
    switch (id) {
      //chat tab
      case 1:
        Navigator.pushReplacement(
            widget.context,
            MaterialPageRoute(
              builder: (context) => const ChatScreen(),
            ));
        break;
      //metric tab
      case 2:
        Navigator.of(widget.context).pop();
        Navigator.of(widget.context).push(MaterialPageRoute(
          builder: (context) => const MetricScreen(),
        ));
        break;
      //metric tab
      case 3:
        Navigator.of(widget.context).pop();
        Navigator.of(widget.context).push(MaterialPageRoute(
          builder: (context) => const FeedbackScreen(),
        ));
        break;
      //logout tab
      case 4:
        Navigator.of(widget.context).pop();
        showDialog(
          context: widget.context,
          builder: (context) {
            return LogoutConfirmationDialog(
              onConfirm: logout,
              onCancel: () => Navigator.of(context).pop(),
            );
          },
        );
        break;
    }
  }

  void logout() {
    //clear local storage
    SecureStorage.getInstance().clearLocalData();
    Navigator.pushReplacement(
        widget.context,
        MaterialPageRoute(
          builder: (context) => const AuthScreen(),
        ));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Center(
      child: Text("Log out success"),
    )));
  }
}
