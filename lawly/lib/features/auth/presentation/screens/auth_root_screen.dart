import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'AuthRouter')
class AuthRootScreen extends StatefulWidget {
  const AuthRootScreen({super.key});

  @override
  State<AuthRootScreen> createState() => _AuthRootScreenState();
}

class _AuthRootScreenState extends State<AuthRootScreen> {
  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
