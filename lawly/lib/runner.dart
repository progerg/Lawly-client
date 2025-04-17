import 'package:flutter/material.dart';
import 'package:lawly/features/app/app.dart';
import 'package:lawly/features/app/di/app_scope.dart';

Future<void> run() async {
  // Позже можно добавить логирование и инициализацию firebase

  final scope = AppScope();
  await scope.init();

  runApp(App(
    scope: scope,
  ));
}
