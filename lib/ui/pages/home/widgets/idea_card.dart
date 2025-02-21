import 'package:creator_planner/theme/colors.dart';
import 'package:creator_planner/ui/pages/home/widgets/reference_video_section.dart';
import 'package:creator_planner/ui/pages/home/widgets/title_thumbnail_section.dart';
import 'package:creator_planner/ui/widgets/border_card.dart';
import 'package:flutter/material.dart';

class IdeaCard extends StatelessWidget {
  final String ideaId;
  const IdeaCard({
    required this.ideaId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: BorderCard(
        paddingHorizontal: 20,
        paddingVertical: 20,
        child: Column(
          children: [
            groupIdeaColumn(context),
            groupTagAndGoalRow(context),
            TitleThumbnailSection(context: context),
            ReferenceVideoSection(views: 2200000, subscribers: 1000000),
          ],
        ),
      ),
    );
  }

  Column groupIdeaColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text('엔비디아 관련 콘텐츠',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Text(
                  '어떤어떤 방식으로 제작하고 어떤어떤방시긍로 제작한다음엔 어떤어떤 방시긍로 제작하면 재미있을것 같다.떤 방식으로 제작하고 어떤어떤방시긍로 제작한다음엔 어떤어떤 방시긍로 제작하면 재미있을것 같다.떤 방식으로 제작하고 어떤어떤방시긍로 제작한다음엔 것 같다...',
                  style: TextStyle(
                      fontSize: 14, color: AppColor.gray20.of(context)),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ],
    );
  }

  Widget groupTagAndGoalRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          groupTag(context, tag: '태그'),
          Spacer(),
          groupGoal(context, goal: '1.5만뷰'),
          SizedBox(width: 10),
        ],
      ),
    );
  }

  Container groupTag(BuildContext context, {required String tag}) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6), // 안쪽 여백
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColor.gray10.of(context),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          tag,
          style: TextStyle(
              color: AppColor.gray10.of(context),
              fontSize: 13,
              fontWeight: FontWeight.w600),
        ));
  }

  Row groupGoal(BuildContext context, {required String goal}) {
    return Row(
      children: [
        Icon(Icons.flag, size: 20, color: AppColor.primaryBlue.of(context)),
        SizedBox(width: 4),
        Text(goal,
            style: TextStyle(
                color: AppColor.primaryBlue.of(context),
                fontSize: 14,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}
