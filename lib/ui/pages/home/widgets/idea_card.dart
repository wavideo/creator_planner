import 'package:creator_planner/data/draft_idea_view_model.dart';
import 'package:creator_planner/data/idea_view_model.dart';
import 'package:creator_planner/data/models/idea.dart';
import 'package:creator_planner/data/models/idea_tag.dart';
import 'package:creator_planner/ui/pages/home/widgets/idea_card/idea_detail_section.dart';
import 'package:creator_planner/ui/pages/home/widgets/idea_card/research_section.dart';
import 'package:creator_planner/ui/pages/home/widgets/idea_card/prototype_section.dart';
import 'package:creator_planner/ui/pages/home/widgets/idea_card/task_schedule_section.dart';
import 'package:creator_planner/ui/pages/idea_edit/idea_edit_page.dart';
import 'package:creator_planner/ui/widgets/border_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class IdeaCard extends StatelessWidget {
  final Idea idea;
  const IdeaCard({
    required this.idea,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPrototype = false;
    final bool isResearch = false;
    final bool isTask = false;

    return Consumer(builder: (context, ref, child) {
      return GestureDetector(
        onTap: () {
          ref.read(draftIdeaViewModelProvider.notifier).startIdea(idea);

          List<IdeaTag> ideaTags = ref.read(ideaViewModelProvider).ideaTags;
          ref.read(draftIdeaViewModelProvider.notifier).startIdeaTag(ideaTags);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      IdeaEditPage(
                        key: ideaEditPageKey, 
                      idea: idea)));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: BorderCard(
            paddingHorizontal: 20,
            paddingVertical: 20,
            child: Column(
              children: [
                IdeaDetailSection(idea: idea),
                if (isPrototype)
                  PrototypeSection(
                      title: '내가 정한 이름',
                      channelName: '내 채널',
                      targetViews: 13004),
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
        ),
      );
    });
  }
}
