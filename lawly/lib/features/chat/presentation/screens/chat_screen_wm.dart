import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lawly/features/chat/presentation/screens/chat_screen_model.dart';
import 'package:lawly/features/chat/presentation/screens/chat_screen_widget.dart';

abstract class IChatScreenWidgetModel implements IWidgetModel {}

ChatScreenWidgetModel defaultChatScreenWidgetModelFactory(
    BuildContext context) {
  final model = ChatScreenModel();
  return ChatScreenWidgetModel(model);
}

class ChatScreenWidgetModel
    extends WidgetModel<ChatScreenWidget, ChatScreenModel>
    implements IChatScreenWidgetModel {
  ChatScreenWidgetModel(super.model);
}
