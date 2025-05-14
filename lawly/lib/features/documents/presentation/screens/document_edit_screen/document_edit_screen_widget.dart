import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lawly/assets/colors/colors.dart';
import 'package:lawly/assets/res/common_icons.dart';
import 'package:lawly/features/common/widgets/auth_text_field.dart';
import 'package:lawly/features/common/widgets/lawly_circular_indicator.dart';
import 'package:lawly/features/common/widgets/lawly_custom_button.dart';
import 'package:lawly/features/documents/domain/entity/doc_entity.dart';
import 'package:lawly/features/documents/domain/entity/field_entity.dart';
import 'package:lawly/features/documents/presentation/screens/document_edit_screen/document_edit_screen_wm.dart';
import 'package:lawly/l10n/l10n.dart';
import 'package:union_state/union_state.dart';

@RoutePage()
class DocumentEditScreenWidget
    extends ElementaryWidget<IDocumentEditScreenWidgetModel> {
  final DocEntity document;

  const DocumentEditScreenWidget({
    Key? key,
    required this.document,
    WidgetModelFactory wmFactory = defaultDocumentEditScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(IDocumentEditScreenWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          wm.title,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
        ),
        backgroundColor: milkyWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: wm.goBack,
        ),
      ),
      body: UnionStateListenableBuilder<List<FieldEntity>>(
        unionStateListenable: wm.fieldsState,
        builder: (context, data) {
          return _DocEditView(
            onApproveChanges: wm.onApproveChanges,
            fields: data,
          );
        },
        loadingBuilder: (context, data) {
          return LawlyCircularIndicator();
        },
        failureBuilder: (context, e, data) {
          return _DocEditView(
            onApproveChanges: wm.onApproveChanges,
            fields: data ?? [],
          );
        },
      ),
    );
  }
}

class _DocEditView extends StatefulWidget {
  final VoidCallback onApproveChanges;
  final List<FieldEntity> fields;

  const _DocEditView({
    required this.onApproveChanges,
    required this.fields,
  });

  @override
  State<_DocEditView> createState() => _DocEditViewState();
}

class _DocEditViewState extends State<_DocEditView> {
  late final Map<int, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();

    _controllers = {
      for (var field in widget.fields)
        field.id: TextEditingController(text: field.value ?? '')
    };
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          ...widget.fields.map(
            (field) => Padding(
              padding: EdgeInsets.only(
                right: mediaQuery.size.width * 0.08,
                left: mediaQuery.size.width * 0.08,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 21,
                  ),
                  AuthTextField(
                    textAbove: field.nameRu ?? field.name,
                    controller: _controllers[field.id]!,
                    labelText: field.example ?? '',
                    mask: field.mask,
                    filter: field.filterField ?? {},
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 45,
          ),
          LawlyCustomButton(
            onPressed: _saveAndReturn,
            text: context.l10n.add,
            iconPath: CommonIcons.addIcon,
            padding: EdgeInsets.symmetric(
              horizontal: mediaQuery.size.width * 0.08,
            ),
          ),
        ],
      ),
    );
  }

  void _saveAndReturn() {
    // Создаем список обновленных полей
    final updatedFields = widget.fields.map((field) {
      return FieldEntity(
        id: field.id,
        name: field.name,
        nameRu: field.nameRu,
        mask: field.mask,
        example: field.example,
        filterField: field.filterField,
        canImproveAi: field.canImproveAi,
        value: _controllers[field.id]?.text,
      );
    }).toList();

    // Отправляем данные назад через роутер
    context.router.pop(updatedFields);
  }
}
