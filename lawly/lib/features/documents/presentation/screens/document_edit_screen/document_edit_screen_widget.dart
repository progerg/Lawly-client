import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lawly/assets/colors/colors.dart';
import 'package:lawly/features/common/widgets/auth_text_field.dart';
import 'package:lawly/features/documents/domain/entity/doc_entity.dart';
import 'package:lawly/features/documents/domain/entity/field_entity.dart';
import 'package:lawly/features/documents/presentation/screens/document_edit_screen/document_edit_screen_wm.dart';
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
          Map<int, TextEditingController> _controller = {
            for (var field in data)
              field.id: TextEditingController(text: field.value ?? '')
          };
          return _DocEditView(
            onApproveChanges: wm.onApproveChanges,
            controllers: _controller,
            fields: data,
          );
        },
        loadingBuilder: (context, data) {
          Map<int, TextEditingController> _controller = {
            for (var field in data ?? [])
              field.id: TextEditingController(text: field.value ?? '')
          };
          return _DocEditView(
            onApproveChanges: wm.onApproveChanges,
            controllers: _controller,
            fields: data ?? [],
          );
        },
        failureBuilder: (context, e, data) {
          Map<int, TextEditingController> _controller = {
            for (var field in data ?? [])
              field.id: TextEditingController(text: field.value ?? '')
          };
          return _DocEditView(
            onApproveChanges: wm.onApproveChanges,
            controllers: _controller,
            fields: data ?? [],
          );
        },
      ),
    );
  }
}

class _DocEditView extends StatefulWidget {
  final VoidCallback onApproveChanges;
  final Map<int, TextEditingController> controllers;
  final List<FieldEntity> fields;

  const _DocEditView({
    required this.onApproveChanges,
    required this.controllers,
    required this.fields,
  });

  @override
  State<_DocEditView> createState() => _DocEditViewState();
}

class _DocEditViewState extends State<_DocEditView> {
  // Map<int, TextEditingController> _controllers = {
  //     for (var field in widget.fields)
  //       field.id: TextEditingController(text: field.value ?? '')
  //   };

  @override
  void initState() {
    super.initState();
    // _controllers = {
    //   for (var field in widget.fields)
    //     field.id: TextEditingController(text: field.value ?? '')
    // };
  }

  @override
  void dispose() {
    widget.controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Padding(
      padding: EdgeInsets.only(
        top: 50,
        bottom: 50,
        right: mediaQuery.size.width * 0.05,
        left: mediaQuery.size.width * 0.05,
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.fields.length,
              itemBuilder: (context, index) {
                final field = widget.fields[index];
                return AuthTextField(
                  textAbove: field.nameRu ?? field.name,
                  controller: widget.controllers[field.id]!,
                  labelText: '',
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: _saveAndReturn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkBlue,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Сохранить',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
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
        type: field.type,
        value: widget.controllers[field.id]?.text,
      );
    }).toList();

    // Отправляем данные назад через роутер
    context.router.pop(updatedFields);
  }
}
