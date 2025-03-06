import 'package:creator_planner/core/theme/colors.dart';
import 'package:creator_planner/core/utils/format_util.dart';
import 'package:creator_planner/data/view_models/draft_idea_view_model.dart';
import 'package:creator_planner/data/view_models/idea_view_model.dart';
import 'package:creator_planner/data/models/idea.dart';
import 'package:creator_planner/data/models/idea_tag.dart';
import 'package:creator_planner/ui/pages/home/widgets/idea_card/sections/tag_list_with_gradients.dart';
import 'package:creator_planner/ui/pages/idea_edit/idea_edit_page.dart';
import 'package:creator_planner/ui/widgets/border_card.dart';
import 'package:creator_planner/ui/widgets/keyword_item/small_keyword_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IdeaCard extends ConsumerWidget {
  final Idea idea;
  final bool isGridView;
  const IdeaCard({
    required this.idea,
    required this.isGridView,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        _navigateToEditPage(ref, context);
      },
      child: BorderCard(
        paddingHorizontal: 16,
        paddingVertical: 14,
        child: Column(
          children: [
            Consumer(builder: (context, ref, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 타이틀
                  Row(
                    children: [
                      Expanded(
                          child: Text(idea.title,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600)))
                    ],
                  ),
                  // 내용
                  if (idea.content != null)
                    Column(
                      children: [
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Text(idea.content ?? '',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: AppColor.gray20.of(context)),
                                  maxLines: 8,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      ],
                    ),
                  // 태그 & 목표
                  if (idea.tagIds.isNotEmpty || idea.targetViews != null)
                    Container(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Builder(builder: (context) {
                        return isGridView
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  groupTags(ref),
                                  SizedBox(height: 20),
                                  if (idea.targetViews != null)
                                    groupTargetViews(context,
                                        targetViews: idea.targetViews!),
                                ],
                              )
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(child: groupTags(ref)),
                                  SizedBox(width: 10),
                                  if (idea.targetViews != null)
                                    groupTargetViews(context,
                                        targetViews: idea.targetViews!),
                                ],
                              );
                      }),
                    )
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget groupTags(WidgetRef ref) {
    return Builder(builder: (context) {
      List<String> tagIds = ref
          .watch(ideaViewModelProvider)
          .ideas
          .firstWhere((item) => item.id == idea.id)
          .tagIds;

      List<IdeaTag> ideaTags = ref
          .watch(ideaViewModelProvider)
          .ideaTags
          .where((ideaTag) => tagIds.contains(ideaTag.id))
          .toList();

      return Wrap(
          spacing: 4,
          runSpacing: 4,
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ...List.generate(
              ideaTags.length,
              (index) => SmallKeywordItem(
                ideaTag: ideaTags[index],
              ),
            ),
          ]);
    });
  }

  Row groupTargetViews(BuildContext context, {required int targetViews}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(Icons.flag, size: 20, color: AppColor.primaryBlue.of(context)),
        SizedBox(width: 4),
        Text('${formatCompactNumber(targetViews)}뷰',
            style: TextStyle(
                color: AppColor.primaryBlue.of(context),
                fontSize: 14,
                fontWeight: FontWeight.w600)),
      ],
    );
  }

  void _navigateToEditPage(WidgetRef ref, BuildContext context) {
    ref.read(draftIdeaViewModelProvider.notifier).startIdea(idea.copyWith());

    List<IdeaTag> ideaTags = ref.read(ideaViewModelProvider).ideaTags.toList();
    ref.read(draftIdeaViewModelProvider.notifier).startIdeaTag(ideaTags);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                IdeaEditPage(key: ideaEditPageKey, idea: idea)));
  }
}
