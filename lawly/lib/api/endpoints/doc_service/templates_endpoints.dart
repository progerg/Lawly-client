class TemplatesEndpoints {
  static const String _baseUrl = '/api/v1';

  static const String documents = '$_baseUrl/documents';

  static const String documentStructureById =
      '$_baseUrl/document-structure/{document_id}';
}
