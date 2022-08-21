import 'package:flutter/material.dart';

enum LanguageType { ENGLISH, ARABIC }

const String ENGLISH = 'en';
const String ARABIC = 'ar';
const String LOCALISATION_ASSET_PATH = 'assets/translations';

const Locale ENGLISH_LOCALE = Locale("en", "US"); // like assets name
const Locale ARABIC_LOCALE =
    Locale("ar", "EG"); // to match (translations) json files

extension LanguageTypeExtension on LanguageType {
  String getValue() {
    switch (this) {
      case LanguageType.ENGLISH:
        return ENGLISH;
      case LanguageType.ARABIC:
        return ARABIC;
    }
  }
}
