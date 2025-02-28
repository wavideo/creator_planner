import 'package:creator_planner/data/idea_view_model.dart';
import 'package:creator_planner/ui/pages/auth/%08auth_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> signOut(BuildContext context, WidgetRef ref) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (user.isAnonymous) {
        await user.delete(); // 익명 계정 삭제
        print("익명 계정 삭제 완료");
      }

      await ref.read(ideaViewModelProvider.notifier).ideasStream?.cancel();
      await ref.read(ideaViewModelProvider.notifier).ideaTagsStream?.cancel();
      
      await FirebaseAuth.instance.signOut(); // 로그아웃
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AuthPage(), // 로그인 화면으로 이동
        ),
      );
      print("로그아웃 완료");
    }
  } catch (e) {
    print("로그아웃 또는 계정 삭제 실패: $e");
  }
}
