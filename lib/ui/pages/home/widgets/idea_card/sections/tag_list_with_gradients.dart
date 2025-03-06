import 'package:creator_planner/data/view_models/draft_idea_view_model.dart';
import 'package:creator_planner/data/view_models/idea_view_model.dart';
import 'package:creator_planner/data/models/idea_tag.dart';
import 'package:creator_planner/ui/widgets/keyword_item/small_keyword_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TagListWithGradients extends StatefulWidget {
  final String ideaId;
  final bool isDraft;
  const TagListWithGradients(
      {super.key, required this.ideaId, this.isDraft = false});

  @override
  State<TagListWithGradients> createState() => _TagListWithGradientsState();
}

class _TagListWithGradientsState extends State<TagListWithGradients> {
  final ScrollController _scrollController = ScrollController();
  bool showLeftGradient = false;
  bool showRightGradient = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateGradientVisibility);
  }

  void _updateGradientVisibility() {
    setState(() {
      showLeftGradient = _scrollController.offset > 0;
      showRightGradient =
          _scrollController.offset < _scrollController.position.maxScrollExtent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: Consumer(builder: (context, ref, child) {
              List<String> tagIds = widget.isDraft
                  ? ref.watch(draftIdeaViewModelProvider).draftIdea!.tagIds
                  : ref
                      .watch(ideaViewModelProvider)
                      .ideas
                      .firstWhere((idea) => idea.id == widget.ideaId)
                      .tagIds;

              List<IdeaTag> ideaTags = widget.isDraft
                  ? ref
                      .watch(draftIdeaViewModelProvider)
                      .draftIdeaTags
                      .where((ideaTag) => tagIds.contains(ideaTag.id))
                      .toList()
                  : ref
                      .watch(ideaViewModelProvider)
                      .ideaTags
                      .where((ideaTag) => tagIds.contains(ideaTag.id))
                      .toList();

              return Stack(children: [
                if (ideaTags.isNotEmpty)
                  ListView.builder(
                      controller: _scrollController,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: ideaTags.length,
                      itemBuilder: (context, index) {
                        IdeaTag ideaTag = ideaTags[index];
                        return Row(
                          children: [
                            SmallKeywordItem(ideaTag: ideaTag),
                            SizedBox(width: 6),
                          ],
                        );
                      }),
                if (showLeftGradient)
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    width: 30,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            const Color.fromARGB(255, 255, 255, 255),
                            const Color.fromARGB(0, 255, 255, 255),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (showRightGradient)
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    width: 30,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [
                            const Color.fromARGB(255, 255, 255, 255),
                            const Color.fromARGB(0, 255, 255, 255),
                          ],
                        ),
                      ),
                    ),
                  )
              ]);
            }),
          ),
        ],
      ),
    );
  }
}
