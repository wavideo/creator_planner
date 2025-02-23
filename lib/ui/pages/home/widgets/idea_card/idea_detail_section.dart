import 'package:creator_planner/core/config/theme/colors.dart';
import 'package:creator_planner/core/utils/format_util.dart';
import 'package:creator_planner/data/app_view_model.dart';
import 'package:creator_planner/data/mock_data.dart';
import 'package:creator_planner/data/models/idea.dart';
import 'package:creator_planner/ui/pages/home/widgets/idea_card/tag_list_with_gradients.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IdeaDetailSection extends StatefulWidget {
  final String id;

  IdeaDetailSection({super.key, required this.id});

  @override
  State<IdeaDetailSection> createState() => _IdeaDetailSectionState();
}

class _IdeaDetailSectionState extends State<IdeaDetailSection> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        Idea idea = ref.watch(appViewModelProvider).ideas.firstWhere((idea) => idea.id == widget.id);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(idea.title,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            if (idea.content != null)
              Column(
                children: [
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(idea.content ?? '',
                            style: TextStyle(
                                fontSize: 14, color: AppColor.gray20.of(context)),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ],
              ),
            if (idea.tagIds.isNotEmpty || idea.targetViews != null)
              Container(
                padding: const EdgeInsets.only(top: 20.0),
                height: 50,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TagListWithGradients(ideaId: idea.id),
                    SizedBox(width: 30),
                    if (idea.targetViews != null)
                      groupTargetViews(context, targetViews: idea.targetViews!),
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
