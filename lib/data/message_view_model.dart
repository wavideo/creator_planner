import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageProvider extends StateNotifier<String> {
  MessageProvider() : super('');

  // 메시지 설정
  void setMessage(String message) {
    state = message;
  }

  // 메시지 삭제
  void clearMessage() {
    state = '';
  }
}

// 메시지 프로바이더
final homePageMessageProvider = StateNotifierProvider<MessageProvider, String>(
  (ref) => MessageProvider(),
);

final xxxPageMessageProvider = StateNotifierProvider<MessageProvider, String>(
  (ref) => MessageProvider(),
);