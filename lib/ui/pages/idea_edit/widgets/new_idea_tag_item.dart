import 'package:creator_planner/core/config/theme/colors.dart';
import 'package:creator_planner/data/models/idea_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class NewIdeaTagItem extends StatelessWidget {
  final IdeaTag ideaTag;
  const NewIdeaTagItem({super.key, required this.ideaTag});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 0),
          decoration: BoxDecoration(
            color: AppColor.lightGray10.of(context),
            borderRadius: BorderRadius.circular(100),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 4,),
              Text(
                ideaTag.name,
                style: TextStyle(
                    color: AppColor.gray30.of(context),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 12, right: 0, top: 12, bottom: 12),
                child: Icon(Icons.cancel,
                    color: AppColor.gray30.of(context), size: 16),
              )
            ],
          )),
    );
  }
}

class AddIdeaTagItem extends StatelessWidget {
  final IdeaTag ideaTag;
  const AddIdeaTagItem({super.key, required this.ideaTag});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColor.lightGray20.of(context),
              width: 1,
            ),
            // color: AppColor.lightGray10.of(context),
            borderRadius: BorderRadius.circular(100),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                  padding: const EdgeInsets.only(
                      left: 0, right: 10, top: 10, bottom: 10),
                  child: Icon(
                    Icons.add, size: 18,
                    color: AppColor.lightGray30.of(context),
                  )),
              Text(
                ideaTag.name,
                style: TextStyle(
                    color: AppColor.lightGray30.of(context),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(width: 4,)
            ],
          )),
    );
  }
}
