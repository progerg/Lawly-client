import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lawly/assets/colors/colors.dart';
import 'package:lawly/assets/res/common_res.dart';
import 'package:lawly/assets/themes/text_style.dart';
import 'package:lawly/features/templates/presentation/screens/custom_template_screen/custom_template_screen_wm.dart';
import 'package:lawly/l10n/l10n.dart';

@RoutePage()
class CustomTemplateScreenWidget
    extends ElementaryWidget<ICustomTemplateScreenWidgetModel> {
  const CustomTemplateScreenWidget({
    Key? key,
    WidgetModelFactory wmFactory =
        defaultCustomTemplateScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(ICustomTemplateScreenWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          wm.title,
          style: textBold32DarkBlueW700,
        ),
        backgroundColor: milkyWhite,
        elevation: 0,
        leading: IconButton(
          onPressed: wm.goBack,
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: _CustomTemplateView(
        controller: wm.controller,
        onGenerateTemplate: wm.onGenerateTemplate,
        onImproveText: wm.onImproveText,
      ),
    );
  }
}

class _CustomTemplateView extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onGenerateTemplate;
  final VoidCallback onImproveText;

  const _CustomTemplateView({
    required this.controller,
    required this.onGenerateTemplate,
    required this.onImproveText,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: lightGray,
            ),
            child: Stack(
              children: [
                Image.asset(
                  CommonRes.emptyTemplate,
                  fit: BoxFit.fitWidth,
                  width: mediaQuery.size.width,
                  // height: mediaQuery.size.height * 0.75,
                  alignment: Alignment.topCenter,
                  errorBuilder: (_, __, ___) => const SizedBox(),
                ),
                // ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    alignment: Alignment.center,
                    color: lightGray,
                    width: mediaQuery.size.width,
                    padding: EdgeInsets.symmetric(
                      horizontal: mediaQuery.size.width * 0.1,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.my_template,
                          style: textBold14DarkBlueW700,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: mediaQuery.size.width * 0.04,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: darkBlue,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              padding: const EdgeInsets.all(24.0),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Заголовок
                    Text(
                      context.l10n.describe_situation,
                      style: textBold16DarkBlueW400.copyWith(
                        color: white,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Текстовое поле
                    Container(
                      height: mediaQuery.size.height * 0.4,
                      decoration: BoxDecoration(
                        color: lightGray,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: controller,
                        maxLines: null, // Многострочный ввод
                        expands: true,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Expanded(
                      child: Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: ElevatedButton(
                            onPressed: onGenerateTemplate,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: white,
                              foregroundColor: darkBlue,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              context.l10n.generate,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Expanded(
                      child: Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: ElevatedButton(
                            onPressed: onImproveText,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: white,
                              foregroundColor: darkBlue,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              context.l10n.perform_with_ai,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
