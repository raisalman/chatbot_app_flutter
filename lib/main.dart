import 'package:flutter/material.dart';
import 'package:wwjd_chat/components/feedback_list_view.dart';
import 'package:wwjd_chat/screens/auth/auth_screen.dart';
import 'package:wwjd_chat/screens/chat/chat_screen.dart';
import 'package:wwjd_chat/screens/feedback/feedback_screen.dart';
import 'package:wwjd_chat/util/color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: primaryColor,
      ),
      home: const AuthScreen(),
    );
  }
}