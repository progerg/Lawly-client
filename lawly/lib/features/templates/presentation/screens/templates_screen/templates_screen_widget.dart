import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lawly/assets/colors/colors.dart';
import 'package:lawly/assets/res/common_icons.dart';
import 'package:lawly/assets/themes/text_style.dart';
import 'package:lawly/features/common/widgets/lawly_circular_indicator.dart';
import 'package:lawly/features/common/widgets/lawly_error_connection.dart';
import 'package:lawly/features/common/widgets/unfocus_gesture_detector.dart';
import 'package:lawly/features/templates/domain/entity/template_entity.dart';
import 'package:lawly/features/templates/presentation/screens/templates_screen/templates_screen_wm.dart';
import 'package:lawly/l10n/l10n.dart';
import 'package:union_state/union_state.dart';

@RoutePage()
class TemplatesScreenWidget
    extends ElementaryWidget<ITemplatesScreenWidgetModel> {
  const TemplatesScreenWidget({
    Key? key,
    WidgetModelFactory wmFactory = defaultTemplatesScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(ITemplatesScreenWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          wm.title,
          style: textBold32DarkBlueW700,
        ),
        backgroundColor: milkyWhite,
        elevation: 0,
      ),
      body: UnionStateListenableBuilder<List<TemplateEntity>>(
          unionStateListenable: wm.filteredTemplatesState,
          builder: (context, data) {
            return UnionStateListenableBuilder<bool>(
              unionStateListenable: wm.canCreateCustomTemplatesState,
              builder: (context, canCreateCustomTemplates) => _TemplatesView(
                canCreateCustomTemplates: canCreateCustomTemplates,
                onCreateCustomTemplate: wm.onCreateCustomTemplate,
                onTemplateTap: wm.onTemplateTap,
                templates: data,
                onSearchQueryChanged: wm.onSearchQueryChanged,
                scrollController: wm.scrollController,
                isLoading: wm.isLoading,
              ),
              loadingBuilder: (context, data) => LawlyCircularIndicator(),
              failureBuilder: (context, e, data) => LawlyErrorConnection(),
            );
          },
          loadingBuilder: (context, data) {
            return LawlyCircularIndicator();
          },
          failureBuilder: (context, e, data) {
            return LawlyErrorConnection();
          }),
    );
  }
}

class _TemplatesView extends StatelessWidget {
  final void Function(TemplateEntity) onTemplateTap;
  final VoidCallback onCreateCustomTemplate;
  final List<TemplateEntity> templates;
  final bool canCreateCustomTemplates;
  final void Function(String) onSearchQueryChanged;
  final ScrollController scrollController;
  final bool isLoading;

  const _TemplatesView({
    required this.templates,
    required this.onCreateCustomTemplate,
    required this.onTemplateTap,
    required this.canCreateCustomTemplates,
    required this.onSearchQueryChanged,
    required this.scrollController,
    required this.isLoading,
  });

  // @override
  // Widget build(BuildContext context) {
  //   return Column(
  //     children: [
  //       _SearchWidget(
  //         onSearchQueryChanged: onSearchQueryChanged,
  //       ),
  //       const SizedBox(height: 20),
  //       Expanded(
  //         child: GridView.builder(
  //           padding: const EdgeInsets.symmetric(horizontal: 16),
  //           scrollDirection: Axis.horizontal,
  //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //             crossAxisCount: 2, // Два элемента в ряду
  //             crossAxisSpacing: 31, // Горизонтальный отступ между элементами
  //             mainAxisSpacing: 21, // Вертикальный отступ между строками
  //             childAspectRatio: 1.3, // Соотношение сторон карточки
  //           ),
  //           itemCount: canCreateCustomTemplates
  //               ? templates.length + 1
  //               : templates.length,
  //           itemBuilder: (context, index) {
  //             if (canCreateCustomTemplates && index == 0) {
  //               // TODO: Виджет для создания кастомного шаблона
  //               return _CreateTemplateCard();
  //             }

  //             final templateIndex =
  //                 canCreateCustomTemplates ? index - 1 : index;
  //             final template = templates[templateIndex];

  //             return _TemplateCard(
  //               template: template,
  //               onTemplateTap: () => onTemplateTap(template),
  //             );
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          delegate: _SliverSearchDelegate(
            child: _SearchWidget(
              onSearchQueryChanged: onSearchQueryChanged,
            ),
          ),
          pinned: true,
        ),
        SliverToBoxAdapter(
          child: const SizedBox(height: 20),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            child: GridView.builder(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal, // Горизонтальный скролл
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Два элемента в колонке
                crossAxisSpacing: 21, // Вертикальный отступ между элементами
                mainAxisSpacing: 31, // Горизонтальный отступ между элементами
                childAspectRatio:
                    1.3, // Соотношение сторон карточки (инвертировано)
              ),
              itemCount: canCreateCustomTemplates
                  ? templates.length + 1
                  : templates.length,
              itemBuilder: (context, index) {
                if (canCreateCustomTemplates && index == 0) {
                  return _CreateTemplateCard(
                    onCreateCustomTemplate: onCreateCustomTemplate,
                  );
                }

                final templateIndex =
                    canCreateCustomTemplates ? index - 1 : index;
                final template = templates[templateIndex];

                return _TemplateCard(
                  template: template,
                  onTemplateTap: () => onTemplateTap(template),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _SliverSearchDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverSearchDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.transparent, // Фон под поисковой строкой
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      child: child,
    );
  }

  @override
  double get maxExtent => 65.0; // Высота поисковой строки с отступами

  @override
  double get minExtent => 65.0; // Минимальная высота (обычно то же значение)

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

class _TemplateCard extends StatelessWidget {
  final VoidCallback onTemplateTap;
  final TemplateEntity template;

  const _TemplateCard({
    required this.template,
    required this.onTemplateTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTemplateTap,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: lightGray,
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        color: lightGray,
                        width: double.infinity,
                        child: template.imageUrl.isNotEmpty
                            ? Image.network(
                                template.imageUrl,
                                // 'https://s.rnk.ru/images/new_kart/07_03_2025/opis_dokov.webp',
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const SizedBox(),
                              )
                            : const SizedBox(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            template.nameRu,
                            style: textBold14DarkBlueW700,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            context.l10n.download,
                            style: textBold12DarkBlueW400.copyWith(
                              color: gray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: darkBlue,
                  child: SvgPicture.asset(
                    CommonIcons.bookmarkIcon,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CreateTemplateCard extends StatelessWidget {
  final VoidCallback onCreateCustomTemplate;

  const _CreateTemplateCard({
    required this.onCreateCustomTemplate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCreateCustomTemplate,
      child: Container(
        decoration: BoxDecoration(
          color: lightGray,
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  context.l10n.add_custom_template,
                  style: textBold14DarkBlueW700,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                SvgPicture.asset(
                  CommonIcons.addBorderedIcon,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchWidget extends StatelessWidget {
  final void Function(String) onSearchQueryChanged;

  const _SearchWidget({
    required this.onSearchQueryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF464D78),
          borderRadius: BorderRadius.circular(25),
        ),
        child: TextField(
          cursorColor: milkyWhite,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            hintText: context.l10n.enter_template_name,
            hintStyle: textBold16DarkBlueW400.copyWith(color: white),
            suffixIcon: const Icon(Icons.search, color: Colors.white),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 28),
          ),
          style: textBold16DarkBlueW400.copyWith(
            color: white,
            decoration: TextDecoration.none,
          ),
          onChanged: onSearchQueryChanged,
        ),
      ),
    );
  }
}
