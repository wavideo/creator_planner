import 'package:creator_planner/core/theme/colors.dart';
import 'package:flutter/material.dart';

class CustomBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  const CustomBox(
      {required this.icon,
      required this.title,
      required this.child,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColor.containerLightGray30.of(context),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(icon,
                      size: 20, color: AppColor.gray20.of(context)),
                  SizedBox(width: 6),
                  Text(title,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColor.gray20.of(context)))
                ],
              ),
              SizedBox(height: 20),
              child
            ],
          )),
    );
  }
}
