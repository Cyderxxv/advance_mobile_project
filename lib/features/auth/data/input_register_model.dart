class InputRegisterModel {
  final String email;
  final String password;
  final String verificationCallbackUrl;

  InputRegisterModel({
    required this.email,
    required this.password,
    required this.verificationCallbackUrl,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'verification_callback_url': verificationCallbackUrl,
      };
}
