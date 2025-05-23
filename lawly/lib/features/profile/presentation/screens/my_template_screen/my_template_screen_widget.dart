import 'package:auto_route/annotations.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lawly/assets/colors/colors.dart';
import 'package:lawly/assets/res/common_icons.dart';
import 'package:lawly/assets/res/common_res.dart';
import 'package:lawly/assets/themes/text_style.dart';
import 'package:lawly/features/documents/domain/entity/local_template_entity.dart';
import 'package:lawly/features/profile/presentation/screens/my_template_screen/my_template_screen_wm.dart';
import 'package:lawly/l10n/l10n.dart';

@RoutePage()
class MyTemplateScreenWidget
    extends ElementaryWidget<IMyTemplateScreenWidgetModel> {
  final LocalTemplateEntity template;

  const MyTemplateScreenWidget({
    Key? key,
    required this.template,
    WidgetModelFactory wmFactory = defaultMyTemplateScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(IMyTemplateScreenWidgetModel wm) {
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: wm.onDownload,
              icon: SvgPicture.asset(
                width: 25,
                height: 25,
                CommonIcons.downloadIcon,
              ),
            ),
          ),
        ],
      ),
      body: _MyTemplateView(
        template: template,
        onDownload: wm.onDownload,
      ),
    );
  }
}

class _MyTemplateView extends StatelessWidget {
  final LocalTemplateEntity template;
  final VoidCallback onDownload;

  const _MyTemplateView({
    required this.template,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return GestureDetector(
      onTap: () => onDownload(),
      child: Container(
        decoration: BoxDecoration(
          color: lightGray,
        ),
        child: Stack(
          children: [
            template.imageUrl != null
                ? Image.network(
                    template.imageUrl!,
                    height: mediaQuery.size.height * 0.45,
                    width: mediaQuery.size.width,
                    // 'https://s.rnk.ru/images/new_kart/07_03_2025/opis_dokov.webp',
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                    errorBuilder: (_, __, ___) => const SizedBox(),
                  )
                : Image.asset(
                    CommonRes.emptyTemplate,
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                    errorBuilder: (_, __, ___) => const SizedBox(),
                  ),
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
                      template.name,
                      style: textBold14DarkBlueW700,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
