class ChatHistory {
  final int id;
  final String title;
  final String lastMessage;
  final String timestamp;
  final String sessionId;

  ChatHistory({
    required this.id,
    required this.title,
    required this.lastMessage,
    required this.timestamp,
    required this.sessionId,
  });

  factory ChatHistory.fromJson(Map<String, dynamic> json) {
    return ChatHistory(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      lastMessage:
          json['title'] ??
          'No messages yet', // Use title as fallback for lastMessage
      timestamp: _formatTimestamp(
        json['created_at'] ?? json['updated_at'] ?? '',
      ),
      sessionId: json['session_id'] ?? '',
    );
  }

  static String _formatTimestamp(String timestamp) {
    if (timestamp.isEmpty) return '';
    try {
      final date = DateTime.parse(timestamp);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return timestamp;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'lastMessage': lastMessage,
      'timestamp': timestamp,
      'session_id': sessionId,
    };
  }
}

class ChatHistoryResponse {
  final List<ChatHistory> chatHistory;

  ChatHistoryResponse({required this.chatHistory});

  factory ChatHistoryResponse.fromJson(dynamic json) {
    List<dynamic> data;

    // Handle both cases: direct array or object with 'data' field
    if (json is List<dynamic>) {
      data = json;
    } else if (json is Map<String, dynamic>) {
      data = json['data'] ?? [];
    } else {
      data = [];
    }

    final chatHistory = data.map((item) => ChatHistory.fromJson(item)).toList();
    return ChatHistoryResponse(chatHistory: chatHistory);
  }

  Map<String, dynamic> toJson() {
    return {'data': chatHistory.map((chat) => chat.toJson()).toList()};
  }
}
