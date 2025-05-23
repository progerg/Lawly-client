import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lawly/assets/colors/colors.dart';
import 'package:lawly/assets/themes/text_style.dart';
import 'package:lawly/features/common/widgets/selection_button.dart';
import 'package:lawly/features/profile/presentation/screens/settings_screen/settings_screen_wm.dart';
import 'package:lawly/l10n/l10n.dart';

@RoutePage()
class SettingsScreenWidget
    extends ElementaryWidget<ISettingsScreenWidgetModel> {
  const SettingsScreenWidget({
    Key? key,
    WidgetModelFactory wmFactory = defaultSettingsScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(ISettingsScreenWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: milkyWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: wm.goBack,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: Text(
              wm.title,
              style: textBold32DarkBlueW700,
            ),
          ),
        ],
      ),
      body: _SettingsView(
        onLogout: wm.onLogout,
      ),
    );
  }
}

class _SettingsView extends StatelessWidget {
  final VoidCallback onLogout;

  const _SettingsView({
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 50,
          bottom: 50,
        ),
        child: Column(
          children: [
            SelectionButton(
              onPressed: onLogout,
              text: context.l10n.log_out,
              padding: EdgeInsets.symmetric(
                horizontal: mediaQuery.size.width * 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
