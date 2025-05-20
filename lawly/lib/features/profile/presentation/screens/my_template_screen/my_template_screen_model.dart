import 'package:elementary/elementary.dart';
import 'package:lawly/features/templates/service/template_service.dart';

class MyTemplateScreenModel extends ElementaryModel {
  final TemplateService templateService;

  MyTemplateScreenModel({
    required this.templateService,
  });
}
