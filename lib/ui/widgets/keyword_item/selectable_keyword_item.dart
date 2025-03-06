import 'package:creator_planner/core/theme/colors.dart';
import 'package:creator_planner/data/models/idea_tag.dart';
import 'package:creator_planner/ui/pages/idea_edit/idea_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectableKeywordItem extends StatelessWidget {
  final IdeaTag ideaTag;
  const SelectableKeywordItem({super.key, required this.ideaTag});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return GestureDetector(
        onTap: () {
          ideaEditPageKey.currentState
              ?.createTagAndUpdateTagList(id: ideaTag.id);
        },
        child: IntrinsicWidth(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColor.lightGray20.of(context),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 0, right: 4, top: 8, bottom: 8),
                      child: Icon(
                        Icons.add,
                        size: 14,
                        color: AppColor.lightGray30.of(context),
                      )),
                  Expanded(
                    child: Text(
                      ideaTag.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: AppColor.lightGray30.of(context),
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  )
                ],
              )),
        ),
      );
    });
  }
}
