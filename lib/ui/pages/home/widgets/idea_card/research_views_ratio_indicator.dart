import 'dart:math';

import 'package:creator_planner/core/config/theme/colors.dart';
import 'package:flutter/material.dart';

class ResearchViewsRatioIndicator extends StatelessWidget {
  final double ratio;
  const ResearchViewsRatioIndicator({
    required this.ratio,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var primaryColor = switch (ratio) {
      <= 0.8 => AppColor.gray20.of(context),
      <= 1.2 => AppColor.gray30.of(context),
      <= 1.9 => AppColor.containerRed30.of(context),
      _ => AppColor.primaryRed.of(context),
    };
    var color = AppColor.lightGray20.of(context);

    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.local_fire_department,
              color: primaryColor,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  groupValue(context,
                      isViews: false,
                      ratio: ratio,
                      color: color,
                      primaryColor: primaryColor),
                  groupValue(context,
                      isViews: true,
                      ratio: ratio,
                      color: color,
                      primaryColor: primaryColor),
                  LinearProgressIndicator(
                    value: ratio < 1 ? ratio : 1,
                    valueColor: AlwaysStoppedAnimation(primaryColor),
                    backgroundColor: color,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
            RichText(
              text: TextSpan(
                  text: '${ratio<0.05 ? (ratio * 1000).round()/10 : (ratio * 20).round() * 5}%',
                  style: TextStyle(
                      fontSize: 17,
                      color: primaryColor,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ],
    );
  }

  SizedBox groupValue(BuildContext context,
      {required bool isViews,
      required double ratio,
      required Color color,
      required Color primaryColor}) {
    int ratioInt = (ratio * 100).round();

    int leftFlex = isViews
        ? ratioInt.clamp(1, 100)
        : ratioInt >= 100
            ? (10000 / ratioInt).round().clamp(1, 100)
            : 100;

    int rightFlex = max(1, 100 - leftFlex);

    return SizedBox(
      width: double
          .infinity, // Set a specific width or leave it as infinity for flexible layouts
      child: Row(
        children: [
          Spacer(flex: leftFlex),
          Visibility(
            visible: isViews,
            replacement: Column(
              children: [
                SizedBox(height: 30),
                SizedBox(
                  height: 14,
                  child: VerticalDivider(
                    width: 1,
                    thickness: 1.5,
                    color: color,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.people, color: color, size: 16),
                  ],
                )
              ],
            ),
            child: Column(
              children: [
                Icon(Icons.bar_chart, color: primaryColor, size: 16),
                SizedBox(
                  height: 14,
                  child: VerticalDivider(
                    width: 1,
                    thickness: 1.5,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
          Spacer(flex: rightFlex),
        ],
      ),
    );
  }
}
