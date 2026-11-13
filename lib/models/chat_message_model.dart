class ChatMessageModel {
  final String id;
  final String message;
  final String sender; // 'user' or 'ai'
  final DateTime timestamp;
  final String? quickActionTag;

  ChatMessageModel({
    required this.id,
    required this.message,
    required this.sender,
    required this.timestamp,
    this.quickActionTag,
  });

  bool get isUser => sender == 'user';
  bool get isAi => sender == 'ai';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'sender': sender,
      'timestamp': timestamp.toIso8601String(),
      'quickActionTag': quickActionTag,
    };
  }

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String? ?? 'msg_1',
      message: json['message'] as String? ?? '',
      sender: json['sender'] as String? ?? 'ai',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
      quickActionTag: json['quickActionTag'] as String?,
    );
  }
}
