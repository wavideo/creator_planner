import 'dart:js_interop_unsafe';

import 'package:creator_planner/data/idea_view_model.dart';
import 'package:creator_planner/ui/pages/auth/%08auth_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:restart_app/restart_app.dart';
import 'dart:html' as html;


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
        // 웹이라면 AuthPage로 라우팅 후 새로고침
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => AuthPage()));
        html.window.location.reload();
      } else {
        // 앱이라면 종료 후 재시작
        Restart.restartApp(
            notificationTitle: '로그아웃 완료',
            notificationBody: '로그아웃이 완료되었습니다.\n알림을 눌러 다시 로그인하세요');
      }
    }
  } catch (e) {
    Logger().e("로그아웃 또는 계정 삭제 실패: $e");
    Exception("로그아웃 또는 계정 삭제 과정에 문제가 발생했습니다. 에러: $e");
  }
}
