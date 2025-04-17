import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lawly/features/chat/presentation/screens/chat_screen_wm.dart';

@RoutePage()
class ChatScreenWidget extends ElementaryWidget<IChatScreenWidgetModel> {
  const ChatScreenWidget({
    Key? key,
    WidgetModelFactory wmFactory = defaultChatScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(IChatScreenWidgetModel wm) {
    return Scaffold(
      body: Center(
        child: Text(
          'Chat Screen',
        ),
      ),
    );
  }
}
