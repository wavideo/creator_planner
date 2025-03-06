import 'package:creator_planner/core/theme/colors.dart';
import 'package:creator_planner/data/models/idea_tag.dart';
import 'package:flutter/material.dart';

class SmallKeywordItem extends StatelessWidget {
  final IdeaTag ideaTag;
  const SmallKeywordItem({super.key, required this.ideaTag});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColor.lightGray10.of(context),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            ideaTag.name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: AppColor.gray10.of(context),
                fontSize: 12,
                fontWeight: FontWeight.w600),
          )),
    );
  }
}
