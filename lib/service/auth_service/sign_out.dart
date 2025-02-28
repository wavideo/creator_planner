import 'package:creator_planner/data/idea_view_model.dart';
import 'package:creator_planner/data/models/idea.dart';
import 'package:creator_planner/data/models/idea_tag.dart';
import 'package:creator_planner/ui/pages/auth/%08auth_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> signOut(BuildContext context, WidgetRef ref) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await ref.read(ideaViewModelProvider.notifier).ideasStream?.cancel();
      await ref.read(ideaViewModelProvider.notifier).ideaTagsStream?.cancel();
      if (user.isAnonymous) {
        List<Idea> ideas = ref.read(ideaViewModelProvider).ideas.toList();
        List<IdeaTag> ideaTags =
            ref.read(ideaViewModelProvider).ideaTags.toList();
        for (var idea in ideas) {
          await ref.read(ideaViewModelProvider.notifier).deleteIdea(idea);
        }
        for (var ideaTag in ideaTags) {
          await ref.read(ideaViewModelProvider.notifier).deleteIdeaTag(ideaTag);
        }
        await user.delete(); // 익명 계정 삭제
        print("익명 계정 삭제 완료");
      } else {
        await FirebaseAuth.instance.signOut(); // 로그아웃
      }
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
