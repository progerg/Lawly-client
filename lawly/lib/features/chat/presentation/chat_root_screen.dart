import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'ChatRouter')
class ChatRootScreen extends StatefulWidget {
  const ChatRootScreen({super.key});

  @override
  State<ChatRootScreen> createState() => _ChatRootScreenState();
}

class _ChatRootScreenState extends State<ChatRootScreen> {
  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
