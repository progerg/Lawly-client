import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'DocumentsRouter')
class DocumentsRootScreen extends StatefulWidget {
  const DocumentsRootScreen({super.key});

  @override
  State<DocumentsRootScreen> createState() => _DocumentsRootScreenState();
}

class _DocumentsRootScreenState extends State<DocumentsRootScreen> {
  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
