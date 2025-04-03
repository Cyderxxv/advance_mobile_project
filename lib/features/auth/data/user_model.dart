class UserModel {
  final String accessToken;
  final String refreshToken;
  final String userId;

  UserModel({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
  });

  UserModel.fromJson(Map<String, dynamic> json)
    : accessToken = json['access_token'],
      refreshToken = json['refresh_token'],
      userId = json['user_id'];

  Map<String, dynamic> toJson() => {
    'access_token': accessToken,
    'refresh_token': refreshToken,
    'user_id': userId,
  };
}