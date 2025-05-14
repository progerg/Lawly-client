class TemplatesEndpoints {
  static const String _baseUrl = '/api/v1';

  static const String documents = '$_baseUrl/documents/documents';

  static const String documentStructureById =
      '$_baseUrl/documents/document-structure/{document_id}';

  static const String templates = '$_baseUrl/templates/templates';

  static const String templateById = '$_baseUrl/templates/{template_id}';

  static const String templateDownloadById =
      '$_baseUrl/templates/{template_id}/download';

  static const String documentCreate = '$_baseUrl/documents/create';

  static const String documentUpdate =
      '$_baseUrl/documents/update/{document_creation_id}';

  static const String downloadEmptyTemplate =
      '$_baseUrl/templates/download-empty-template';

  static const String generate = '$_baseUrl/documents/generate';
}
