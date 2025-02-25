import 'package:flutter/material.dart';

class CustomSnackbar extends StatefulWidget {
  final String message;
  const CustomSnackbar({required this.message});

  @override
  State<CustomSnackbar> createState() => _CustomSnackbarState();
}

class _CustomSnackbarState extends State<CustomSnackbar> {
  double _topPosition = -150; // 초기 위치는 화면 밖

  @override
  void initState() {
    super.initState();
    // 애니메이션 시작: 위에서 아래로 내려옴
    Future.delayed(Duration(milliseconds: 100), () {
      // 딜레이를 조금 더 늘려보세요
      setState(() {
        _topPosition = 0; // 천장에 딱 붙는 위치
      });
    });

    // 300ms 후에 알림이 사라지도록 설정
    Future.delayed(Duration(milliseconds: 1200), () {
      setState(() {
        _topPosition = -150; // 알림을 화면 밖으로 밀어냄
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // 노치 높이 계산 (상단 여백)
    final double notchHeight = MediaQuery.of(context).padding.top;

    return AnimatedPositioned(
      duration: Duration(milliseconds: 500), // 애니메이션 시간
      curve: Curves.easeOutSine, // 부드러운 애니메이션
      top: _topPosition,
      left: 0,
      right: 0,
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.primaryDelta! < 0) {
            setState(() {
              _topPosition = -150; // 버튼을 눌러 알림을 제거
            });
          }
        },
        onVerticalDragEnd: (details) {
          if (_topPosition < 0) {
            _topPosition = -150; // 버튼을 눌러 알림을 제거
          }
        },
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            height: notchHeight + 60, // 높이 조정
            decoration: BoxDecoration(
              color: Colors.blue, // 아이폰 알림 스타일의 색상
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end, // 텍스트를 하단에 맞추기
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info, color: Colors.white), // 아이콘 (아이폰 알림 스타일)
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.message,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _topPosition = -150; // 버튼을 눌러 알림을 제거
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
