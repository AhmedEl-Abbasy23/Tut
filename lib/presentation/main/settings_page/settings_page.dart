import 'dart:math' as math;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced/app/app_prefs.dart';
import 'package:flutter_advanced/app/di.dart';
import 'package:flutter_advanced/data/data_source/local_data_source.dart';
import 'package:flutter_advanced/presentation/resources/assets_manager.dart';
import 'package:flutter_advanced/presentation/resources/language_manager.dart';
import 'package:flutter_advanced/presentation/resources/routes_manager.dart';
import 'package:flutter_advanced/presentation/resources/strings_manager.dart';
import 'package:flutter_advanced/presentation/resources/values_manager.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final LocalDataSource _localDataSource = instance<LocalDataSource>();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppPadding.p8),
      children: [
        _getListTileWidget(
          leadingIcon: ImageAssets.tools,
          title: AppStrings.changeLanguage.tr(),
          onTap: _changeLanguage,
        ),
        _getListTileWidget(
          leadingIcon: ImageAssets.contactUs,
          title: AppStrings.contactUs.tr(),
          onTap: _contactUs,
        ),
        _getListTileWidget(
          leadingIcon: ImageAssets.inviteFriends,
          title: AppStrings.inviteFriends.tr(),
          onTap: _inviteFriends,
        ),
        ListTile(
          leading: SvgPicture.asset(ImageAssets.logout, height: AppSize.s28),
          title: Text(
            AppStrings.logout.tr(),
            style: Theme.of(context).textTheme.headline4,
          ),
          onTap: _logout,
        ),
      ],
    );
  }

  // check current app language.
  bool isRtl() {
    return context.locale == ARABIC_LOCALE;
  }

  void _changeLanguage() {
    _appPreferences.changeAppLanguage();
    // restart app to apply chang language
    Phoenix.rebirth(context);
  }

  void _contactUs() {}

  void _inviteFriends() {}

  void _logout() {
    _localDataSource.clearCache();
    _appPreferences.logout();
    Navigator.pushReplacementNamed(context, Routes.loginRoute);
  }

  Widget _getListTileWidget({
    required String leadingIcon,
    required String title,
    required Function onTap,
  }) {
    return ListTile(
      leading: SvgPicture.asset(leadingIcon, height: AppSize.s28),
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline4,
      ),
      trailing: Transform(
        alignment: Alignment.center,
        // to rotate arrow depending on app language.
        transform: Matrix4.rotationY(
          isRtl() ? math.pi : 0
        ),
        child: SvgPicture.asset(ImageAssets.rightArrowOrangeIc, height: AppSize.s20),
      ),

      onTap: () {
        onTap();
      },
    );
  }
}
