import 'package:creator_planner/theme/colors.dart';
import 'package:flutter/material.dart';

class CustomBox2 extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  const CustomBox2(
      {required this.icon,
      required this.title,
      required this.child,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 22),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Divider(color: AppColor.lightGray10.of(context)),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            // Icon(icon,
            //     size: 20, color: AppColor.gray20.of(context)),
            // SizedBox(width: 6),
            Text(title,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColor.gray20.of(context)))
          ],
        ),
        SizedBox(height: 16),
        child
      ],
    );
  }
}
