import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wwjd_chat/components/feedback_list_view.dart';
import 'package:wwjd_chat/data_source/local/secure_storage.dart';
import 'package:wwjd_chat/model/feedback.dart';
import 'package:wwjd_chat/model/feedback_master.dart';
import 'package:wwjd_chat/util/constant.dart';

import '../../data_source/remote/api_service.dart';
import '../../util/color.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  late final ApiService _apiService;
  late final String _accessToken;
  FeedbackMaster _feedbackMaster = const FeedbackMaster([], 0);
  bool _isLoading = false;

  @override
  void initState() {
    _apiService = ApiService();
    SecureStorage.getInstance().readSecureData(ACCESS_TOKEN_KEY).then((value) {
      _accessToken = value!;
      setState(() => _isLoading = true);
      _apiService.getAllFeedbacks(_accessToken).then((response) {
        if (response.statusCode == 200) {
          setState(() {
            _feedbackMaster = parseFeedback(jsonDecode(response.body));
            _isLoading = false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              content: Text(response.reasonPhrase.toString())));
          setState(() => _isLoading = false);
        }
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: _buildAppBar(),
      body: _isLoading
          ? const Center(
              child: CupertinoActivityIndicator(color: primaryColor,radius: 30,),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          height: 100,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/WWJD-dark.png"))),
                        ),
                        Row(
                          children: [
                            Text(
                              "Total Users: ",
                              style: GoogleFonts.roboto(
                                  color: Colors.grey.shade700),
                            ),
                            Text(_feedbackMaster.userCount.toString())
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "FEEDBACKS",
                              style: GoogleFonts.roboto(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "WWJD / feedbacks",
                              style: GoogleFonts.roboto(
                                  color: Colors.grey.shade700),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  FeedbackListView(feedbackList: _feedbackMaster.feedbackList),
                ],
              ),
            ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      foregroundColor: Colors.black87,
      backgroundColor: Colors.white,
      systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor:Colors.white70,
          statusBarIconBrightness: Brightness.dark),
      elevation: 0,
      title: Row(
        children: [
          Expanded(
            child: Text(
              "Feedback",
              style: GoogleFonts.roboto(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }

  FeedbackMaster parseFeedback(String jsonStr) {
    final parsed = jsonDecode(jsonStr) as Map<String, dynamic>;
    var parsedList = parsed['feedback_list'] as List<dynamic>;
    List<FeedbackModel> list =
        parsedList.map((json) => FeedbackModel.fromJson(json)).toList();
    FeedbackMaster master = FeedbackMaster(list, parsed['user_count']);
    return master;
  }
}
