import 'package:creator_planner/data/view_models/idea_view_model.dart';
import 'package:creator_planner/service/auth/sign_out_for_web.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:restart_app/restart_app.dart';

Future<void> signOut(BuildContext context, WidgetRef ref) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (user.isAnonymous) {
        ref.read(ideaViewModelProvider.notifier).clear(); // 데이터 삭제
        ref.read(ideaViewModelProvider.notifier).dispose(); // Stream 해제
        await user.delete(); // 익명 계정 삭제
      } else {
        ref.read(ideaViewModelProvider.notifier).dispose(); // Stream 해제
        await FirebaseAuth.instance.signOut(); // 일반 계정 로그아웃
      }

      if (kIsWeb) {
        // ! TODO:정상 작동 안함
        _webRefresh();
      } else {
        Restart.restartApp(
          notificationTitle: '로그아웃 완료',
          notificationBody: '로그아웃이 완료되었습니다.\n알림을 눌러 다시 로그인하세요',
        ); // 모바일에서는 앱을 재시작
      }
    }
  } catch (e) {
    Logger().e("로그아웃 또는 계정 삭제 실패: $e");
    Exception("로그아웃 또는 계정 삭제 과정에 문제가 발생했습니다. 에러: $e");
  }
}

void _webRefresh() {
  // `dart:html`을 직접 사용하면 앱 빌드 시 오류 발생하므로, `dynamic`으로 우회
  final htmlWindow = (kIsWeb ? (Uri.base) : null);
  if (htmlWindow != null) {
    // URL 새로고침 (현재 페이지 유지)
    // ignore: avoid_dynamic_calls
    (Uri.base).replace();
    // (htmlWindow as dynamic)
  }
}
