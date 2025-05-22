import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:lawly/api/data_sources/local/token_local_data_source.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

const String _webSocketPath = '/api/v1/ws';

class WebSocketService {
  final TokenLocalDataSource _tokenLocalDataSource;

  final String _baseURl;

  WebSocketService({
    required TokenLocalDataSource tokenLocalDataSource,
    required String baseURl,
  })  : _tokenLocalDataSource = tokenLocalDataSource,
        _baseURl = baseURl;

  WebSocketChannel? _channel;

  bool _isConnected = false;
  bool _manualDisconnect = false;
  Timer? _reconnectTimer;

  final StreamController<dynamic> _messageStreamController =
      StreamController<dynamic>.broadcast();

  Stream<dynamic> get messageStream => _messageStreamController.stream;

  bool get isConnected => _isConnected;

  Future<void> connect() async {
    if (_isConnected) {
      log('WebSocket уже подключен');
      return;
    }

    _manualDisconnect = false;

    try {
      final jwtToken = _tokenLocalDataSource.getAccessToken();

      final uri = Uri.parse('$_baseURl$_webSocketPath?token=$jwtToken');

      _channel = WebSocketChannel.connect(uri);
      _isConnected = true;

      _channel?.stream.listen(
        (message) {
          _handleMessage(message);
        },
        onError: (error) {
          log('Ошибка WebSocket: $error');
          _messageStreamController.addError(error);
          _handleDisconnect();
        },
        onDone: () {
          log('Соединение закрыто');
          _handleDisconnect();
        },
      );
    } catch (e) {
      log('Ошибка подключения к WebSocket: $e');
      _messageStreamController.addError(e);
      _handleDisconnect();
    }
  }

  void _handleMessage(dynamic message) {
    try {
      // Пробуем декодировать JSON, если это строка
      if (message is String) {
        final decodedMessage = jsonDecode(message);

        /// {type: connection_status, status: connected, user_id: 41}
        log('Получено сообщение: $decodedMessage');

        // Отправляем сообщение в поток для подписчиков
        _messageStreamController.add(decodedMessage);
      } else {
        // Если не строка, передаем как есть
        log('Получено необработанное сообщение: $message');
        _messageStreamController.add(message);
      }
    } catch (e) {
      log('Ошибка декодирования сообщения: $e');
      _messageStreamController.addError(e);
    }
  }

  /// Отправка сообщения
  Future<void> sendMessage(String message) async {
    if (!_isConnected) {
      log('WebSocket не подключен. Подключение...');
      await connect();
    }

    if (_channel != null) {
      log('Отправка сообщения: $message');
      _channel?.sink.add(jsonEncode({
        'type': 'user_message',
        'content': message,
      }));
    } else {
      final error = 'WebSocket не подключен после попытки подключения';
      log(error);
      throw Exception(error);
    }
  }

  /// Обработка отключения и переподключение
  void _handleDisconnect() {
    _isConnected = false;

    // Если это не было ручное отключение, пробуем переподключиться
    if (!_manualDisconnect) {
      _scheduleReconnect();
    }
  }

  /// Планирование переподключения
  void _scheduleReconnect() {
    if (_reconnectTimer?.isActive == true) return;

    // Подключаемся через 3 секунды
    _reconnectTimer = Timer(const Duration(seconds: 3), () {
      if (!_manualDisconnect) {
        log('Попытка переподключения...');
        connect();
      }
    });
  }

  /// Закрытие соединения
  void disconnect() {
    _manualDisconnect = true;
    _reconnectTimer?.cancel();

    if (_channel != null) {
      _channel?.sink.close();
      _channel = null;
      _isConnected = false;
    }
  }

  /// Освобождение ресурсов
  void dispose() {
    disconnect();
    _messageStreamController.close();
  }
}
