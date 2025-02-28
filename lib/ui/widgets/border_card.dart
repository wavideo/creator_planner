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
      shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColor.containerGray20.of(context).withValues(alpha: 0.6)),
          borderRadius: BorderRadius.circular(borderRadius ?? 14)),
      elevation: 6,
      shadowColor: Colors.black.withValues(alpha: 0.4),
      color: Colors.white,
      child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: paddingHorizontal ?? 0,
              vertical: paddingVertical ?? 24),
          child: child),
    );
  }
}
