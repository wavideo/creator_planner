import 'package:creator_planner/core/config/theme/colors.dart';
import 'package:creator_planner/core/utils/%08format_util.dart';
import 'package:flutter/material.dart';

class IdeaDetailSection extends StatelessWidget {
  final String title;
  final String content;
  final String? tag;
  final int? targetViews;
  // '엔비디아 관련 콘텐츠'
  // '어떤어떤 방식으로 제작하고 어떤어떤방시긍로 제작한다음엔 어떤어떤 방시긍로 제작하면 재미있을것 같다.떤 방식으로 제작하고 어떤어떤방시긍로 제작한다음엔 어떤어떤 방시긍로 제작하면 재미있을것 같다.떤 방식으로 제작하고 어떤어떤방시긍로 제작한다음엔 것 같다...'
  const IdeaDetailSection({
    super.key,
    required this.title,
    required this.content,
    this.tag,
    this.targetViews,
  });

  @override
  Widget build(BuildContext context) {
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
              child: Text(content,
                  style: TextStyle(
                      fontSize: 14, color: AppColor.gray20.of(context)),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
        if (tag != null && targetViews != null)
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (tag != null) groupTag(context, tag: tag!),
                Spacer(),
                if (targetViews != null)
                  groupTargetViews(context,
                      goal: '${formatCompactNumber(targetViews!)}뷰'),
                SizedBox(width: 10),
              ],
            ),
          )
      ],
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

  Row groupTargetViews(BuildContext context, {required String goal}) {
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
