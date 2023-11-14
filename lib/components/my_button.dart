import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wwjd_chat/util/color.dart';
import 'package:google_fonts/google_fonts.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final bool isLoading;

  const MyButton(
      {super.key,
      required this.onTap,
      required this.text,
      required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 25),
        child: MaterialButton(
          height: 60,
          minWidth: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 5),
          color: primaryColor,
          disabledColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          onPressed: isLoading ? null : onTap,
          child: isLoading
              ? const Center(child: CircularProgressIndicator(color: primaryColor,))
              : Center(
                child: Text(
                    text,
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
              ),
        ));
  }
}
