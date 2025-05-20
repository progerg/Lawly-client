import 'package:auto_route/annotations.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lawly/assets/colors/colors.dart';
import 'package:lawly/assets/res/common_res.dart';
import 'package:lawly/assets/themes/text_style.dart';
import 'package:lawly/features/common/widgets/lawly_circular_indicator.dart';
import 'package:lawly/features/documents/domain/entity/local_template_entity.dart';
import 'package:lawly/features/profile/presentation/screens/my_templates_screen/my_templates_screen_wm.dart';
import 'package:lawly/l10n/l10n.dart';
import 'package:union_state/union_state.dart';

@RoutePage()
class MyTemplatesScreenWidget
    extends ElementaryWidget<IMyTemplatesScreenWidgetModel> {
  const MyTemplatesScreenWidget({
    Key? key,
    WidgetModelFactory wmFactory = defaultMyTemplatesScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(IMyTemplatesScreenWidgetModel wm) {
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
      body: UnionStateListenableBuilder<List<LocalTemplateEntity>>(
        unionStateListenable: wm.templatesState,
        builder: (context, data) => _MyTemplatesView(
          templates: data,
          onTapMyTemplate: wm.onTapMyTemplate,
          onDeleteMyTemplate: wm.onDeleteMyTemplate,
        ),
        loadingBuilder: (context, data) => LawlyCircularIndicator(),
        failureBuilder: (context, data, e) => LawlyCircularIndicator(),
      ),
    );
  }
}

class _MyTemplatesView extends StatelessWidget {
  final List<LocalTemplateEntity> templates;
  final void Function(LocalTemplateEntity) onTapMyTemplate;
  final void Function(int) onDeleteMyTemplate;

  const _MyTemplatesView({
    required this.templates,
    required this.onTapMyTemplate,
    required this.onDeleteMyTemplate,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal, // Горизонтальный скролл
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Два элемента в колонке
        crossAxisSpacing: 21, // Вертикальный отступ между элементами
        mainAxisSpacing: 31, // Горизонтальный отступ между элементами
        childAspectRatio: 1.3, // Соотношение сторон карточки (инвертировано)
      ),
      itemCount: templates.length,
      itemBuilder: (context, index) {
        return _MyTemplateCard(
          template: templates[index],
          onTemplateTap: () => onTapMyTemplate(templates[index]),
          onDeleteMyTemplate: () => onDeleteMyTemplate(
            templates[index].templateId,
          ),
        );
      },
    );
  }
}

class _MyTemplateCard extends StatelessWidget {
  final LocalTemplateEntity template;
  final VoidCallback onTemplateTap;
  final VoidCallback onDeleteMyTemplate;

  const _MyTemplateCard({
    required this.template,
    required this.onTemplateTap,
    required this.onDeleteMyTemplate,
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
                        child: template.imageUrl != null
                            ? Image.network(
                                template.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const SizedBox(),
                              )
                            : Image.asset(
                                CommonRes.emptyTemplate,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const SizedBox(),
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            template.name,
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
              onTap: onDeleteMyTemplate,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: darkBlue,
                  child: Icon(
                    Icons.delete_outline_outlined,
                    color: white,
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
