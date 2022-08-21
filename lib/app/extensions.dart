// extension on String
import 'package:flutter_advanced/app/constant.dart';

extension NonNullString on String? {
  String orEmpty() {
    // if the string value = null return ''.
    if (this == null) {
      return Constant.empty;
    } else {
      return this!;
    }
  }
}

// extension on Integer
extension NonNullInt on int? {
  int orZero() {
    // if the integer value = null return 0.
    if (this == null) {
      return Constant.zero;
    } else {
      return this!;
    }
  }
}
