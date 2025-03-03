import 'package:creator_planner/core/theme/colors.dart';
import 'package:creator_planner/data/view_models/draft_idea_view_model.dart';
import 'package:creator_planner/data/view_models/idea_view_model.dart';
import 'package:creator_planner/data/view_models/message_view_model.dart';
import 'package:creator_planner/data/models/idea.dart';
import 'package:creator_planner/data/models/idea_tag.dart';
import 'package:creator_planner/service/auth/sign_out.dart';
import 'package:creator_planner/ui/pages/auth/%08auth_page.dart';
import 'package:creator_planner/ui/pages/home/widgets/idea_card.dart';
import 'package:creator_planner/ui/pages/idea_edit/idea_edit_page.dart';
import 'package:creator_planner/core/utils/custom_snackbar_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  ScrollController _scrollController = ScrollController();
  bool? isGridView;
  IconData? gridViewIcon;
  List<GlobalKey> globalKeys = [];

  @override
  void initState() {
    super.initState();
    isGridView = true;
    gridViewIcon = Icons.grid_view;
    _scrollController = ScrollController();
    globalKeys = List.generate(0, (_) => GlobalKey());
  }

  @override
  Widget build(BuildContext context) {
    final message = ref.watch(homePageMessageProvider);
    showCustomSnackbar(message: message, context: context);

    return Scaffold(
      backgroundColor: AppColor.containerWhite.of(context),
      appBar: AppBar(centerTitle: true, title: Text('아이디어 보드'), actions: [
        IconButton(
          icon: Icon(gridViewIcon),
          onPressed: () {
            setState(() {
              if (isGridView!) {
                isGridView = false;
                gridViewIcon = Icons.grid_view;
              } else {
                isGridView = true;
                gridViewIcon = Icons.view_agenda_outlined;
              }
            });
          },
        ),
        IconButton(
            onPressed: () {
              if (mounted) {
                signOut(context, ref);
              }
            },
            icon: Icon(Icons.more_vert)),
      ]),
      floatingActionButton: Consumer(
        builder: (context, ref, child) {
          return FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
              var idea = Idea(title: '');
              ref.read(draftIdeaViewModelProvider.notifier).startIdea(idea);

              List<IdeaTag> ideaTags =
                  ref.read(ideaViewModelProvider).ideaTags.toList();
              ref
                  .read(draftIdeaViewModelProvider.notifier)
                  .startIdeaTag(ideaTags);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return IdeaEditPage(
                    key: ideaEditPageKey, idea: idea, isCreated: true);
              }));
            },
          );
        },
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        double maxContentWidth = 600.0; // 최대 가로폭 제한
        double horizontalPadding = (constraints.maxWidth - maxContentWidth) / 2;
        horizontalPadding =
            horizontalPadding > 0 ? horizontalPadding : 6.0; // 최소 패딩 보장
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
          ),
          child: Consumer(builder: (context, ref, child) {
            var ideasState = ref.watch(ideaViewModelProvider).ideas;

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

            final sortedIdea = List<Idea>.from(ideasState)
              ..sort((a, b) => b.order.compareTo(a.order));

            globalKeys = List.generate(
                sortedIdea.length, (_) => GlobalKey()); // GlobalKey를 동적으로 생성

            int? draggedIndex;
            double? draggedItemOrder;

            // `MasonryGridView.count`에서 `shrinkWrap`과 `NeverScrollableScrollPhysics` 제거
            return MasonryGridView.count(
              crossAxisCount: isGridView! ? 2 : 1, // 한 줄에 아이템 두 개씩 배치
              mainAxisSpacing: 6.0,
              crossAxisSpacing: 6.0,
              itemCount: sortedIdea.length,
              itemBuilder: (BuildContext context, int index) {
                return LongPressDraggable(
                  key: globalKeys[index],
                  child: IdeaCard(
                      key: ValueKey(sortedIdea[index].id),
                      idea: sortedIdea[index]),
                  feedback: SizedBox(
                      width: isGridView!
                          ? MediaQuery.of(context).size.width / 2 - 12
                          : MediaQuery.of(context).size.width - 12,
                      child: IdeaCard(idea: sortedIdea[index])),
                      childWhenDragging: Opacity(
                        opacity: 0.1,
                        child: IdeaCard(idea: sortedIdea[index])),
                  // childWhenDragging: Opacity(
                  //   opacity: 0.1,
                  //   child: IdeaCard(idea: sortedIdea[index]),
                  // ),
                  onDragStarted: () {
                    draggedIndex = index;
                    draggedItemOrder = sortedIdea[index].order;
                  },
                  onDragUpdate: (details) {
                    if (draggedIndex == null || draggedItemOrder == null)
                      return;

                    final localPosition = details.localPosition.dy;
                    double accumulatedHeight = 0.0;
                    int? targetIndex;

                    for (int i = 0; i < sortedIdea.length; i++) {
                      final renderBox = globalKeys[i]
                          .currentContext
                          ?.findRenderObject() as RenderBox?;
                      if (renderBox == null) continue;

                      final itemHeight = renderBox.size.height;
                      final itemTop = accumulatedHeight;
                      final itemBottom = accumulatedHeight + itemHeight;

                      if (localPosition > itemTop &&
                          localPosition < itemBottom) {
                        targetIndex = i;
                        break;
                      }

                      accumulatedHeight += itemHeight;
                    }

                    if (targetIndex != null && targetIndex != draggedIndex) {
                      setState(() {
                        final beforeOrder = sortedIdea[draggedIndex!].order;
                        final targetOrder = sortedIdea[targetIndex!].order;

                        sortedIdea[draggedIndex!] = sortedIdea[draggedIndex!]
                            .copyWith(order: targetOrder);
                        sortedIdea[targetIndex!] = sortedIdea[targetIndex!]
                            .copyWith(order: beforeOrder);

                        draggedIndex = targetIndex;
                      });
                    }
                  },
                  onDragEnd: (details) async {
                    if (draggedIndex == null) return;

                    final beforeOrder = draggedIndex == 0
                        ? null
                        : sortedIdea[draggedIndex!].order;

                    await ref
                        .read(ideaViewModelProvider.notifier)
                        .changeOrderIdea(
                          sortedIdea[draggedIndex!],
                          beforeOrder: beforeOrder,
                        );

                    setState(() {
                      sortedIdea.sort((a, b) => a.order.compareTo(b.order));
                    });
                  },
                );
              },
            );
          }),
        );
      }),
    );
  }
}
