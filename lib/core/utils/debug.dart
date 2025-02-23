import 'dart:math';

import 'package:logger/logger.dart';

void customLog(
  String message, {
  String? memo,
  bool isSuccess = false,
}) {
  if (isSuccess) {
    Logger().d('$message 완료');
  } else {
    Logger().e('$message  실패', error: e);
    throw Exception("$message 과정에 문제가 발생했습니다. $memo 에러: $e");
  }
}

void tryCatch(
  String message,
  Function() code, {
  String? memo,
}) {
  try {
    code();
    Logger().d('$message 완료');
  } catch (e) {
    Logger().e('$message  실패', error: e);
    throw Exception("$message 과정에 문제가 발생했습니다. $memo 에러: $e");
  }
}
