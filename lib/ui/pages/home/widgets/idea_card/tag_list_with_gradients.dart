import 'package:creator_planner/core/config/theme/colors.dart';
import 'package:creator_planner/data/app_view_model.dart';
import 'package:creator_planner/data/models/idea_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TagListWithGradients extends StatefulWidget {
  final String ideaId;
  const TagListWithGradients({super.key, required this.ideaId});

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
    return Expanded(
      child: Consumer(builder: (context, ref, child) {
        List<String> tagIds = ref
            .watch(appViewModelProvider)
            .ideas
            .firstWhere((idea) => idea.id == widget.ideaId)
            .tagIds;
        List<IdeaTag> ideaTags = ref
            .watch(appViewModelProvider)
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
                  return IdeaTagItem(ideaTag: ideaTag);
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
    );
  }
}

class IdeaTagItem extends StatelessWidget {
  final IdeaTag ideaTag;
  const IdeaTagItem({super.key, required this.ideaTag});

  @override
  Widget build(BuildContext context) {

    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(right: 6),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: AppColor.lightGray10.of(context),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          ideaTag.name,
          style: TextStyle(
              color: AppColor.gray10.of(context),
              fontSize: 12,
              fontWeight: FontWeight.w600),
        ));
  }
}
