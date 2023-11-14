import 'dart:async';
import 'dart:convert';

import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wwjd_chat/data_source/local/secure_storage.dart';
import 'package:wwjd_chat/model/user.dart';
import 'package:wwjd_chat/util/color.dart';
import 'package:wwjd_chat/util/constant.dart';
import 'package:wwjd_chat/components/threedots.dart';

import '../../components/dialog_widgets/feedback_dialog.dart';
import '../../components/dialog_widgets/logout_confirmation_dialog.dart';
import '../../components/navigation_drawer/nav_drawer.dart';
import '../../data_source/remote/api_service.dart';
import '../../model/message.dart';
import '../auth/auth_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _userFeedbackController = TextEditingController();
  final TextEditingController _userPromptController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Chat> _messages = [];
  List<Chat> _filteredMessages = [];
  bool _isTyping = false;
  late final String _accessToken;
  late final User _user;
  late final ApiService _apiService;
  bool _isLoading = false;
  late final Timer? timer;

  @override
  void initState() {
    super.initState();

    //set timer for Feedback dialog
    timer = Timer.periodic(const Duration(minutes: 20), (timer) {
      showFeedbackDialog();
    });
    _apiService = ApiService();
    SecureStorage.getInstance()
        .readSecureData(USER_KEY)
        .then((value) => _user = User.deserialize(value!));
    SecureStorage.getInstance().readSecureData(ACCESS_TOKEN_KEY).then((value) {
      _accessToken = value!;
      setState(() => _isLoading = true);
      _apiService.getChatsByUser(_user.id.toString(), _accessToken).then((response) {
        if (response.statusCode == 200) {
          //parse chat messages
          _messages = parseChatMessages(jsonDecode(response.body));
          setState(() {
            _filteredMessages = _messages;
            _isLoading = false;
          });
        } else {
          Fluttertoast.showToast(msg: response.reasonPhrase.toString());
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _userFeedbackController.dispose();
    _userPromptController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: _buildAppBar(),
      drawer: NavDrawer(
        baseContext: context,
      ),
      body: _isLoading
          ? const Center(
              child: CupertinoActivityIndicator(
                color: primaryColor,
                radius: 30,
              ),
            )
          : Column(
              children: [
                // const SizedBox(
                //   height: 8,
                // ),
                Expanded(
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _filteredMessages.length,
                      shrinkWrap: true,
                      reverse: true,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: _isTyping && index == 0
                                ? Column(
                                    children: [
                                      BubbleNormal(
                                        text: _filteredMessages[0].message,
                                        isSender: true,
                                        color: _filteredMessages[index].type ==
                                                UserType.client.name
                                            ? Colors.blue.shade200
                                            : Colors.grey.shade200,
                                        textStyle: GoogleFonts.roboto(
                                            color:
                                                _filteredMessages[index].type ==
                                                        UserType.client.name
                                                    ? Colors.black87
                                                    : Colors.grey.shade800),
                                      ),
                                      const ThreeDots()
                                    ],
                                  )
                                : BubbleNormal(
                                    text: _filteredMessages[index].message,
                                    isSender: _filteredMessages[index].type ==
                                        UserType.client.name,
                                    color: _filteredMessages[index].type ==
                                            UserType.client.name
                                        ? Colors.blue.shade200
                                        : Colors.grey.shade200,
                                    textStyle: GoogleFonts.roboto(
                                        color: _filteredMessages[index].type ==
                                                UserType.client.name
                                            ? Colors.black87
                                            : Colors.grey.shade800,
                                        fontSize: 16),
                                  ));
                      }),
                ),
                _buildTextComposer(),
              ],
            ),
    );
  }

  //send request to server with user prompt and get response
  void _sendMessage() async {
    String msg = _userPromptController.text;
    _userPromptController.clear();
    try {
      if (msg.isNotEmpty) {
        setState(() {
          _messages.insert(
              0, Chat(UserType.client.name, msg, DateTime.now().toString()));
          _filteredMessages = _messages;
          _isTyping = true;
        });
        _scrollController.animateTo(0.0,
            duration: const Duration(seconds: 1), curve: Curves.easeOut);

        //api request for chat
        _apiService
            .chatRequest(_user.id, _messages.reversed.toList(), _accessToken)
            .then((response) {
          if (response.statusCode == 200) {
            Map<String, dynamic> responseJson = jsonDecode(response.body);
            String type = responseJson['type'];
            String message = responseJson['message'];
            setState(() {
              _isTyping = false;
              _messages.insert(
                  0, Chat(type, message, DateTime.now().toString()));
              _filteredMessages = _messages;
            });
          } else {
            setState(() => _isTyping = false);
            Fluttertoast.showToast(msg: response.reasonPhrase.toString());
          }
        });
      }
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Some error occurred, please try again!")));
    }
  }

  //app bar widget
  EasySearchBar _buildAppBar() {
    return EasySearchBar(
      foregroundColor: Colors.black87,
      backgroundColor: Colors.white,
      searchBackIconTheme: const IconThemeData(color: Colors.black87),
      searchHintText: "Search here",
      searchCursorColor: Colors.black87,
      showClearSearchIcon: true,
      searchTextStyle: const TextStyle(color: Colors.black87),
      searchBackgroundColor: Colors.white,
      searchClearIconTheme: const IconThemeData(color: Colors.black87),
      systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white70,
          statusBarIconBrightness: Brightness.dark),
      elevation: 0,
      title: Row(
        children: [
          Expanded(
            child: Text(
              "WWJDchat",
              style: GoogleFonts.roboto(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
      onSearch: (value) => filterChat(value),
    );
  }

  //filter chat with search bar value
  void filterChat(String value) {
    setState(() {
      _filteredMessages = _messages
          .where((element) =>
              element.message.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  void onMenuItemSelected(int index) {
    switch (index) {
      case 1:
        //clear chat
        _messages.clear();
        _filteredMessages.clear();
        setState(() => _isLoading = true);
        //clear chat
        _apiService.clearChat(_accessToken).then((response) {
          if (response.statusCode == 201) {
            //fetch user chat again
            _apiService.getChatsByUser(_user.id.toString(), _accessToken).then((response) {
              if (response.statusCode == 200) {
                //parse chat messages
                _messages = parseChatMessages(jsonDecode(response.body));
                setState(() {
                  _filteredMessages = _messages;
                  _isLoading = false;
                });
              } else {
                Fluttertoast.showToast(msg: response.reasonPhrase.toString());
              }
            });
          } else {
            setState(() => _isLoading = false);
            Fluttertoast.showToast(msg: response.reasonPhrase.toString());
          }
        });
        break;
      // case 2:
      //   //show logout dialog
      //   showLogoutDialog();
      //   break;
      case 3:
        showFeedbackDialog();
        break;
    }
  }

  //show feedback dialog for user comments
  void showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return FeedBackDialog(
          onSave: postUserFeedback,
          controller: _userFeedbackController,
        );
      },
    );
  }

  //send user feedback
  void postUserFeedback() {
    String comment = _userFeedbackController.text.toString();
    if (comment.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
              content: Text("Please enter your feedback",style: TextStyle(color: Colors.yellowAccent),)));
      return;
    }
    _userFeedbackController.clear();
    _apiService.postUserFeedback(_user.id, comment, _accessToken);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Thanks for your feedback",
          style: TextStyle(color: Colors.white),
        )));
    Navigator.of(context).pop();
  }

  //show logout confirmation dialog
  void showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return LogoutConfirmationDialog(
          onConfirm: logout,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  //logout bar
  void logout() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AuthScreen(),
        ));
    Fluttertoast.showToast(msg: "logout.");
  }

  //get user prompt widget
  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _userPromptController,
                cursorColor: Colors.black87,
                textCapitalization: TextCapitalization.sentences,
                style: GoogleFonts.roboto(color: Colors.black),
                onSubmitted: (value) {
                  _sendMessage();
                },
                textInputAction: TextInputAction.send,
                showCursor: true,
                decoration: InputDecoration.collapsed(
                    hintText: "Enter Message...",
                    hintStyle: GoogleFonts.roboto()),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.send_rounded,
                size: 30,
                color: Colors.black87,
              ),
              onPressed: () {
                _sendMessage();
              },
            ),
            PopupMenuButton<int>(
              onSelected: (value) {
                // Handle the selection of the menu item
                onMenuItemSelected(value);
              },
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry<int>>[
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Text('Clear chat'),
                  ),
                  // const PopupMenuItem<int>(
                  //   value: 2,
                  //   child: Text('Logout'),
                  // ),
                  const PopupMenuItem<int>(
                    value: 3,
                    child: Text('Feedback'),
                  ),
                ];
              },
            ),
          ],
        ),
      ),
    );
  }

  //parse chat messages json response to "List<Chat>" in reversed order
  List<Chat> parseChatMessages(String jsonStr) {
    final parsed = jsonDecode(jsonStr) as List<dynamic>;
    return parsed.reversed.map((json) => Chat.fromJson(json)).toList();
  }
}
