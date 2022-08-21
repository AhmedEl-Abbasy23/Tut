import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced/app/di.dart';
import 'package:flutter_advanced/presentation/resources/language_manager.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await initAppModule();
  runApp(
    EasyLocalization(
      // Phoenix -> to restart the app when change language.
      child: Phoenix(child: MyApp()),
      supportedLocales: const [ARABIC_LOCALE, ENGLISH_LOCALE],
      path: LOCALISATION_ASSET_PATH,
    ),
  );
}
