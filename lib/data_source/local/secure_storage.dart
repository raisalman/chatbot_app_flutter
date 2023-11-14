import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static final _instance = SecureStorage._();

  static SecureStorage getInstance() {
    return _instance;
  }

  SecureStorage._();

  //write data in secure storage
  writeSecureData(String myKey, String data) async =>
      await _storage.write(key: myKey, value: data);

  //read data from secure storage
  Future<String?> readSecureData(String myKey) async =>
      await _storage.read(key: myKey);

 //clear local storage
  void clearLocalData() async =>
      await _storage.deleteAll();
}
