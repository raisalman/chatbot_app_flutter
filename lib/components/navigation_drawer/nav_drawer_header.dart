import 'package:flutter/material.dart';
import 'package:wwjd_chat/util/color.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data_source/local/secure_storage.dart';
import '../../model/user.dart';
import '../../util/constant.dart';

class NavDrawerHeader extends StatefulWidget {
  const NavDrawerHeader({super.key});

  @override
  State<NavDrawerHeader> createState() => _NavDrawerHeaderState();
}

class _NavDrawerHeaderState extends State<NavDrawerHeader> {

  User _user=User();

  @override
  void initState() {
    SecureStorage.getInstance().readSecureData(USER_KEY).then((value){
      setState(() {
        _user=User.deserialize(value!);
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 70,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage("assets/images/WWJD-light.png")
              )
            ),
          ),
          Text("${_user.firstName} ${_user.lastName}",style: GoogleFonts.roboto(fontSize: 20,color: Colors.white),),
          Text("${_user.email}",style: GoogleFonts.roboto(fontSize: 14,color: Colors.white),)
        ],
      ),
    );
  }
}
