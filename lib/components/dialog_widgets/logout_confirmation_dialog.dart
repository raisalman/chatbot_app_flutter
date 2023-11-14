import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wwjd_chat/util/color.dart';
import 'package:google_fonts/google_fonts.dart';

import '../dialog_button.dart';

class LogoutConfirmationDialog extends StatelessWidget {

  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const LogoutConfirmationDialog({super.key, required this.onConfirm, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:  Text("Logout Confirmation",style: GoogleFonts.roboto(fontSize: 18,fontWeight: FontWeight.w400),),
      backgroundColor: Colors.grey.shade100,
      // contentPadding: const EdgeInsets.all(24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //title text
          Text("Are you sure you want to Logout..",style: GoogleFonts.roboto(fontSize: 14),),
          const SizedBox(height: 24.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // save button
              MyDialogButton(text: "Cancel", onPressed: onCancel, color:Colors.grey.shade200,textColor: Colors.black87),
              const SizedBox(width: 16.0,),
              MyDialogButton(text: "Yes", onPressed: onConfirm, color: primaryColor,textColor: Colors.white),
            ],
          )
        ],
      ),
    );
  }
}
