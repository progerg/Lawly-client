import 'package:lawly/config/app_config.dart';
import 'package:lawly/config/enviroment/enviroment.dart';

abstract class BaseUrls {
  static String get prod => '';

  static String get currentBaseUrl =>
      Enviroment<AppConfig>.instance().config.url;
}
