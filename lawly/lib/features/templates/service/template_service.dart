import 'package:lawly/api/models/templates/document_creation_model.dart';
import 'package:lawly/features/templates/domain/entity/document_creation_entity.dart';
import 'package:lawly/features/templates/domain/entity/generate_req_entity.dart';
import 'package:lawly/features/templates/domain/entity/improve_text_entity.dart';
import 'package:lawly/features/templates/domain/entity/template_download_entity.dart';
import 'package:lawly/features/templates/domain/entity/template_entity.dart';
import 'package:lawly/features/templates/domain/entity/total_templates_entity.dart';
import 'package:lawly/features/templates/repository/template_repository.dart';

class TemplateService {
  final TemplateRepository _templateRepository;
  TemplateService({required TemplateRepository templateRepository})
      : _templateRepository = templateRepository;

  Future<TotalTemplatesEntity> getTotalTemplates(
      {String? query, int? limit, required int offset}) async {
    return await _templateRepository.getTotalTemplates(
      query: query,
      limit: limit,
      offset: offset,
    );
  }

  Future<TemplateEntity> getTemplateById({
    required int templateId,
  }) async {
    return await _templateRepository.getTemplateById(
      templateId: templateId,
    );
  }

  Future<TemplateDownloadEntity> getTemplateDownloadById({
    required int templateId,
  }) async {
    return await _templateRepository.getTemplateDownloadById(
      templateId: templateId,
    );
  }

  Future<DocumentCreationEntity> createDocument({
    required int templateId,
    required String customName,
  }) async {
    return await _templateRepository.createDocument(
      templateId: templateId,
      customName: customName,
    );
  }

  Future<DocumentCreationEntity> updateDocument({
    required int documentCreationId,
    required DocumentCreationStatus status,
    String? errorMessage,
  }) async {
    return await _templateRepository.updateDocument(
      documentCreationId: documentCreationId,
      status: status,
      errorMessage: errorMessage,
    );
  }

  Future<List<int>> downloadTemplate({
    required GenerateReqEntity generateReqEntity,
  }) async {
    return await _templateRepository.downloadTemplate(
      generateReqEntity: generateReqEntity,
    );
  }

  Future<List<int>> downloadEmptyTemplate({
    required int templateId,
  }) async {
    return await _templateRepository.downloadEmptyTemplate(
      templateId: templateId,
    );
  }

  Future<List<int>> customTemplate({
    String? description,
  }) async {
    return await _templateRepository.customTemplate(
      description: description,
    );
  }

  Future<ImproveTextEntity> improveText({
    required String text,
  }) async {
    return await _templateRepository.improveText(
      text: text,
    );
  }
}
