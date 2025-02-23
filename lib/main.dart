import 'package:creator_planner/core/config/theme/colors.dart';
import 'package:creator_planner/core/config/theme/theme.dart';
import 'package:creator_planner/ui/pages/home/home_page.dart';
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
      home: HomePage(),
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
