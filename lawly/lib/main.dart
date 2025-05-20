import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:lawly/config/app_config.dart';
import 'package:lawly/config/base_urls.dart';
import 'package:lawly/config/enviroment/enviroment.dart';
import 'package:lawly/config/service/device_info_service.dart';
import 'package:lawly/runner.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await DeviceInfoService.instance.init();

  Environment.init(
    config: AppConfig(
      userServiceUrl: BaseUrls.userServiceProd,
      docServiceUrl: BaseUrls.docServiceProd,
      chatServiceUrl: BaseUrls.chatServiceProd,
    ),
  );

  run();
}
