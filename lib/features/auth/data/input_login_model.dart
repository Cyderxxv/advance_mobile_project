class InputLoginModel {
  final String email;
  final String password;

  InputLoginModel({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}
