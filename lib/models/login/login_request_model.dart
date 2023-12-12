class LoginRequestModel {
  LoginRequestModel({
    required this.username,
    required this.password,
  });

  final String? username;
  final String? password;

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) {
    return LoginRequestModel(
      username: json["username"],
      password: json["password"],
    );
  }

  Map<String, String> toJson() => {
        "username": username!,
        "password": password!,
      };
}
