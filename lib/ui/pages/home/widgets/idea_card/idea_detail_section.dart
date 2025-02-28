import 'package:creator_planner/core/theme/colors.dart';
import 'package:creator_planner/core/utils/format_util.dart';
import 'package:creator_planner/data/view_models/idea_view_model.dart';
import 'package:creator_planner/data/models/idea.dart';
import 'package:creator_planner/ui/pages/home/widgets/idea_card/tag_list_with_gradients.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IdeaDetailSection extends StatefulWidget {
  final Idea idea;

  IdeaDetailSection({super.key, required this.idea});

  @override
  State<IdeaDetailSection> createState() => _IdeaDetailSectionState();
}

class _IdeaDetailSectionState extends State<IdeaDetailSection> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(widget.idea.title,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            if (widget.idea.content != null)
              Column(
                children: [
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(widget.idea.content ?? '',
                            style: TextStyle(
                                fontSize: 14, color: AppColor.gray20.of(context)),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ],
              ),
            if (widget.idea.tagIds.isNotEmpty || widget.idea.targetViews != null)
              Container(
                padding: const EdgeInsets.only(top: 20.0),
                height: 50,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TagListWithGradients(ideaId: widget.idea.id, isDraft: false),
                    SizedBox(width: 30),
                    if (widget.idea.targetViews != null)
                      groupTargetViews(context, targetViews: widget.idea.targetViews!),
                    SizedBox(width: 10),
                  ],
                ),
              )
          ],
        );
      }
    );
  }

  Row groupTargetViews(BuildContext context, {required int targetViews}) {
    return Row(
      children: [
        Icon(Icons.flag, size: 20, color: AppColor.primaryBlue.of(context)),
        SizedBox(width: 4),
        Text('${formatCompactNumber(targetViews)}뷰',
            style: TextStyle(
                color: AppColor.primaryBlue.of(context),
                fontSize: 14,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}
