class ChatEndpoints {
  static const String _baseUrl = '/api/v1';

  static const String lawyerRequest = '$_baseUrl/chat/lawyer/requests';

  static const String messages = '$_baseUrl/chat/ai/messages';

  static const String lawyerMessages = '$_baseUrl/chat/lawyer/messages';

  static const String lawyerDocuments = '$_baseUrl/chat/lawyer/document';
}
