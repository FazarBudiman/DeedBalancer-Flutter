import 'dart:convert';

LoginResponseModel loginResponseModel(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

class LoginResponseModel {
  LoginResponseModel({
    required this.message,
    required this.token,
  });

  final String? message;
  final String? token;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      message: json["message"],
      token: json["token"],
    );
  }

  Map<String, dynamic> toJson() => {
        "message": message,
        "token": token,
      };
}
