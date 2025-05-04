import 'package:dio/dio.dart';
import 'package:lawly/api/endpoints/doc_service/templates_endpoints.dart';
import 'package:lawly/api/models/templates/doc_model.dart';
import 'package:retrofit/retrofit.dart';

part 'templates_remote_data_source.g.dart';

@RestApi()
abstract class TemplatesRemoteDataSource {
  factory TemplatesRemoteDataSource(Dio dio, {String baseUrl}) =
      _TemplatesRemoteDataSource;

  @GET(TemplatesEndpoints.documents)
  Future<List<DocModel>> getDocuments();

  @GET(TemplatesEndpoints.documentStructureById)
  Future<DocModel> getDocumentStructure(
      {@Path('document_id') required int documentId});
}
