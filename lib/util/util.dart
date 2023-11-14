import 'dart:io';

import 'package:http/http.dart' as http;

class Util {
 static Future<bool> isOnline() async {
    try {
      final url = Uri.parse('https://www.google.com/');
      var response = await http.head(url);
      return response.statusCode == 200 ? true : false;
    } on SocketException {
      return false;
    }
  }
}
