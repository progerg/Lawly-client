import 'package:dio/dio.dart';
import 'package:lawly/api/endpoints/documents_endpoints.dart';
import 'package:lawly/api/models/documents/privacy_policy_model.dart';
import 'package:retrofit/retrofit.dart';

part 'documents_remote_data_source.g.dart';

@RestApi()
abstract class DocumentsRemoteDataSource {
  factory DocumentsRemoteDataSource(Dio dio, {String baseUrl}) =
      _DocumentsRemoteDataSource;

  @GET(DocumentsEndpoints.privacyPolicy)
  Future<PrivacyPolicyModel> getPrivacyPolicy();
}
