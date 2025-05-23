import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef ScopeFactory<T> = T Function();

typedef Dispose<T> = Function(BuildContext context, T scope);

class DiScope<T> extends StatefulWidget {
  final ScopeFactory<T> factory;

  final Widget child;

  final Dispose<T>? dispose;

  const DiScope(
      {required this.factory, required this.child, this.dispose, super.key});

  @override
  State<DiScope<T>> createState() => _DiScopeState<T>();
}

class _DiScopeState<T> extends State<DiScope<T>> {
  late T scope;

  @override
  void initState() {
    scope = widget.factory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => scope,
      dispose: widget.dispose,
      child: widget.child,
    );
  }
}
