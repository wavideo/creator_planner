import 'package:creator_planner/theme/colors.dart';
import 'package:creator_planner/ui/pages/home/widgets/views_ratio_indicator.dart';
import 'package:creator_planner/ui/widgets/section_with_title.dart';
import 'package:creator_planner/utils/number_util.dart';
import 'package:flutter/material.dart';

class ReferenceVideoSection extends StatelessWidget {
  final int views;
  final int subscribers;

  const ReferenceVideoSection({
    required this.views,
    required this.subscribers,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double ratio = views / subscribers;

    return SectionWithTitle(
      icon: Icons.search,
      title: '리서치',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          groupVideoRow(context),
          SizedBox(height: 20),
          groupViewsRow(context, views: views, subscribers: subscribers),
          SectionWithTitle(icon: Icons.search, title: '리서치 : 구독자 대비 성과', child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ViewsRatioIndicator(ratio: ratio),
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
              Text('엔비디아  폭삭 망sadfgasdgdsagssdgsdags한 이뉴는?!',
                  style: TextStyle(fontSize: 15),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              SizedBox(height: 10),
              Text('15일 전',
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
                                  text: '${formatNumber(views)}',
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
                                  text: '${formatNumber(subscribers)}',
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
