import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Extension для упрощенного получения строк
extension AppLocalizationsX on BuildContext {
  /// Геттер для получения строк
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
