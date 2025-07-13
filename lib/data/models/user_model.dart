class UserModel {
  final String name;
  final String email;
  final String token;

  UserModel({
    required this.name,
    required this.email,
    required this.token,
  });

  /// لـ تسجيل الدخول (login)
  factory UserModel.fromLoginJson(Map<String, dynamic> json) {
    final user = json['user'];
    return UserModel(
      name: user['name'],
      email: user['email'],
      token: json['token'],
    );
  }

  /// لـ التسجيل (register)
  factory UserModel.fromRegisterJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      token: json['token'],
    );
  }
}




