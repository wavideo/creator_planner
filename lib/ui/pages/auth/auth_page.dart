import 'package:creator_planner/data/view_models/idea_view_model.dart';
import 'package:creator_planner/ui/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // firebase_auth 임포트

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              // 로그인 화면으로 이동
              _loginWithEmailPassword();
            },
            child: const Text("로그인"),
          ),
          ElevatedButton(
            onPressed: () {
              // 비회원으로 시작하기
              _signInAnonymously();
            },
            child: const Text("비회원으로 시작하기"),
          ),
        ],
      ),
    );
  }

  Future<void> _loginWithEmailPassword() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: "user@example.com", password: "password123");
      // 로그인 성공 후 데이터 처리
      print("로그인 성공: ${userCredential.user!.uid}");
    } catch (e) {
      print("로그인 실패: $e");
    }
  }

  Future<void> _signInAnonymously() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      // 익명 로그인 성공 후 데이터 처리
      print("익명 로그인 성공: ${userCredential.user!.uid}");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(), // HomePage는 로그인 후 이동할 페이지
        ),
      );
    } catch (e) {
      print("익명 로그인 실패: $e");
    }
  }
}
