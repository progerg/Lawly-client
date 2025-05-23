import 'package:json_annotation/json_annotation.dart';
import 'package:lawly/features/chat/domain/entity/lawyer_req_create_entity.dart';

part 'lawyer_req_create_model.g.dart';

@JsonSerializable()
class LawyerReqCreateModel extends LawyerReqCreateEntity {
  @JsonKey(name: 'document_bytes')
  final List<int>? documentBytes;

  LawyerReqCreateModel({
    required super.description,
    this.documentBytes,
  }) : super(documentBytes: documentBytes);

  Map<String, dynamic> toJson() => _$LawyerReqCreateModelToJson(this);

  factory LawyerReqCreateModel.fromEntity(
    LawyerReqCreateEntity entity,
  ) {
    return LawyerReqCreateModel(
      description: entity.description,
      documentBytes: entity.documentBytes,
    );
  }
}
