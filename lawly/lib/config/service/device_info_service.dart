import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoService {
  static DeviceInfoService? _instance;

  String deviceId = '';
  String deviceOs = '';
  String deviceName = '';

  DeviceInfoService._();

  static DeviceInfoService get instance {
    _instance ??= DeviceInfoService._();
    return _instance!;
  }

  Future<void> init() async {
    final deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
        deviceOs = 'Android ${androidInfo.version.release}';
        deviceName =
            '${androidInfo.manufacturer} ${androidInfo.brand} ${androidInfo.model}';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? 'unknown';
        deviceOs = '${iosInfo.systemName} ${iosInfo.systemVersion}';
        deviceName = '${iosInfo.name} ${iosInfo.model}';
      }
      log('Device info initialized: $deviceName, $deviceOs, ID: $deviceId');
    } catch (e) {
      log('Error getting device info: $e');
    }
  }
}
