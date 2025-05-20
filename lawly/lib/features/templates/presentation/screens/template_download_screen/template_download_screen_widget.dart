import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lawly/assets/colors/colors.dart';
import 'package:lawly/assets/res/common_icons.dart';
import 'package:lawly/assets/res/common_res.dart';
import 'package:lawly/assets/themes/text_style.dart';
import 'package:lawly/features/templates/presentation/screens/template_download_screen/template_download_screen_wm.dart';
import 'package:lawly/l10n/l10n.dart';

@RoutePage()
class TemplateDownloadScreenWidget
    extends ElementaryWidget<ITemplateDownloadScreenWidgetModel> {
  final String filePath;
  final List<int>? fileBytes;
  final String? imageUrl;

  const TemplateDownloadScreenWidget({
    Key? key,
    required this.filePath,
    required this.fileBytes,
    this.imageUrl,
    WidgetModelFactory wmFactory =
        defaultTemplateDownloadScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(ITemplateDownloadScreenWidgetModel wm) {
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
      body: _TemplateDownloadView(
        onDownload: wm.onDownload,
        imageUrl: imageUrl,
        controller: wm.controller,
        onSendLawyer: wm.onSendLawyer,
      ),
    );
  }
}

class _TemplateDownloadView extends StatelessWidget {
  final VoidCallback onDownload;
  final String? imageUrl;
  final TextEditingController controller;
  final VoidCallback onSendLawyer;

  const _TemplateDownloadView({
    required this.onDownload,
    required this.imageUrl,
    required this.controller,
    required this.onSendLawyer,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => onDownload(),
            child: Container(
              decoration: BoxDecoration(
                color: lightGray,
              ),
              child: Stack(
                children: [
                  imageUrl != null
                      ? Image.network(
                          imageUrl!,
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
                            context.l10n.download_template,
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
                      context.l10n.alertion_before_download,
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
                          hintText: context.l10n.write_your_problems,
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
                            onPressed: onSendLawyer,
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
                              context.l10n.send_to_lawyer,
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
