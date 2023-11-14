import 'package:http/http.dart' as http;

import '../../model/message.dart';

 abstract class ApiRequests {
  //login request
  Future<http.Response> sendLoginRequest(String email, String password);

  // register a new user
  Future<http.Response> sendRegisterRequest(
      String email, String pass, String fName, String lName, String phone);

  //get response for user prompt from server
  Future<http.Response> chatRequest(
      int? userId, List<Chat> messages, String token);

  //get previous message of the user
  Future<http.Response> getChatsByUser(String userId, String token);

  Future<http.Response> postUserFeedback(
      int? userId, String comment, String accessToken);

  // get all user feedbacks
  Future<http.Response> getAllFeedbacks(String accessToken);

  // get active users
  Future<http.Response> getActiveUsers(String accessToken);

  //clear chat
  Future<http.Response> clearChat(String accessToken);
}
