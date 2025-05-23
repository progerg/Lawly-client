import 'package:auto_route/annotations.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lawly/assets/colors/colors.dart';
import 'package:lawly/features/common/widgets/unfocus_gesture_detector.dart';
import 'package:lawly/features/documents/domain/entity/field_entity.dart';
import 'package:lawly/features/templates/presentation/screens/template_edit_field_screen/template_edit_field_screen_wm.dart';
import 'package:lawly/l10n/l10n.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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
          onImproveText: wm.onImproveText,
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
  final VoidCallback onImproveText;
  final FieldEntity fieldEntity;
  final TextEditingController controller;

  const _EditFieldView({
    required this.onEnter,
    required this.onBack,
    required this.onImproveText,
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
              color: darkBlue,
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
                  Text(
                    fieldEntity.nameRu ?? fieldEntity.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Текстовое поле
                  Container(
                    height: mediaQuery.size.height * 0.35,
                    decoration: BoxDecoration(
                      color: lightGray,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: controller,
                      maxLines: null, // Многострочный ввод
                      expands: true,
                      inputFormatters: [
                        MaskTextInputFormatter(
                          mask: fieldEntity.mask,
                          filter: fieldEntity.filterField?.map(
                            (key, value) => MapEntry(key, RegExp(value)),
                          ),
                        ),
                      ],
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: fieldEntity.example != null
                            ? '${context.l10n.for_example}, ${fieldEntity.example}'
                            : '${context.l10n.enter_smth} ${fieldEntity.nameRu ?? fieldEntity.name}',
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
                          onPressed: onEnter,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: darkBlue,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            context.l10n.enter_and_next,
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

                  if (fieldEntity.canImproveAi)
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: ElevatedButton(
                            onPressed: onImproveText,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: darkBlue,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              context.l10n.perform_with_ai,
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

                  // Кнопка "Назад" (если нужна)
                  Center(
                    child: TextButton(
                      onPressed: onBack,
                      child: Text(
                        context.l10n.back,
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
