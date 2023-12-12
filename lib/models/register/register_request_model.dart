class RegisterRequestModel {
  RegisterRequestModel({
    required this.nama,
    required this.username,
    required this.password,
  });

  final String? nama;
  final String? username;
  final String? password;

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    return RegisterRequestModel(
      nama: json["nama"],
      username: json["username"],
      password: json["password"],
    );
  }

  Map<String, dynamic> toJson() => {
        "nama": nama,
        "username": username,
        "password": password,
      };
}
