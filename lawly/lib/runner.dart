import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lawly/features/app/app.dart';
import 'package:lawly/features/app/di/app_scope.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> run() async {
  // Позже можно добавить логирование и инициализацию firebase

  final scope = AppScope();
  await scope.init();

  if (Platform.isAndroid) {
    var status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
  }

  runApp(App(
    scope: scope,
  ));
}
