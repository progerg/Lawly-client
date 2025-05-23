import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lawly/assets/colors/colors.dart';
import 'package:lawly/assets/res/common_icons.dart';
import 'package:lawly/assets/themes/text_style.dart';
import 'package:lawly/features/common/widgets/lawly_circular_indicator.dart';
import 'package:lawly/features/common/widgets/lawly_custom_button.dart';
import 'package:lawly/features/common/widgets/lawly_error_connection.dart';
import 'package:lawly/features/common/widgets/unfocus_gesture_detector.dart';
import 'package:lawly/features/documents/domain/entity/doc_entity.dart';
import 'package:lawly/features/documents/domain/entity/field_entity.dart';
import 'package:lawly/features/templates/domain/entity/template_entity.dart';
import 'package:lawly/features/templates/presentation/screens/template_noauth_sreen/template_noauth_screen_wm.dart';
import 'package:lawly/l10n/l10n.dart';
import 'package:union_state/union_state.dart';

const double kTileHeight = 80.0; // Высота плитки

@RoutePage()
class TemplateNoAuthScreenWidget
    extends ElementaryWidget<ITemplateNoAuthScreenWidgetModel> {
  final TemplateEntity template;

  const TemplateNoAuthScreenWidget({
    Key? key,
    required this.template,
    WidgetModelFactory wmFactory =
        defaultTemplateNoAuthScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(ITemplateNoAuthScreenWidgetModel wm) {
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
      body: UnionStateListenableBuilder<TemplateEntity>(
          unionStateListenable: wm.templateState,
          builder: (context, data) {
            return UnionStateListenableBuilder<List<DocEntity>>(
              unionStateListenable: wm.documentState,
              builder: (context, documents) {
                return UnionStateListenableBuilder<Map<String, String>>(
                  unionStateListenable: wm.fieldValuesState,
                  builder: (context, fieldsValues) => UnfocusGestureDetector(
                    child: _TemplateCard(
                      onDownload: wm.onDownload,
                      fieldValues: fieldsValues,
                      documents: documents,
                      onCreateDocument: wm.onCreateDocument,
                      onFillField: wm.onFillField,
                      onFillDocument: wm.onFillDocument,
                      isAuthorized: wm.isAuthorized,
                      template: data,
                    ),
                  ),
                  loadingBuilder: (context, data) => LawlyCircularIndicator(),
                  failureBuilder: (context, e, data) => LawlyErrorConnection(),
                );
              },
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

class _TemplateCard extends StatelessWidget {
  final VoidCallback onDownload;
  final void Function({required TemplateEntity template}) onCreateDocument;
  final void Function({
    required FieldEntity fieldEntity,
    required List<FieldEntity> fields,
  }) onFillField;
  final void Function({
    required DocEntity document,
  }) onFillDocument;
  final Map<String, String> fieldValues;
  final List<DocEntity> documents;
  final bool isAuthorized;
  final TemplateEntity template;

  const _TemplateCard({
    required this.onDownload,
    required this.onCreateDocument,
    required this.onFillField,
    required this.onFillDocument,
    required this.fieldValues,
    required this.documents,
    required this.isAuthorized,
    required this.template,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => onDownload(),
                      child: Container(
                        height: mediaQuery.size.height * 0.45,
                        width: mediaQuery.size.width,
                        decoration: const BoxDecoration(
                          color: lightGray,
                        ),
                        child: template.imageUrl.isNotEmpty
                            ? Image.network(
                                template.imageUrl,
                                // 'https://s.rnk.ru/images/new_kart/07_03_2025/opis_dokov.webp',
                                fit: BoxFit.fitWidth,
                                alignment: Alignment.topCenter,
                                errorBuilder: (_, __, ___) => const SizedBox(),
                              )
                            : const SizedBox(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: mediaQuery.size.width * 0.1,
                        vertical: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            template.nameRu,
                            style: textBold14DarkBlueW700,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isAuthorized)
            Column(
              children: [
                // Секция требуемых документов
                if (template.requiredDocuments != null &&
                    template.requiredDocuments!.isNotEmpty)
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      _DocumentsSection(
                        documents: documents,
                        onFillDocument: onFillDocument,
                      ),
                    ],
                  ),
                // Секция пользовательских полей
                if (template.customFields != null &&
                    template.customFields!.isNotEmpty)
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      _CustomFieldsSection(
                        fieldValues: fieldValues,
                        onFillField: onFillField,
                        fields: template.customFields!,
                      ),
                    ],
                  ),

                const SizedBox(height: 20),
                LawlyCustomButton(
                  onPressed: () => onCreateDocument(template: template),
                  text: context.l10n.generate,
                  iconPath: CommonIcons.duoArrowIcon,
                  padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.size.width * 0.04,
                  ),
                  colorButton: white,
                  colorText: darkBlue,
                ),
                const SizedBox(height: 20),
              ],
            )
        ],
      ),
    );
  }
}

class _DocumentsSection extends StatelessWidget {
  final List<DocEntity> documents;
  final void Function({
    required DocEntity document,
  }) onFillDocument;

  const _DocumentsSection({
    required this.documents,
    required this.onFillDocument,
  });

  bool isSelected(DocEntity document) =>
      document.fields?.every(
        (field) => field.value != null && field.value!.isNotEmpty,
      ) ??
      false;

  String getSubTitle(DocEntity document) {
    if (document.fields != null) {
      return _getDocumentSummary(document.fields!);
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            context.l10n.needed_docs,
            style: textBold15DarkBlueW700,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: kTileHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final document = documents[index];
              return _TileItem(
                title: document.nameRu,
                subtitle: getSubTitle(document),
                isSelected: () =>
                    isSelected(document), // Для примера первый элемент выбран
                onTap: () => onFillDocument(
                  document: document,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _getDocumentSummary(List<FieldEntity> fields) {
    // Объединяем значения заполненных полей через пробел
    return fields
        .where((field) => field.value != null && field.value!.isNotEmpty)
        .map((field) => field.value)
        .join(' ');
  }
}

// Секция с пользовательскими полями
class _CustomFieldsSection extends StatefulWidget {
  final void Function({
    required FieldEntity fieldEntity,
    required List<FieldEntity> fields,
  }) onFillField;
  final Map<String, String> fieldValues;
  final List<FieldEntity> fields;

  const _CustomFieldsSection({
    required this.onFillField,
    required this.fieldValues,
    required this.fields,
  });

  @override
  State<_CustomFieldsSection> createState() => _CustomFieldsSectionState();
}

class _CustomFieldsSectionState extends State<_CustomFieldsSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            context.l10n.fields_of_doc,
            style: textBold15DarkBlueW700,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: kTileHeight * 2, // Больше места для двух рядов плиток
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: (widget.fields.length + 1) ~/
                2, // Количество колонок (по 2 плитки в столбце)
            itemBuilder: (context, columnIndex) {
              return Column(
                children: [
                  // Верхняя плитка
                  if (columnIndex * 2 < widget.fields.length)
                    Expanded(
                      child: _FieldTileItem(
                        title: widget.fields[columnIndex * 2].nameRu ??
                            widget.fields[columnIndex * 2].name,
                        fieldValues: widget.fieldValues,
                        field: widget.fields[columnIndex * 2],
                        onTap: () => setState(() {
                          widget.onFillField(
                            fieldEntity: widget.fields[columnIndex * 2],
                            fields: widget.fields,
                          );
                        }),
                      ),
                    ),
                  const SizedBox(height: 8),
                  // Нижняя плитка (если есть)
                  if (columnIndex * 2 + 1 < widget.fields.length)
                    Expanded(
                      child: _FieldTileItem(
                        title: widget.fields[columnIndex * 2 + 1].nameRu ??
                            widget.fields[columnIndex * 2 + 1].name,
                        fieldValues: widget.fieldValues,
                        field: widget.fields[columnIndex * 2 + 1],
                        onTap: () => setState(() {
                          widget.onFillField(
                            fieldEntity: widget.fields[columnIndex * 2 + 1],
                            fields: widget.fields,
                          );
                        }),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FieldTileItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Map<String, String> fieldValues;
  final FieldEntity field;

  const _FieldTileItem({
    required this.title,
    required this.onTap,
    required this.fieldValues,
    required this.field,
  });

  bool isSelected() =>
      fieldValues.containsKey(field.name) &&
      fieldValues[field.name]!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return _TileItem(
      title: title,
      subtitle: fieldValues[field.name] ?? '',
      isSelected: isSelected,
      onTap: onTap,
    );
  }
}

// Виджет плитки
class _TileItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool Function() isSelected;
  final VoidCallback onTap;

  const _TileItem({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mediaQuery.size.width * 0.04),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: mediaQuery.size.width * 0.92,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: darkBlue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textBold16DarkBlueW600.copyWith(
                        color: white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      subtitle,
                      style: textBold10DarkBlueW500.copyWith(
                        color: white,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              isSelected()
                  ? SvgPicture.asset(CommonIcons.checkboxIcon)
                  : SvgPicture.asset(CommonIcons.checkboxEmptyIcon),
            ],
          ),
        ),
      ),
    );
  }
}
