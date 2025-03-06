import 'package:creator_planner/data/view_models/idea_view_model.dart';
import 'package:creator_planner/data/models/idea.dart';
import 'package:creator_planner/ui/pages/home/widgets/idea_card.dart';
import 'package:creator_planner/ui/pages/home/widgets/change_order_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class IdeaList extends ConsumerStatefulWidget {
  const IdeaList({
    super.key,
    required this.isGridView,
  });
  final bool isGridView; // gridView <-> listView 스위칭

  @override
  ConsumerState<IdeaList> createState() => _IdeaListState();
}

class _IdeaListState extends ConsumerState<IdeaList> {
  ScrollController _scrollController = ScrollController(); // 최상단 자동 스크롤 기능

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

// DIVIDER:

  @override
  Widget build(BuildContext context) {
    // 최상단 자동 스크롤 기능
    ref.listen<List<Idea>>(
      ideaViewModelProvider.select((viewModel) => viewModel.ideas),
      (previous, next) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0.0,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
    );
    // 데이터 Stream + order순 정렬
    var ideasState = ref.watch(ideaViewModelProvider).ideas;
    List<Idea> sortedIdea = List<Idea>.from(ideasState)
      ..sort((a, b) => b.order.compareTo(a.order));
 
    return MasonryGridView.count(
      crossAxisCount: widget.isGridView ? 2 : 1, // GridView <-> ListView 스위칭
      controller: _scrollController,
      mainAxisSpacing: 6.0,
      crossAxisSpacing: 6.0,
      itemCount: sortedIdea.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          child: IdeaCard(idea: sortedIdea[index], isGridView: widget.isGridView),
          onLongPress: () {
            showChangeOrderBottomSheet(context, sortedIdea, index); // 길게 누르면 -> 순서 변경
          },
        );
      },
    );
  }
}