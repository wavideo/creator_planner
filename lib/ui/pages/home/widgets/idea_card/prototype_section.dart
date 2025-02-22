import 'package:creator_planner/core/config/theme/colors.dart';
import 'package:creator_planner/core/utils/%08format_util.dart';
import 'package:creator_planner/ui/widgets/section_with_title.dart';
import 'package:flutter/material.dart';

class PrototypeSection extends StatelessWidget {
  final String title;
  final String channelName;
  final int targetViews;
  final DateTime uploadDate;


  PrototypeSection({
    super.key,
    required this.title,
    required this.channelName,
    required this.targetViews,
    DateTime?uploadDate,
  }): uploadDate = uploadDate ?? DateTime.now().subtract(Duration(days: 7));

  @override
  Widget build(BuildContext context) {
    return SectionWithTitle(
      title: '프로토타입',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: AppColor.lightGray20.of(context),
            ),
            child: AspectRatio(aspectRatio: 16 / 9, child: Container()),
          ),
          SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.lightGray20.of(context),
                ),
                child: AspectRatio(aspectRatio: 1, child: Container()),
              ),
              SizedBox(
                width: 14,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(fontSize: 15),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  SizedBox(height: 4),
                  Text.rich(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14, color: AppColor.gray20.of(context)),
                    TextSpan(children: [
                      TextSpan(text: channelName),
                      TextSpan(text: ' · '),
                      TextSpan(text: '조회수 ${formatCompactNumber(targetViews)}회'),
                      TextSpan(text: ' · '),
                      TextSpan(text: formatDateTimeDifference(uploadDate)),
                    ]),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
