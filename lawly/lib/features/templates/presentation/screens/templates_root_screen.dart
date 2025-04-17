import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'TemplatesRouter')
class TemplatesRootScreen extends StatefulWidget {
  const TemplatesRootScreen({super.key});

  @override
  State<TemplatesRootScreen> createState() => _TemplatesRootScreenState();
}

class _TemplatesRootScreenState extends State<TemplatesRootScreen> {
  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
