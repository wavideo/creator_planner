import 'package:creator_planner/core/config/theme/colors.dart';
import 'package:creator_planner/ui/pages/home/widgets/idea_card/research_views_ratio_indicator.dart';
import 'package:creator_planner/ui/widgets/section_with_title.dart';
import 'package:creator_planner/core/utils/%08format_util.dart';
import 'package:flutter/material.dart';

class ResearchSection extends StatelessWidget {
  final String title;
  final String channelName;
  final DateTime publishedAt;
  final int views;
  final int subscribers;

  ResearchSection({
    required this.title,
    required this.channelName,
    DateTime? publishedAt,
    required this.views,
    required this.subscribers,
    super.key,
  }) : publishedAt = publishedAt ?? DateTime.now().subtract(Duration(days: 3));

  @override
  Widget build(BuildContext context) {
    double ratio = views / subscribers;

    return SectionWithTitle(
      title: '리서치',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: AppColor.lightGray10.of(context).withValues(alpha: 0.3),
                border: Border.all(
                  color: AppColor.lightGray10.of(context),
                  width: 1,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                children: [
                  groupVideoRow(context),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(color: AppColor.lightGray10.of(context)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: ResearchViewsRatioIndicator(ratio: ratio),
                  ),
                  SizedBox(height: 20),
                  groupViewsRow(context,
                      views: views, subscribers: subscribers),
                ],
              )),
        ],
      ),
    );
  }

  Widget groupVideoRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: AppColor.lightGray20.of(context),
            ),
            child: AspectRatio(aspectRatio: 16 / 9, child: Container()),
          ),
        ),
        SizedBox(width: 12),
        Flexible(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(fontSize: 15),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              SizedBox(height: 10),
              Text('${formatDateTimeDifference(publishedAt)}',
                  style: TextStyle(
                      fontSize: 13, color: AppColor.gray20.of(context))),
            ],
          ),
        ),
      ],
    );
  }

  Widget groupViewsRow(BuildContext context,
      {required int views, required int subscribers}) {
    var color = AppColor.gray30.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
                flex: 5,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bar_chart, size: 20, color: color),
                      SizedBox(width: 8),
                      RichText(
                        text: TextSpan(
                            text: '조회수  ',
                            style: TextStyle(fontSize: 13, color: color),
                            children: [
                              TextSpan(
                                  text: '${formatCompactNumber(views)}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600))
                            ]),
                      ),
                    ])),
            SizedBox(
                height: 20,
                child: VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: AppColor.lightGray20.of(context))),
            Flexible(
                flex: 5,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.group, size: 20, color: color),
                      SizedBox(width: 8),
                      RichText(
                        text: TextSpan(
                            text: '구독자  ',
                            style: TextStyle(fontSize: 13, color: color),
                            children: [
                              TextSpan(
                                  text: '${formatCompactNumber(subscribers)}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600))
                            ]),
                      ),
                    ])),
          ],
        ),
      ],
    );
  }
}
