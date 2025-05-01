import 'package:flutter/widgets.dart';

class Environment<T> {
  static Environment? _instance;

  ValueNotifier<T> _config;

  Environment._(T config) : _config = ValueNotifier(config);

  T get config => _config.value;

  set config(T val) => _config.value = val;

  factory Environment.instance() => _instance! as Environment<T>;

  static void init<T>({required T config}) {
    _instance ??= Environment<T>._(config);
  }
}
