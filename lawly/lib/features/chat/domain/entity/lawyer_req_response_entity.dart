import 'package:lawly/api/models/chat/lawyer_req_response_model.dart';

class LawyerReqResponseEntity {
  final int id;
  final LawyerReqResponseStatus status;
  final String createdAt;

  LawyerReqResponseEntity({
    required this.id,
    required this.status,
    required this.createdAt,
  });
}
