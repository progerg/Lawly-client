import 'package:dio/dio.dart';
import 'package:lawly/api/endpoints/doc_service/templates_endpoints.dart';
import 'package:lawly/api/models/templates/doc_model.dart';
import 'package:lawly/api/models/templates/document_creation_model.dart';
import 'package:lawly/api/models/templates/improve_text_model.dart';
import 'package:lawly/api/models/templates/template_download_model.dart';
import 'package:lawly/api/models/templates/template_model.dart';
import 'package:lawly/api/models/templates/total_templates_model.dart';
import 'package:retrofit/retrofit.dart';

part 'templates_remote_data_source.g.dart';

@RestApi()
abstract class TemplatesRemoteDataSource {
  factory TemplatesRemoteDataSource(Dio dio, {String baseUrl}) =
      _TemplatesRemoteDataSource;

  @GET(TemplatesEndpoints.documents)
  Future<List<DocModel>> getDocuments();

  @GET(TemplatesEndpoints.documentStructureById)
  Future<DocModel> getDocumentStructure({
    @Path('document_id') required int documentId,
  });

  @GET(TemplatesEndpoints.templates)
  Future<TotalTemplatesModel> getTotalTemplates({
    @Query('search') String? query,
    @Query('limit') required int limit,
    @Query('offset') required int offset,
  });

  @GET(TemplatesEndpoints.templateById)
  Future<TemplateModel> getTemplateById({
    @Path('template_id') required int templateId,
  });

  @GET(TemplatesEndpoints.templateDownloadById)
  Future<TemplateDownloadModel> getTemplateDownloadById({
    @Path('template_id') required int templateId,
  });

  @POST(TemplatesEndpoints.documentCreate)
  Future<DocumentCreationModel> createDocument({
    @Field('template_id') required int templateId,
    @Field('custom_name') required String customName,
  });

  @PUT(TemplatesEndpoints.documentUpdate)
  Future<DocumentCreationModel> updateDocument({
    @Path('document_creation_id') required int documentCreationId,
    @Field('status') required String status,
    @Field('error_message') String? errorMessage,
  });

  @POST(TemplatesEndpoints.downloadEmptyTemplate)
  @DioResponseType(ResponseType.bytes)
  Future<List<int>> downloadEmptyTemplate({
    @Field('template_id') required int templateId,
    @Header('Accept') required String contentType,
  });

  @POST(TemplatesEndpoints.customTemplate)
  @DioResponseType(ResponseType.bytes)
  Future<List<int>> customTemplate({
    @Field('description') String? description,
    @Header('Accept') required String contentType,
  });

  @POST(TemplatesEndpoints.improveText)
  Future<ImproveTextModel> improveText({
    @Field('text') required String text,
  });
}
