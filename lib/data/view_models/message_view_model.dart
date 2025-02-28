import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageProvider extends StateNotifier<String> {
  MessageProvider() : super('');

  // 메시지 설정
  void setMessage(String message) {
    state = message;
    Future.delayed(Duration(seconds: 1), () {
      state = ''; // 1초 뒤에 실행
    });
  }
}

// 메시지 프로바이더
final homePageMessageProvider = StateNotifierProvider<MessageProvider, String>(
  (ref) => MessageProvider(),
);

final IdeaEditPageMessageProvider =
    StateNotifierProvider<MessageProvider, String>(
  (ref) => MessageProvider(),
);
