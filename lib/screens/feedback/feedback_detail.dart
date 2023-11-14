import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wwjd_chat/model/feedback.dart';
import 'package:wwjd_chat/util/color.dart';

class FeedBackDetail extends StatelessWidget {
  final FeedbackModel feedbackModel;

  const FeedBackDetail({super.key, required this.feedbackModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Feedback Detail"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "User:",
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(feedbackModel.user, style: GoogleFonts.roboto(
                    color: Colors.black45,
                    fontWeight: FontWeight.w600,
                    fontSize: 16))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text("DateTime:", style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 18)),
                const SizedBox(
                  width: 10,
                ),
                Text("${feedbackModel.datetime}", style: GoogleFonts.roboto(
                    color: Colors.black45,
                    fontWeight: FontWeight.w600,
                    fontSize: 16))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("Comment:", style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 18)),
            const SizedBox(
              height: 10,
            ),
            Text(
              '" ${feedbackModel.comment} "', style: GoogleFonts.roboto(
                color: Colors.black45,
                fontWeight: FontWeight.w600,
                fontSize: 16,height: 1.5),textAlign: TextAlign.start,
            )
          ]),
        ),
      ),
    );
  }
}
