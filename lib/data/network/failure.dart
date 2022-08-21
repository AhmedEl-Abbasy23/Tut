import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_advanced/data/network/error_handler.dart';

class Failure {
  int code; // 200
  String message; // error or success

  Failure(this.code, this.message);
}

class DefaultFailure extends Failure {
  DefaultFailure() : super(ResponseCode.DEFAULT, ResponseMessage.DEFAULT.tr());
}
