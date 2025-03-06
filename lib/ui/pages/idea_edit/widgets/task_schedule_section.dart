import 'package:creator_planner/core/utils/format_util.dart';
import 'package:creator_planner/ui/widgets/section_with_title.dart';
import 'package:flutter/material.dart';

class TaskScheduleSection extends StatelessWidget {
  const TaskScheduleSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SectionWithTitle(
        title: '제작 일정',
        child: Column(children: [
          TaskItem(
              signatureColor: Colors.teal,
              icon: Icons.camera,
              type: '녹화',
              title: '1회차 촬영',
              dateTime: getDateOnly(DateTime.now().add(Duration(days: 3)))),
          TaskItem(
              signatureColor: Colors.purple,
              icon: Icons.cut,
              type: '편집',
              title: '1회차 촬영',
              dateTime: DateTime.now().add(Duration(days: 4))),
          TaskItem(
              signatureColor: Colors.red,
              icon: Icons.upload,
              type: '업로드',
              title: '1회차 촬영',
              dateTime: DateTime.now().add(Duration(days: 5, hours: 1, minutes: 30))),
        ]));
  }
}

class TaskItem extends StatelessWidget {
  const TaskItem({
    super.key,
    required this.signatureColor,
    required this.icon,
    required this.type,
    required this.title,
    this.dateTime,
  });

  final Color signatureColor;
  final IconData icon;
  final String type;
  final String title;
  final DateTime? dateTime;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minTileHeight: 12,
      contentPadding: EdgeInsets.zero,
      leading: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: signatureColor.withValues(alpha: 0.2)),
          child: Icon(icon, color: signatureColor)),
      title: Text.rich(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          TextSpan(children: [
            TextSpan(
                text: type,
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: signatureColor)),
            TextSpan(text: '  '),
            TextSpan(text: title),
          ])),
      visualDensity: VisualDensity(vertical: 2),
      subtitle: Row(children: [
        Text(
          formatDateTime(dateTime) ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.grey),
        ),
        Spacer(),
        Text(
          formatDateTimeDifference(dateTime) ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
        ),
        SizedBox(width: 4)
      ]),
      onTap: () {},
    );
  }
}