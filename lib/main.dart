import 'package:creator_planner/core/config/theme/colors.dart';
import 'package:creator_planner/core/config/theme/theme.dart';
import 'package:creator_planner/ui/pages/auth/%08auth_page.dart';
import 'package:creator_planner/ui/pages/home/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 엔진 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('ko');
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: AuthPage(),
      home: const SplashScreen(),
      theme: lightTheme.copyWith(
        extensions: [AppColors.lightColorScheme],
      ), // 기본 라이트 테마
      darkTheme: darkTheme.copyWith(
        extensions: [AppColors.darkColorScheme],
      ), // 다크 테마
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  // 로그인 상태 확인
  void _checkAuthStatus() async {
    // FirebaseAuth의 authStateChanges로 로그인 상태를 확인
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (mounted) {
        if (user == null) {
          // 계정 정보가 없으면 로그인 화면으로
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AuthPage()),
          );
        } else {
          // 계정 정보가 있으면 홈 화면으로
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // 로딩 인디케이터 표시
      ),
    );
  }
}
