import 'package:creator_planner/core/theme/colors.dart';
import 'package:creator_planner/data/view_models/draft_idea_view_model.dart';
import 'package:creator_planner/data/view_models/idea_view_model.dart';
import 'package:creator_planner/data/models/idea.dart';
import 'package:creator_planner/data/models/idea_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedKeywordItem extends StatelessWidget {
  final IdeaTag ideaTag;
  const SelectedKeywordItem({super.key, required this.ideaTag});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return IntrinsicWidth(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            decoration: BoxDecoration(
              color: AppColor.lightGray10.of(context),
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 2,
                ),
                Expanded(
                  child: Text(
                    ideaTag.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: AppColor.gray30.of(context),
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // sellected idea에서 제외
                    List<String> tagIds =
                        ref.read(draftIdeaViewModelProvider).draftIdea!.tagIds;
                    tagIds.removeWhere((id) => id == ideaTag.id);
                    Idea updatedIdea = ref
                        .read(draftIdeaViewModelProvider)
                        .draftIdea!
                        .copyWith(tagIds: tagIds);
                    ref
                        .read(draftIdeaViewModelProvider.notifier)
                        .updateIdea(updatedIdea);

                    // 기존 태그에 없던 신규 tag 폐기
                    List<IdeaTag> originIdeaTags =
                        ref.read(ideaViewModelProvider).ideaTags;
                    List<IdeaTag> sameTags = originIdeaTags
                        .where((tag) => tag.id == ideaTag.id)
                        .toList();
                    if (sameTags.isEmpty) {
                      ref
                          .read(draftIdeaViewModelProvider.notifier)
                          .deleteIdeaTag(ideaTag);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 0, top: 8, bottom: 8),
                    child: Icon(Icons.cancel,
                        color: AppColor.gray30.of(context), size: 16),
                  ),
                )
              ],
            )),
      );
    });
  }
}