import 'package:dio/dio.dart';
import 'package:tracking_app/data/domain/user.dart';
import 'package:tracking_app/data/repository/secure_local_storage.dart';

class AuthService{
  final String authUrl = "/api/v1/auth";
  final dio = Dio();

  AuthService({required String baseUrl}){
    dio.options.baseUrl = baseUrl;
  }

  Future<void> signUp(User user) async {
    var response = await dio.post("$authUrl/register", data: user.toJson());
  }

  Future<User> logIn(String email, String password) async {
    var response = await dio.post("$authUrl/authenticate", data: {
      "email": email,
      "password": password,
    });

    SecureLocalStorage().writeData(PrefsConstants.secureRefreshToken, response.data['refresh_token']);
    SecureLocalStorage().writeData(PrefsConstants.secureKeyIdToken, response.data['access_token']);

    print(response);

    return User.fromJson(response.data);
  }

  Future<String> getUserToken() async {
    String? token = await SecureLocalStorage().readData(PrefsConstants.secureRefreshToken);
    print("refresh token is $token");
    dio.options.headers["Token"] = "Bearer $token";

    var response = await dio.post(
      "$authUrl/refreshtoken",
    );

    SecureLocalStorage().writeData(PrefsConstants.secureKeyIdToken, response.data["accessToken"]);
    return response.data["accessToken"];
  }
}
