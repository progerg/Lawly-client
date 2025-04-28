import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lawly/features/chat/presentation/screens/chat_screen_model.dart';
import 'package:lawly/features/chat/presentation/screens/chat_screen_widget.dart';
import 'package:lawly/l10n/l10n.dart';

abstract class IChatScreenWidgetModel implements IWidgetModel {
  String get title;
}

ChatScreenWidgetModel defaultChatScreenWidgetModelFactory(
    BuildContext context) {
  final model = ChatScreenModel();
  return ChatScreenWidgetModel(model);
}

class ChatScreenWidgetModel
    extends WidgetModel<ChatScreenWidget, ChatScreenModel>
    implements IChatScreenWidgetModel {
  @override
  String get title => context.l10n.chat_app_bar_title;

  ChatScreenWidgetModel(super.model);
}
