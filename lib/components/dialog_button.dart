import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyDialogButton extends StatelessWidget {

  final String text;
  VoidCallback onPressed;
  final Color color;
  Color? textColor=Colors.white;
  MyDialogButton({
    super.key,
    required this.text,
    required this.onPressed, required this.color,this.textColor,

  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Text(text,style:GoogleFonts.roboto(fontSize: 14,color: textColor),),
    );
  }
}
