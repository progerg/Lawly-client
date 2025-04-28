import 'package:flutter/cupertino.dart';

/// Виджет, который делает анфокус при нажатии по области
class UnfocusGestureDetector extends StatelessWidget {
  /// Отображаемый контент
  final Widget child;

  /// Конструктор
  const UnfocusGestureDetector({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      onPanDown: (_) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: child,
    );
  }
}
