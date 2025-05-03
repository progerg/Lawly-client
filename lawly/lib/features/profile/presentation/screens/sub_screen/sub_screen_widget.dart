import 'dart:developer';

import 'package:auto_route/annotations.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:lawly/assets/colors/colors.dart';
import 'package:lawly/assets/themes/text_style.dart';
import 'package:lawly/features/common/widgets/lawly_circular_indicator.dart';
import 'package:lawly/features/common/widgets/lawly_error_connection.dart';
import 'package:lawly/features/profile/domain/entities/tariff_entity.dart';
import 'package:lawly/features/profile/presentation/screens/sub_screen/sub_screen_wm.dart';
import 'package:union_state/union_state.dart';

@RoutePage()
class SubScreenWidget extends ElementaryWidget<ISubScreenWidgetModel> {
  const SubScreenWidget({
    Key? key,
    WidgetModelFactory wmFactory = defaultSubScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(ISubScreenWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: milkyWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: wm.goBack,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: Text(
              wm.title,
              style: textBold32DarkBlueW700,
            ),
          ),
        ],
      ),
      body: UnionStateListenableBuilder<List<TariffEntity>>(
        unionStateListenable: wm.tariffsState,
        builder: (context, data) => _TariffsView(
          tariffs: data,
        ),
        loadingBuilder: (context, data) => LawlyCircularIndicator(),
        failureBuilder: (context, e, data) => LawlyErrorConnection(),
      ),
    );
  }
}

class _TariffsView extends StatelessWidget {
  final List<TariffEntity> tariffs;

  const _TariffsView({
    required this.tariffs,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 50,
        bottom: 50,
      ),
      child: ListView.builder(
        itemCount: tariffs.length,
        itemBuilder: (context, index) => _TariffTile(
          tariff: tariffs[index],
        ),
      ),
    );
  }
}

class _TariffTile extends StatelessWidget {
  final TariffEntity tariff;

  const _TariffTile({
    required this.tariff,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    log(
      'Tariff: ${tariff.name}, Description: ${tariff.description}, Price: ${tariff.price}, Features: ${tariff.id}, ${tariff.features.toString()}',
    );

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: mediaQuery.size.width * 0.08,
          ),
          child: Container(
            color: lightGray,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tariff.name,
                  style: textBold20DarkBlueW600,
                ),
                const SizedBox(
                  height: 10,
                ),
                ...tariff.features.map((feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '•',
                            style: textBold20DarkBlueW600,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              feature,
                              style: textBold20DarkBlueW400,
                            ),
                          ),
                        ],
                      ),
                    )),
                Text(
                  '${tariff.price}₽',
                  style: textBold20DarkBlueW800,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 24,
        ),
      ],
    );
  }
}
