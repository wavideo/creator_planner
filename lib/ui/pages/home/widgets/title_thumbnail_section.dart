import 'package:creator_planner/theme/colors.dart';
import 'package:creator_planner/ui/widgets/section_with_title.dart';
import 'package:flutter/material.dart';

class TitleThumbnailSection extends StatelessWidget {
  const TitleThumbnailSection({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return SectionWithTitle(
      icon: Icons.ads_click,
      title: '제목 · 썸네일',
      child: Row(
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
                Text('엔비디아  폭삭  이뉴는?!',
                    style: TextStyle(fontSize: 15),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
