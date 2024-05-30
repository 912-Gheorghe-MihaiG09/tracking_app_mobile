import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureLocalStorage {
  final _secureStorage = const FlutterSecureStorage();

  Future<void> writeData(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> readData(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> deleteData(String key) async {
    await _secureStorage.delete(key: key);
  }

  Future<bool> containsKey(String key) async {
    var containsKey = await _secureStorage.containsKey(key: key);
    return containsKey;
  }
}


class PrefsConstants {
  static const String secureKeyUser = 'userKey';
  static const String secureKeyIdToken = 'idToken';
  static const String secureRefreshToken = 'refreshToken';
}
