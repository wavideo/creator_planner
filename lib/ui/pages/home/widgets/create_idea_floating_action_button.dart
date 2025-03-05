import 'package:creator_planner/data/models/idea.dart';
import 'package:creator_planner/data/models/idea_tag.dart';
import 'package:creator_planner/data/view_models/draft_idea_view_model.dart';
import 'package:creator_planner/data/view_models/idea_view_model.dart';
import 'package:creator_planner/ui/pages/idea_edit/idea_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateIdeaFloatingActionButton extends ConsumerWidget {
  const CreateIdeaFloatingActionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            // 임시 게시글 생성
            var idea = Idea(title: '');
            ref.read(draftIdeaViewModelProvider.notifier).startIdea(idea);
    
            // 임시 태그리스트 생성
            List<IdeaTag> ideaTags =
                ref.read(ideaViewModelProvider).ideaTags.toList();
            ref
                .read(draftIdeaViewModelProvider.notifier)
                .startIdeaTag(ideaTags);
    
            // editPage로 이동
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return IdeaEditPage(
                  key: ideaEditPageKey, idea: idea, isCreated: true);
            }));
          },
        );
  }
}