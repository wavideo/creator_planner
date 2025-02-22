import 'package:creator_planner/ui/pages/home/widgets/idea_card/idea_detail_section.dart';
import 'package:creator_planner/ui/pages/home/widgets/idea_card/research_section.dart';
import 'package:creator_planner/ui/pages/home/widgets/idea_card/prototype_section.dart';
import 'package:creator_planner/ui/pages/home/widgets/idea_card/task_schedule_section.dart';
import 'package:creator_planner/ui/widgets/border_card.dart';
import 'package:flutter/material.dart';

class IdeaCard extends StatelessWidget {
  final String id;
  const IdeaCard({
    required this.id,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPrototype = false;
    final bool isResearch = false;
    final bool isTask = false;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: BorderCard(
        paddingHorizontal: 20,
        paddingVertical: 20,
        child: Column(
          children: [
            IdeaDetailSection(id: id),
            if (isPrototype)
              PrototypeSection(
                  title: '내가 정한 이름', channelName: '내 채널', targetViews: 13004),
            if (isResearch)
              ResearchSection(
                  title: '반드시 봐야하는 인터넷 꿀팁 3가지',
                  channelName: '아정당',
                  views: 22232200,
                  subscribers: 1000000),
            if (isTask) TaskScheduleSection(),
          ],
        ),
      ),
    );
  }
}
