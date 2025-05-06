import 'package:auto_route/annotations.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lawly/assets/colors/colors.dart';
import 'package:lawly/features/common/widgets/unfocus_gesture_detector.dart';
import 'package:lawly/features/documents/domain/entity/field_entity.dart';
import 'package:lawly/features/templates/presentation/screens/template_edit_field_screen/template_edit_field_screen_wm.dart';

@RoutePage()
class TemplateEditFieldScreenWidget
    extends ElementaryWidget<ITemplateEditFieldScreenWidgetModel> {
  final FieldEntity fieldEntity;

  const TemplateEditFieldScreenWidget({
    Key? key,
    required this.fieldEntity,
    WidgetModelFactory wmFactory =
        defaultTemplateEditFieldScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(ITemplateEditFieldScreenWidgetModel wm) {
    return Scaffold(
      backgroundColor: darkBlue50,
      resizeToAvoidBottomInset: false,
      body: UnfocusGestureDetector(
        child: _EditFieldView(
          onEnter: wm.onEnter,
          onBack: wm.goBack,
          fieldEntity: fieldEntity,
          controller: wm.textEditingController..text = fieldEntity.value ?? '',
        ),
      ),
    );
  }
}

class _EditFieldView extends StatelessWidget {
  final VoidCallback onEnter;
  final VoidCallback onBack;
  final FieldEntity fieldEntity;
  final TextEditingController controller;

  const _EditFieldView({
    required this.onEnter,
    required this.onBack,
    required this.fieldEntity,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Stack(
      children: [
        Positioned.fill(
          child: Container(color: Colors.black54),
        ),
        Positioned(
          left: 20,
          right: 20,
          top: MediaQuery.of(context).size.height * 0.15,
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF383B53),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            padding: const EdgeInsets.all(24.0),
            // margin: EdgeInsets.symmetric(
            //   horizontal: 20.0,
            //   vertical: MediaQuery.of(context).size.height * 0.15,
            // ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Заголовок
                  const Text(
                    'Введите текст',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Текстовое поле
                  Container(
                    height: mediaQuery.size.height * 0.4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAEAEA),
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
                        hintText:
                            'Введите ${fieldEntity.nameRu ?? fieldEntity.name}',
                        hintStyle: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Кнопка "Сгенерировать"
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: ElevatedButton(
                        onPressed: onEnter,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF383B53),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Ввести',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Кнопка "Назад" (если нужна)
                  Center(
                    child: TextButton(
                      onPressed: onBack,
                      child: const Text(
                        'Назад',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
