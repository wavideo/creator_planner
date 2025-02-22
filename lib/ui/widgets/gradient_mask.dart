import 'package:flutter/material.dart';

class GradientMask extends StatelessWidget {
  final Widget child;
  final List<double> stops;

  const GradientMask({
    required this.child,
    this.stops = const [0.0, 0.8, 1.0], // 기본값 제공
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.black, // 왼쪽: 완전 보임
            Colors.black, // 중간: 유지
            Colors.transparent, // 오른쪽 끝: 점점 사라짐
          ],
          stops: stops, // 커스텀 가능
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: child,
    );
  }
}