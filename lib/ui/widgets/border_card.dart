import 'package:creator_planner/core/theme/colors.dart';
import 'package:flutter/material.dart';

class BorderCard extends StatelessWidget {
  final Widget child;
  final double? borderRadius;
  final double? paddingVertical;
  final double? paddingHorizontal;
  const BorderCard(
      {required this.child,
      super.key,
      this.borderRadius,
      this.paddingVertical,
      this.paddingHorizontal});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColor.containerGray20.of(context).withValues(alpha: 0.8)),
          borderRadius: BorderRadius.circular(borderRadius ?? 10)),
      elevation: 6,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      color: Colors.white,
      child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: paddingHorizontal ?? 16,
              vertical: paddingVertical ?? 14),
          child: child),
    );
  }
}
