import 'package:lawly/api/data_sources/remote/doc_service/generate_remote_data_source.dart';
import 'package:lawly/api/data_sources/remote/doc_service/templates_remote_data_source.dart';
import 'package:lawly/api/models/templates/document_creation_model.dart';
import 'package:lawly/api/models/templates/generate_req_model.dart';
import 'package:lawly/features/templates/domain/entity/document_creation_entity.dart';
import 'package:lawly/features/templates/domain/entity/generate_req_entity.dart';
import 'package:lawly/features/templates/domain/entity/improve_text_entity.dart';
import 'package:lawly/features/templates/domain/entity/template_download_entity.dart';
import 'package:lawly/features/templates/domain/entity/template_entity.dart';
import 'package:lawly/features/templates/domain/entity/total_templates_entity.dart';

const String contentType =
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document';

abstract class ITemplateRepository {
  Future<TotalTemplatesEntity> getTotalTemplates(
      {String? query, int? limit, required int offset});

  Future<TemplateEntity> getTemplateById({required int templateId});

  Future<TemplateDownloadEntity> getTemplateDownloadById(
      {required int templateId});

  Future<DocumentCreationEntity> createDocument({
    required int templateId,
    required String customName,
  });

  Future<DocumentCreationEntity> updateDocument({
    required int documentCreationId,
    required DocumentCreationStatus status,
    String? errorMessage,
  });

  Future<List<int>> downloadTemplate({
    required GenerateReqEntity generateReqEntity,
  });

  Future<List<int>> downloadEmptyTemplate({
    required int templateId,
  });

  Future<List<int>> customTemplate({
    String? description,
  });

  Future<ImproveTextEntity> improveText({
    required String text,
  });
}

class TemplateRepository implements ITemplateRepository {
  static const int defaultLimit = 10; // Default limit for templates

  final TemplatesRemoteDataSource _templatesRemoteDataSource;
  final GenerateRemoteDataSource _generateRemoteDataSource;

  TemplateRepository({
    required TemplatesRemoteDataSource templatesRemoteDataSource,
    required GenerateRemoteDataSource generateRemoteDataSource,
  })  : _templatesRemoteDataSource = templatesRemoteDataSource,
        _generateRemoteDataSource = generateRemoteDataSource;

  @override
  Future<TotalTemplatesEntity> getTotalTemplates(
      {String? query, int? limit, required int offset}) async {
    return await _templatesRemoteDataSource.getTotalTemplates(
      query: query,
      limit: limit ?? defaultLimit,
      offset: offset,
    );
  }

  @override
  Future<TemplateEntity> getTemplateById({
    required int templateId,
  }) async {
    final res = await _templatesRemoteDataSource.getTemplateById(
      templateId: templateId,
    );
    return res;
  }

  @override
  Future<TemplateDownloadEntity> getTemplateDownloadById({
    required int templateId,
  }) async {
    return await _templatesRemoteDataSource.getTemplateDownloadById(
      templateId: templateId,
    );
  }

  @override
  Future<DocumentCreationEntity> createDocument({
    required int templateId,
    required String customName,
  }) async {
    return await _templatesRemoteDataSource.createDocument(
      templateId: templateId,
      customName: customName,
    );
  }

  @override
  Future<DocumentCreationEntity> updateDocument({
    required int documentCreationId,
    required DocumentCreationStatus status,
    String? errorMessage,
  }) async {
    return await _templatesRemoteDataSource.updateDocument(
      documentCreationId: documentCreationId,
      status: status.value,
      errorMessage: errorMessage,
    );
  }

  @override
  Future<List<int>> downloadTemplate({
    required GenerateReqEntity generateReqEntity,
  }) async {
    return await _generateRemoteDataSource.downloadTemplate(
      generateReqModel: GenerateReqModel.fromEntity(generateReqEntity),
      contentType: contentType,
    );
  }

  @override
  Future<List<int>> downloadEmptyTemplate({
    required int templateId,
  }) async {
    return await _templatesRemoteDataSource.downloadEmptyTemplate(
      templateId: templateId,
      contentType: contentType,
    );
  }

  @override
  Future<List<int>> customTemplate({
    String? description,
  }) async {
    return await _templatesRemoteDataSource.customTemplate(
      description: description,
      contentType: contentType,
    );
  }

  @override
  Future<ImproveTextEntity> improveText({
    required String text,
  }) async {
    return await _templatesRemoteDataSource.improveText(
      text: text,
    );
  }
}
