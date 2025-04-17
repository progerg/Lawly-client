import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'ProfileRouter')
class ProfileRootScreen extends StatefulWidget {
  const ProfileRootScreen({super.key});

  @override
  State<ProfileRootScreen> createState() => _ProfileRootScreenState();
}

class _ProfileRootScreenState extends State<ProfileRootScreen> {
  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
