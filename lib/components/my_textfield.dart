import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextFormField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final Function(String) validator;
  final Function(String) onSave;
  final TextInputType keyboardType;
  const MyTextFormField({
    super.key,
    required this.hintText,
    required this.obscureText, required this.validator, required this.onSave, required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        key: key,
        obscureText: obscureText,
        cursorColor: Colors.black,
        validator: (value) => validator(value!),
        onSaved: (newValue) => onSave(newValue!),
        textInputAction: TextInputAction.next,
        style: GoogleFonts.roboto(color: Colors.black),
        keyboardType: keyboardType,
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: hintText,
            hintStyle: GoogleFonts.roboto(color: Colors.grey[500])),
      ),
    );
  }
}