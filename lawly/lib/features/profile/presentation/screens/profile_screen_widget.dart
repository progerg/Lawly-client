import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lawly/assets/colors/colors.dart';
import 'package:lawly/assets/res/bottom_nav_tab_icons.dart';
import 'package:lawly/assets/res/common_icons.dart';
import 'package:lawly/assets/themes/text_style.dart';
import 'package:lawly/features/common/widgets/selection_button.dart';
import 'package:lawly/features/profile/domain/entities/user_info_entity.dart';
import 'package:lawly/features/profile/presentation/screens/profile_screen_wm.dart';
import 'package:lawly/l10n/l10n.dart';
import 'package:shimmer/shimmer.dart';
import 'package:union_state/union_state.dart';

@RoutePage()
class ProfileScreenWidget extends ElementaryWidget<IProfileScreenWidgetModel> {
  const ProfileScreenWidget({
    Key? key,
    WidgetModelFactory wmFactory = defaultProfileScreenWidgetModelFactory,
  }) : super(wmFactory, key: key);

  @override
  Widget build(IProfileScreenWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          wm.title,
          style: textBold32DarkBlueW700,
        ),
        backgroundColor: milkyWhite,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: GestureDetector(
              onTap: wm.onLogout,
              child: SvgPicture.asset(
                CommonIcons.logoutIcon,
              ),
            ),
          ),
        ],
      ),
      body: UnionStateListenableBuilder<UserInfoEntity>(
        unionStateListenable: wm.userInfoState,
        builder: (context, data) => _ProfileView(
          openPrivacyPolicy: wm.openPrivacyPolicy,
          onOpenSettings: wm.onOpenSettings,
          onOpenSubs: wm.onOpenSubs,
          userInfoStatus: UserInfoStatus.success,
          username: wm.username,
          email: wm.email,
          userInfo: data,
        ),
        loadingBuilder: (context, data) => _ProfileView(
          openPrivacyPolicy: wm.openPrivacyPolicy,
          onOpenSettings: wm.onOpenSettings,
          onOpenSubs: wm.onOpenSubs,
          username: wm.username,
          email: wm.email,
          userInfoStatus: UserInfoStatus.loading,
        ),
        failureBuilder: (context, e, data) => _ProfileView(
          openPrivacyPolicy: wm.openPrivacyPolicy,
          onOpenSettings: wm.onOpenSettings,
          onOpenSubs: wm.onOpenSubs,
          username: wm.username,
          email: wm.email,
          userInfoStatus: UserInfoStatus.error,
        ),
      ),
    );
  }
}

class _ProfileView extends StatelessWidget {
  final VoidCallback openPrivacyPolicy;
  final VoidCallback onOpenSettings;
  final VoidCallback onOpenSubs;
  final UserInfoStatus userInfoStatus;
  final UserInfoEntity? userInfo;
  final String username;
  final String email;

  const _ProfileView({
    required this.openPrivacyPolicy,
    required this.onOpenSettings,
    required this.onOpenSubs,
    required this.userInfoStatus,
    required this.username,
    required this.email,
    this.userInfo,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final fixedWidth = mediaQuery.size.width;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 50,
          bottom: 50,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: mediaQuery.size.width * 0.08,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: fixedWidth * 0.15 + 3,
                        backgroundColor: lightBlue,
                      ),
                      CircleAvatar(
                        radius: fixedWidth * 0.15,
                        backgroundColor: darkGray,
                        child: SvgPicture.asset(
                          BottomNavTabIcons.profileTabIcon,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: textBold18DarkBlueW500,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 14),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(text: email),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(context.l10n.copy_email),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          child: Text(
                            email,
                            style: textBold15DarkBlueW400.copyWith(
                              color: darkBlue80,
                              decoration: TextDecoration.underline,
                              decorationColor: darkBlue50,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 14),
                        ...[
                          switch (userInfoStatus) {
                            UserInfoStatus.loading => Shimmer.fromColors(
                                baseColor: darkGray,
                                highlightColor: darkWhite,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: mediaQuery.size.width * 0.4,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: milkyWhite,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      width: mediaQuery.size.width * 0.3,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: milkyWhite,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            UserInfoStatus.error => Text(
                                context.l10n.no_sub,
                                style: textBold15DarkBlueW400.copyWith(
                                  color: darkBlue80,
                                ),
                              ),
                            UserInfoStatus.success => Text(
                                userInfo!.tariff.name,
                                style: textBold15DarkBlueW400,
                              ),
                          }
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SelectionButton(
              onPressed: onOpenSubs,
              text: context.l10n.subscription,
              padding: EdgeInsets.symmetric(
                horizontal: mediaQuery.size.width * 0.1,
              ),
            ),
            const SizedBox(height: 24),
            SelectionButton(
              onPressed: openPrivacyPolicy,
              text: context.l10n.privacy_policy,
              padding: EdgeInsets.symmetric(
                horizontal: mediaQuery.size.width * 0.1,
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            SelectionButton(
              onPressed: onOpenSettings,
              text: context.l10n.settings,
              padding: EdgeInsets.symmetric(
                horizontal: mediaQuery.size.width * 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum UserInfoStatus {
  loading,
  error,
  success,
}
