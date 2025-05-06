import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lawly/assets/colors/colors.dart';
import 'package:lawly/assets/themes/text_style.dart';
import 'package:lawly/features/templates/domain/entity/template_entity.dart';
import 'package:lawly/features/templates/presentation/screens/templates_screen/templates_screen_wm.dart';
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
          unionStateListenable: wm.templatesState,
          builder: (context, data) {
            return _TemplatesView(
                onTemplateTap: wm.onTemplateTap, templates: data);
          },
          loadingBuilder: (context, data) {
            return _TemplatesView(
                onTemplateTap: wm.onTemplateTap, templates: data ?? []);
          },
          failureBuilder: (context, e, data) {
            return _TemplatesView(
                onTemplateTap: wm.onTemplateTap, templates: data ?? []);
          }),
    );
  }
}

class _TemplatesView extends StatelessWidget {
  final void Function(TemplateEntity) onTemplateTap;
  final List<TemplateEntity> templates;

  const _TemplatesView({
    required this.templates,
    required this.onTemplateTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Два элемента в ряду
        crossAxisSpacing: 16, // Горизонтальный отступ между элементами
        mainAxisSpacing: 16, // Вертикальный отступ между строками
        childAspectRatio: 0.75, // Соотношение сторон карточки
      ),
      itemCount: templates.length,
      itemBuilder: (context, index) {
        final template = templates[index];
        return _TemplateCard(
          template: template,
          onTemplateTap: () => onTemplateTap(template),
        );
      },
    );
  }
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
    return Container(
      decoration: BoxDecoration(
        color: lightGray,
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  child: Container(
                    color: Colors.grey[300],
                    width: double.infinity,
                    child: template.imageUrl.isNotEmpty
                        ? Image.network(
                            // template.imageUrl,
                            'https://s.rnk.ru/images/new_kart/07_03_2025/opis_dokov.webp',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const SizedBox(),
                          )
                        : const SizedBox(),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onTemplateTap,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        template.nameRu,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2F3042),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Скачать',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
