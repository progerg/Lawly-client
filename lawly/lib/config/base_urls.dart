import 'package:lawly/config/app_config.dart';
import 'package:lawly/config/enviroment/enviroment.dart';

abstract class BaseUrls {
  static String get prod => 'https://user-service.lawly.ru';

  static String get currentBaseUrl =>
      Environment<AppConfig>.instance().config.url;
}
