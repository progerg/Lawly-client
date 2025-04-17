import 'package:flutter/widgets.dart';

class Enviroment<T> {
  static Enviroment? _instance;

  ValueNotifier<T> _config;

  Enviroment._(T config) : _config = ValueNotifier(config);

  T get config => _config.value;

  set config(T val) => _config.value = val;

  factory Enviroment.instance() => _instance! as Enviroment<T>;

  static void init<T>({required T config}) {
    _instance ??= Enviroment<T>._(config);
  }
}
