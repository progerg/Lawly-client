import 'package:lawly/config/app_config.dart';
import 'package:lawly/config/enviroment/enviroment.dart';

abstract class BaseUrls {
  static String get userServiceProd => 'https://user-service.lawly.ru';

  static String get docServiceProd => 'https://doc-service.lawly.ru';

  static String get currentBaseUrl =>
      Environment<AppConfig>.instance().config.userServiceUrl;
}
