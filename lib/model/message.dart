
class Chat {
  final String type;
  final String message;
  final String createdAt;

  Chat(this.type, this.message, this.createdAt);

  Chat.fromJson(Map<String, dynamic> json)
      : type = json['type'] as String,
        message = json['message'] as String,
        createdAt = json['createdAt'] as String;

  Map<String, dynamic> toJson() => {
    'type': type,
    'message': message,
    'createdAt': createdAt,
  };

}
