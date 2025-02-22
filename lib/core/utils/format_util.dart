import 'package:intl/intl.dart';

// 숫자 쉼표 처리 : 1,540
String formatNumber(int number) {
  final formatter = NumberFormat('#,###');
  return formatter.format(number);
}

// 숫자 가독성 처리 : 1,500, 1.5만, 15만, 150만
String formatCompactNumber(int number) {
  if (number < 100) return '$number';
  if (number < 1000) return '${(number / 10).round() * 10}';
  if (number < 10000) return '${formatNumber((number / 100).round() * 100)}';
  if (number < 100000) {
    double value = (number / 1000).round() / 10;
    return value == value.toInt() ? '${value.toInt()}만' : '${value}만';
  }
  if (number < 1000000) return '${(number / 10000).round()}만';
  if (number < 10000000) return '${(number / 100000).round() * 10}만';
  if (number < 100000000)
    return '${formatNumber((number / 1000000).round() * 100)}만';
  return '${formatNumber((number / 100000000).floor())}억';
}

// DateTime을 자정 기준으로 '날짜'만 기록 (비교를 위해)
DateTime? getDateOnly(DateTime? dateTime) {
  if (dateTime == null) {
    return null;
  }
  return DateTime(dateTime.year, dateTime.month, dateTime.day);
}

// 날짜만 가진 정보인지 확인
bool isDateOnly(DateTime? dateTime) {
  if (dateTime == null) {
    return false;
  }
  return dateTime.hour == 0 && dateTime.minute == 0 && dateTime.second == 0;
}

// 날짜 표기 : 24.03.18 (목) 오전 3:30
String? formatDateTime(DateTime? dateTime) {
  if (dateTime == null) {
    return null;
  }
  return isDateOnly(dateTime)
      ? DateFormat('yy.MM.dd (E)', 'ko_KR').format(dateTime)
      : DateFormat('yy.MM.dd (E) a h:mm', 'ko_KR').format(dateTime);
}

// 날짜 디데이 : D-3
String? formatDDay(DateTime? dateTime) {
  if (dateTime == null) {
    return null;
  }
  int dateDifference =
      getDateOnly(dateTime)!.difference(getDateOnly(DateTime.now())!).inDays;

  if (dateDifference == 0) {
    return 'D-day';
  } else if (dateDifference > 0) {
    return 'D-$dateDifference';
  } else {
    return 'D+${dateDifference.abs()}';
  }
}

// 날짜 디데이 : 3일 후, 4주 전
String? formatDateTimeDifference(DateTime? dateTime) {
  if (dateTime == null) {
    return null;
  }
  Duration difference = dateTime.difference(DateTime.now());
  Duration dateDifference =
      getDateOnly(dateTime)!.difference(getDateOnly(DateTime.now())!);

  // 차이를 절대값으로 계산하여 분, 시간, 일, 주, 월, 년 계산
  int seconds = difference.inSeconds.abs();
  int minutes = difference.inMinutes.abs();
  int hours = difference.inHours.abs();
  int days = dateDifference.inDays.abs();

  // 만약 차이가 음수라면 '전', 양수라면 '후'를 붙여준다.
  String suffix = difference.isNegative ? '전' : '후';

  if (seconds < 60) {
    return dateDifference.isNegative ? '방금 전' : '지금';
  } else if (minutes < 60) {
    return '$minutes분 $suffix';
  } else if (hours < 24) {
    return '$hours시간 $suffix';
  } else if (days < 7) {
    return '$days일 $suffix';
  } else if (days < 30) {
    return '${(days / 7).floor()}주 $suffix';
  } else if (days < 365) {
    return '${(days / 30).floor()}개월 $suffix';
  } else {
    return '${(days / 365).floor()}년 $suffix';
  }
}
