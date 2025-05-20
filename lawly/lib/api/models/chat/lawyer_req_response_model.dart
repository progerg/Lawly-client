import 'package:json_annotation/json_annotation.dart';
import 'package:lawly/features/chat/domain/entity/lawyer_req_response_entity.dart';

part 'lawyer_req_response_model.g.dart';

@JsonSerializable()
class LawyerReqResponseModel extends LawyerReqResponseEntity {
  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'status')
  final LawyerReqResponseStatus status;

  LawyerReqResponseModel({
    required super.id,
    required this.status,
    required this.createdAt,
  }) : super(
          createdAt: createdAt,
          status: status,
        );

  factory LawyerReqResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LawyerReqResponseModelFromJson(json);
}

const _pending = 'pending';

const _processing = 'processing';

const _completed = 'completed';

enum LawyerReqResponseStatus {
  @JsonValue(_pending)
  started(_pending),

  @JsonValue(_completed)
  completed(_completed),

  @JsonValue(_processing)
  processing(_processing);

  final String value;

  const LawyerReqResponseStatus(this.value);
}
