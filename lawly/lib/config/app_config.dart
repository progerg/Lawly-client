import 'package:lawly/config/service/device_info_service.dart';

class AppConfig {
  final String url;

  final String apiSecretKey;

  final String? proxyUrl;

  AppConfig({
    required this.url,
    this.proxyUrl,
  }) : apiSecretKey = '';

  AppConfig copyWith({
    String? url,
    String? proxyUrl,
  }) =>
      AppConfig(
        url: url ?? this.url,
        proxyUrl: proxyUrl ?? this.proxyUrl,
      );

  String get deviceId => DeviceInfoService.instance.deviceId;
  String get deviceOs => DeviceInfoService.instance.deviceOs;
  String get deviceName => DeviceInfoService.instance.deviceName;
}
