class ChatResponseModel {
  final String? message;
  final int? remainingUsage;

  ChatResponseModel({
    this.message,
    this.remainingUsage,
  });

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatResponseModel(
      message: json['message'],
      remainingUsage: json['remainingUsage'],
    );
  }
}
