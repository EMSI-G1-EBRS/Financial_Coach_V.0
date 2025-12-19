class ChatMessage {
  final String text;
  final bool isUser;

  const ChatMessage({required this.text, required this.isUser});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    // Support plusieurs formats possibles côté backend
    final dynamic isUserDyn = json['isUser'] ?? json['is_user'] ??
        (json['role'] != null ? json['role'] == 'user' : null);
    return ChatMessage(
      text: (json['text'] ?? json['message'] ?? json['content'] ?? '').toString(),
      isUser: (isUserDyn is bool)
          ? isUserDyn
          : (isUserDyn is String)
              ? (isUserDyn.toLowerCase() == 'true')
              : (isUserDyn ?? false),
    );
  }

  Map<String, dynamic> toJson() => {
        'text': text,
        'isUser': isUser,
      };
}
