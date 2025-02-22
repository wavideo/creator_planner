import 'package:creator_planner/core/config/theme/colors.dart';
import 'package:creator_planner/data/mock_data.dart';
import 'package:creator_planner/data/models/idea_tag.dart';
import 'package:flutter/material.dart';

class TagListWithGradients extends StatefulWidget {
  final List<String> tagIds;
  const TagListWithGradients({super.key, required this.tagIds});

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
      child: Stack(children: [
        if (widget.tagIds.isNotEmpty)
          ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: widget.tagIds.length,
              itemBuilder: (context, index) {
                String id = widget.tagIds[index];
                return IdeaTagItem(id: id);
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
      ]),
    );
  }
}

class IdeaTagItem extends StatelessWidget {
  final String id;
  const IdeaTagItem({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    IdeaTag tag = mockTags.firstWhere((tag) => tag.id == id,
        orElse: () => IdeaTag(name: ''));

    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(right: 6),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: AppColor.lightGray10.of(context),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          tag.name,
          style: TextStyle(
              color: AppColor.gray10.of(context),
              fontSize: 12,
              fontWeight: FontWeight.w600),
        ));
  }
}
