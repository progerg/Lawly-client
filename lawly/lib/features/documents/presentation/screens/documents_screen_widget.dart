import 'package:auto_route/annotations.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lawly/assets/colors/colors.dart';
import 'package:lawly/assets/res/common_icons.dart';
import 'package:lawly/assets/themes/text_style.dart';
import 'package:lawly/features/common/widgets/lawly_circular_indicator.dart';
import 'package:lawly/features/documents/domain/entity/doc_entity.dart';
import 'package:lawly/features/documents/domain/entity/field_entity.dart';
import 'package:lawly/features/documents/presentation/screens/documents_screen_wm.dart';
import 'package:lawly/l10n/l10n.dart';
import 'package:union_state/union_state.dart';

@RoutePage()
class DocumentsScreenWidget
    extends ElementaryWidget<IDocumentsScreenWidgetModel> {
  const DocumentsScreenWidget({
    Key? key,
    WidgetModelFactory wmFactory = defaultDocumentsScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(IDocumentsScreenWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          wm.title,
          style: textBold32DarkBlueW700,
        ),
        backgroundColor: milkyWhite,
        elevation: 0,
      ),
      body: UnionStateListenableBuilder<List<DocEntity>>(
        unionStateListenable: wm.documentsState,
        builder: (context, data) {
          return _DocumentsView(
            onOpenEditDocument: wm.onOpenEditDocument,
            documents: data,
          );
        },
        loadingBuilder: (context, data) {
          return LawlyCircularIndicator();
        },
        failureBuilder: (context, e, data) {
          return _DocumentsView(
            onOpenEditDocument: wm.onOpenEditDocument,
            documents: data ?? [],
          );
        },
      ),
    );
  }
}

class _DocumentsView extends StatelessWidget {
  final void Function(DocEntity) onOpenEditDocument;
  final List<DocEntity> documents;

  const _DocumentsView({
    required this.onOpenEditDocument,
    required this.documents,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: documents.length,
      itemBuilder: (context, index) {
        return _DocumentTile(
          onOpenEditDocument: () {
            onOpenEditDocument(documents[index]);
          },
          document: documents[index],
        );
      },
    );
  }
}

class _DocumentTile extends StatelessWidget {
  final VoidCallback onOpenEditDocument;
  final DocEntity document;

  const _DocumentTile({
    required this.onOpenEditDocument,
    required this.document,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Column(
      children: [
        const SizedBox(
          height: 17,
        ),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: mediaQuery.size.width * 0.08),
          child: GestureDetector(
            onTap: onOpenEditDocument,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 17,
                vertical: 17,
              ),
              decoration: BoxDecoration(
                color: lightGray,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1, // пропорционально занимает 1 часть (100%)
                    child: Row(
                      children: [
                        SvgPicture.asset(CommonIcons.documentIcon),
                        const SizedBox(
                          width: 17,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                document.nameRu,
                                style: textBold14DarkBlueW700,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              _hasFilledFields(document.fields ?? [])
                                  ? Text(
                                      _getDocumentSummary(
                                        document.fields ?? [],
                                      ),
                                      style: textBold10DarkBlueW500,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    )
                                  : Text(
                                      context.l10n.add,
                                      style: textBold10DarkBlueW500,
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _hasFilledFields(document.fields ?? [])
                      ? Icon(Icons.chevron_right)
                      : SvgPicture.asset(CommonIcons.addIcon)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool _hasFilledFields(List<FieldEntity> fields) {
    return fields
        .any((field) => field.value != null && field.value!.isNotEmpty);
  }

  String _getDocumentSummary(List<FieldEntity> fields) {
    // Объединяем значения заполненных полей через пробел
    return fields
        .where((field) => field.value != null && field.value!.isNotEmpty)
        .map((field) => field.value)
        .join(' ');
  }
}
