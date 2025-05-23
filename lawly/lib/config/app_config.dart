import 'package:lawly/config/service/device_info_service.dart';

class AppConfig {
  /// AppMetrica API Key: 68b47b9c-dbe4-4072-848e-ab1aea423ce1

  final String userServiceUrl;

  final String docServiceUrl;

  final String chatServiceUrl;

  final String webSockerUrl;

  final String apiSecretKey;

  final String? proxyUrl;

  final String appMetricaKey = '68b47b9c-dbe4-4072-848e-ab1aea423ce1';

  AppConfig({
    required this.userServiceUrl,
    required this.docServiceUrl,
    required this.chatServiceUrl,
    required this.webSockerUrl,
    this.proxyUrl,
  }) : apiSecretKey = '';

  AppConfig copyWith({
    String? userServiceUrl,
    String? docServiceUrl,
    String? chatServiceUrl,
    String? webSockerUrl,
    String? proxyUrl,
  }) =>
      AppConfig(
        userServiceUrl: userServiceUrl ?? this.userServiceUrl,
        docServiceUrl: docServiceUrl ?? this.docServiceUrl,
        chatServiceUrl: chatServiceUrl ?? this.chatServiceUrl,
        webSockerUrl: webSockerUrl ?? this.webSockerUrl,
        proxyUrl: proxyUrl ?? this.proxyUrl,
      );

  String get deviceId => DeviceInfoService.instance.deviceId;
  String get deviceOs => DeviceInfoService.instance.deviceOs;
  String get deviceName => DeviceInfoService.instance.deviceName;
}
