import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
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
import 'package:retrofit/http.dart';
import 'package:union_state/union_state.dart';

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
          IconButton(
            onPressed: wm.onDownload,
            icon: const Icon(Icons.download),
          ),
        ],
      ),
      body: UnionStateListenableBuilder<TemplateEntity>(
          unionStateListenable: wm.templateState,
          builder: (context, data) {
            return UnionStateListenableBuilder<Map<String, String>>(
              unionStateListenable: wm.fieldValuesState,
              builder: (context, fieldsValues) => UnfocusGestureDetector(
                child: _TemplateCard(
                  fieldValues: fieldsValues,
                  onCreateDocument: wm.onCreateDocument,
                  onFillField: wm.onFillField,
                  isAuthorized: wm.isAuthorized,
                  template: data,
                ),
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

class _TemplateCard extends StatelessWidget {
  final void Function({required TemplateEntity template}) onCreateDocument;
  final void Function({required FieldEntity fieldEntity}) onFillField;
  final Map<String, String> fieldValues;
  final bool isAuthorized;
  final TemplateEntity template;

  const _TemplateCard({
    required this.onCreateDocument,
    required this.onFillField,
    required this.fieldValues,
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
                    Container(
                      width: mediaQuery.size.width,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: template.imageUrl.isNotEmpty
                          ? Image.network(
                              // template.imageUrl,
                              'https://s.rnk.ru/images/new_kart/07_03_2025/opis_dokov.webp',
                              fit: BoxFit.fitWidth,
                              errorBuilder: (_, __, ___) => const SizedBox(),
                            )
                          : const SizedBox(),
                    ),
                    Padding(
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
                          const SizedBox(height: 10),
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
                const SizedBox(height: 20),

                // Секция требуемых документов
                if (template.requiredDocuments != null &&
                    template.requiredDocuments!.isNotEmpty)
                  _DocumentsSection(documents: template.requiredDocuments!),

                const SizedBox(height: 20),

                // Секция пользовательских полей
                if (template.customFields != null &&
                    template.customFields!.isNotEmpty)
                  _CustomFieldsSection(
                    fieldValues: fieldValues,
                    onFillField: onFillField,
                    fields: template.customFields!,
                  ),

                const SizedBox(height: 20),
                LawlyCustomButton(
                  onPressed: () => onCreateDocument(template: template),
                  text: 'Сгенерировать',
                  iconPath: CommonIcons.duoArrowIcon,
                  padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.size.width * 0.1,
                  ),
                  colorButton: white,
                  colorText: darkBlue,
                ),
              ],
            )
        ],
      ),
    );
  }
}

class _DocumentsSection extends StatelessWidget {
  final List<DocEntity> documents;

  const _DocumentsSection({
    required this.documents,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Необходимые документы',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: darkBlue,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80, // Фиксированная высота блока с горизонтальным скроллом
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final document = documents[index];
              return _TileItem(
                title: document.nameRu,
                isSelected: index == 0, // Для примера первый элемент выбран
                onTap: () {
                  // Здесь будет ваша логика при нажатии
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// Секция с пользовательскими полями
class _CustomFieldsSection extends StatefulWidget {
  final void Function({required FieldEntity fieldEntity}) onFillField;
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
  bool isHasValue(FieldEntity field) =>
      widget.fieldValues.containsKey(field.name);
  // && widget.fieldValues[field.name]!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Параметры документа',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: darkBlue,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160, // Больше места для двух рядов плиток
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            itemCount: (widget.fields.length + 1) ~/
                2, // Количество колонок (по 2 плитки в столбце)
            itemBuilder: (context, columnIndex) {
              return SizedBox(
                width: 160, // Ширина колонки
                child: Column(
                  children: [
                    // Верхняя плитка
                    if (columnIndex * 2 < widget.fields.length)
                      Expanded(
                        // child: _TileItem(
                        //   title: widget.fields[columnIndex * 2].nameRu ??
                        //       widget.fields[columnIndex * 2].name,
                        //   isSelected:
                        //       isHasValue(widget.fields[columnIndex * 2]),
                        //   onTap: () => setState(() {
                        //     widget.onFillField(
                        //       fieldEntity: widget.fields[columnIndex * 2],
                        //     );
                        //   }),
                        // ),
                        child: _FieldTileItem(
                          title: widget.fields[columnIndex * 2].nameRu ??
                              widget.fields[columnIndex * 2].name,
                          fieldValues: widget.fieldValues,
                          field: widget.fields[columnIndex * 2],
                          onTap: () => setState(() {
                            widget.onFillField(
                              fieldEntity: widget.fields[columnIndex * 2],
                            );
                          }),
                        ),
                      ),
                    const SizedBox(height: 8),
                    // Нижняя плитка (если есть)
                    if (columnIndex * 2 + 1 < widget.fields.length)
                      Expanded(
                        // child: _TileItem(
                        //   title: widget.fields[columnIndex * 2 + 1].nameRu ??
                        //       widget.fields[columnIndex * 2 + 1].name,
                        //   isSelected:
                        //       isHasValue(widget.fields[columnIndex * 2 + 1]),
                        //   onTap: () {
                        //     setState(() {
                        //       widget.onFillField(
                        //         fieldEntity: widget.fields[columnIndex * 2 + 1],
                        //       );
                        //     });
                        //   },
                        // ),
                        child: _FieldTileItem(
                          title: widget.fields[columnIndex * 2 + 1].nameRu ??
                              widget.fields[columnIndex * 2 + 1].name,
                          fieldValues: widget.fieldValues,
                          field: widget.fields[columnIndex * 2 + 1],
                          onTap: () => setState(() {
                            widget.onFillField(
                              fieldEntity: widget.fields[columnIndex * 2 + 1],
                            );
                          }),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// class _FieldTileItem extends StatefulWidget {
//   final String title;
//   final VoidCallback onTap;
//   final Map<String, String> fieldValues;
//   final FieldEntity field;

//   const _FieldTileItem({
//     required this.title,
//     required this.onTap,
//     required this.fieldValues,
//     required this.field,
//   });

//   @override
//   State<_FieldTileItem> createState() => _FieldTileItemState();
// }

// class _FieldTileItemState extends State<_FieldTileItem> {
//   bool isSelected = false;

//   bool isHasValue(FieldEntity field) =>
//       widget.fieldValues.containsKey(field.name) &&
//       widget.fieldValues[field.name]!.isNotEmpty;

//   @override
//   void initState() {
//     super.initState();

//     isSelected = isHasValue(widget.field);
//   }
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 140,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF383B53),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isSelected())
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Виджет плитки
class _TileItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TileItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 140,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF383B53),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isSelected)
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
