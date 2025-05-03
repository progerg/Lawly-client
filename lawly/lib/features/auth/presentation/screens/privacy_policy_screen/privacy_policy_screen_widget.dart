import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:lawly/assets/colors/colors.dart';
import 'package:lawly/assets/themes/text_style.dart';
import 'package:lawly/features/auth/presentation/screens/privacy_policy_screen/privacy_policy_screen_wm.dart';
import 'package:lawly/features/common/widgets/lawly_circular_indicator.dart';
import 'package:lawly/features/common/widgets/lawly_error_connection.dart';
import 'package:union_state/union_state.dart';

@RoutePage()
class PrivacyPolicyScreenWidget
    extends ElementaryWidget<IPrivacyPolicyScreenWidgetModel> {
  const PrivacyPolicyScreenWidget({
    Key? key,
    WidgetModelFactory wmFactory = defaultPrivacyPolicyScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(IPrivacyPolicyScreenWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: milkyWhite,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: wm.goBack,
        ),
      ),
      body: UnionStateListenableBuilder<String>(
        unionStateListenable: wm.privacyPolicyState,
        builder: (context, data) => SingleChildScrollView(
          child: PrivacyPolicyView(
            data: data,
          ),
        ),
        loadingBuilder: (context, data) => LawlyCircularIndicator(),
        failureBuilder: (context, error, data) => LawlyErrorConnection(),
      ),
    );
  }
}

class PrivacyPolicyView extends StatelessWidget {
  final String data;

  const PrivacyPolicyView({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.only(
          left: mediaQuery.size.width * 0.1,
          right: mediaQuery.size.width * 0.1,
          bottom: mediaQuery.size.height * 0.1,
        ),
        child: MarkdownBody(
          data: data,
        ),
      ),
    );
  }
}
