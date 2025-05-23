import 'package:lawly/features/templates/domain/entity/template_entity.dart';

class TotalTemplatesEntity {
  final int total;
  final List<TemplateEntity> templates;

  TotalTemplatesEntity({
    required this.total,
    required this.templates,
  });
}
