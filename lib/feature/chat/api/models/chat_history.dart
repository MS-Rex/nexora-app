class ChatHistory {
  final String id;
  final String title;
  final String lastMessage;
  final String timestamp;

  ChatHistory({
    required this.id,
    required this.title,
    required this.lastMessage,
    required this.timestamp,
  });

  factory ChatHistory.fromJson(Map<String, dynamic> json) {
    return ChatHistory(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      lastMessage: json['lastMessage'] ?? '',
      timestamp: json['timestamp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'lastMessage': lastMessage,
      'timestamp': timestamp,
    };
  }
}

class ChatHistoryResponse {
  final List<ChatHistory> chatHistory;

  ChatHistoryResponse({required this.chatHistory});

  factory ChatHistoryResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> data = json['data'] ?? [];
    final chatHistory = data.map((item) => ChatHistory.fromJson(item)).toList();
    return ChatHistoryResponse(chatHistory: chatHistory);
  }

  Map<String, dynamic> toJson() {
    return {'data': chatHistory.map((chat) => chat.toJson()).toList()};
  }
}
