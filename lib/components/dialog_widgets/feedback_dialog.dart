import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../dialog_button.dart';

class FeedBackDialog extends StatelessWidget {

  final dynamic controller;
  final VoidCallback onSave;

  const FeedBackDialog({super.key, required this.onSave, this.controller});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor:Colors.grey.shade300,
      contentPadding: const EdgeInsets.all(24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //title text
          Text("Please Provide your Feedback.",style: GoogleFonts.roboto(color: Colors.black87,fontSize: 18,fontWeight: FontWeight.w600),),
          const SizedBox(
            height: 12.0,
          ),
          Text("WWJDchat is built by Christians, for Christians. We need your help to make a better product for you!",style: GoogleFonts.roboto(color: Colors.grey.shade600,fontSize: 14,fontWeight: FontWeight.normal),),
          const SizedBox(
            height: 12.0,
          ),
          Container(color: Colors.grey.shade500,height: 1.5,width: MediaQuery.of(context).size.width,),
          const SizedBox(
            height: 16.0,
          ),
          // task name input field
          TextField(
            controller:controller ,
            maxLines: 3,
            cursorColor: Colors.black38,
            style: GoogleFonts.roboto(color: Colors.black),
            decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                fillColor: Colors.grey.shade200,
                filled: true,
                hintText: "Enter your feedback",
                hintStyle: GoogleFonts.roboto(color: Colors.grey[500])),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // save button
              MyDialogButton(text: "Submit Feedback", onPressed: onSave, color: Colors.blue,textColor: Colors.white,)
            ],
          )
        ],
      ),
    );
  }
}
