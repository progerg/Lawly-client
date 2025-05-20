import 'package:lawly/config/service/device_info_service.dart';

class AppConfig {
  final String userServiceUrl;

  final String docServiceUrl;

  final String chatServiceUrl;

  final String apiSecretKey;

  final String? proxyUrl;

  AppConfig({
    required this.userServiceUrl,
    required this.docServiceUrl,
    required this.chatServiceUrl,
    this.proxyUrl,
  }) : apiSecretKey = '';

  AppConfig copyWith({
    String? userServiceUrl,
    String? docServiceUrl,
    String? chatServiceUrl,
    String? proxyUrl,
  }) =>
      AppConfig(
        userServiceUrl: userServiceUrl ?? this.userServiceUrl,
        docServiceUrl: docServiceUrl ?? this.docServiceUrl,
        chatServiceUrl: chatServiceUrl ?? this.chatServiceUrl,
        proxyUrl: proxyUrl ?? this.proxyUrl,
      );

  String get deviceId => DeviceInfoService.instance.deviceId;
  String get deviceOs => DeviceInfoService.instance.deviceOs;
  String get deviceName => DeviceInfoService.instance.deviceName;
}
