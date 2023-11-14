import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wwjd_chat/data_source/remote/api_requests.dart';
import 'package:wwjd_chat/util/constant.dart';

import '../../model/message.dart';

class ApiService implements ApiRequests {
  final String _baseUrl = "https://api.wwjdchat.com/";

  //login request
  @override
  Future<http.Response> sendLoginRequest(String email, String password) async {
    return await http.post(Uri.parse("${_baseUrl}auth/login/"), body: {
      "username": email,
      "password": password
    }).timeout(const Duration(seconds: httpRequestTimeout));
  }

  // register a new user
  @override
  Future<http.Response> sendRegisterRequest(String email, String pass,
      String fName, String lName, String phone) async {
    return await http.post(Uri.parse("${_baseUrl}auth/register/"), body: {
      "email": email,
      "first_name": fName,
      "last_name": lName,
      "phone": phone,
      "password": pass
    }).timeout(const Duration(seconds: httpRequestTimeout));
  }

  //get response for user prompt from server
  @override
  Future<http.Response> chatRequest(
      int? userId, List<Chat> messages, String token) async {
    return await http
        .post(
          Uri.parse("${_baseUrl}api/chat_request/"),
          headers: {
            "Authorization": "Bearer $token",
            'Content-type': 'application/json',
          },
          body: jsonEncode({"user_id": userId, "chat_list": messages}),
        )
        .timeout(const Duration(seconds: httpRequestTimeout));
  }

  //get previous message of the user
  @override
  Future<http.Response> getChatsByUser(String userId, String token) async {
    return await http.post(
      Uri.parse("${_baseUrl}api/chats_by_user/"),
      headers: {
        "Authorization": "Bearer $token",
      },
      body: {
        "user_id": userId,
      },
    ).timeout(const Duration(seconds: httpRequestTimeout));
  }

  // post user feedback
  @override
  Future<http.Response> postUserFeedback(
      int? userId, String comment, String accessToken) async {
    return await http.post(Uri.parse("${_baseUrl}api/userfeedback/"), headers: {
      "Authorization": 'Bearer $accessToken'
    }, body: {
      "user": userId,
      'comment': comment
    }).timeout(const Duration(seconds: httpRequestTimeout));
  }

  // get all user feedbacks
  @override
  Future<http.Response> getAllFeedbacks(String accessToken) async {
    return await http.get(Uri.parse("${_baseUrl}api/get_feedbacks/"), headers: {
      "Authorization": 'Bearer $accessToken'
    }).timeout(const Duration(seconds: httpRequestTimeout));
  }

  // get active users
  @override
  Future<http.Response> getActiveUsers(String accessToken) async {
    return await http.get(Uri.parse("${_baseUrl}api/active_users/"), headers: {
      "Authorization": 'Bearer $accessToken'
    }).timeout(const Duration(seconds: httpRequestTimeout));
  }

  //clear chat
  @override
  Future<http.Response> clearChat(String accessToken) async {
    return await http.delete(Uri.parse("${_baseUrl}api/clear_chat/"), headers: {
      "Authorization": 'Bearer $accessToken'
    }).timeout(const Duration(seconds: httpRequestTimeout));
  }
}
