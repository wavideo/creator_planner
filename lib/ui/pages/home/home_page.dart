import 'package:creator_planner/core/theme/colors.dart';
import 'package:creator_planner/data/view_models/draft_idea_view_model.dart';
import 'package:creator_planner/data/view_models/idea_view_model.dart';
import 'package:creator_planner/data/view_models/message_view_model.dart';
import 'package:creator_planner/data/models/idea.dart';
import 'package:creator_planner/data/models/idea_tag.dart';
import 'package:creator_planner/service/auth/sign_out.dart';
import 'package:creator_planner/ui/pages/home/widgets/idea_card.dart';
import 'package:creator_planner/ui/pages/idea_edit/idea_edit_page.dart';
import 'package:creator_planner/core/utils/custom_snackbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sortable_wrap/flutter_sortable_wrap.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:reorderables/reorderables.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  ScrollController _scrollController = ScrollController();
  bool? isGridView;
  IconData? gridViewIcon;

  @override
  void initState() {
    super.initState();
    isGridView = false;
    gridViewIcon = Icons.grid_view;
    _scrollController = ScrollController();
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
            var ideasState = ref.watch(ideaViewModelProvider).ideas;
            List<Idea> sortedIdea = List<Idea>.from(ideasState)
              ..sort((a, b) => b.order.compareTo(a.order));

            return MasonryGridView.count(
              crossAxisCount: isGridView! ? 2 : 1, // 한 줄에 아이템 두 개씩 배치
              mainAxisSpacing: 6.0,
              crossAxisSpacing: 6.0,
              itemCount: sortedIdea.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  child: IdeaCard(idea: sortedIdea[index]),
                  onLongPress: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        ButtonStyle buttonStyle = ButtonStyle(
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(vertical: 14)),
                          textStyle: MaterialStateProperty.all(
                            TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          iconSize: MaterialStateProperty.all(20),
                          backgroundColor: MaterialStateProperty.all(
                              Colors.grey[200]!), // 밝은 회색 배경
                          iconColor: MaterialStateProperty.all(
                              Colors.grey[700]), // 아이콘 색상 (원하는 색으로 변경 가능)
                          foregroundColor: MaterialStateProperty.all(
                              Colors.grey[700]), // 텍스트 색상 (원하는 색으로 변경 가능)
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0), // 모서리 둥글기
                          )),
                          elevation: MaterialStateProperty.all(0), // 그림자 없애기
                          shadowColor: MaterialStateProperty.all(
                              Colors.transparent), // 그림자 없애기
                        );

                        return Container(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 40),
                          width: double.infinity,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '순서 변경',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    bottom: 0,
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(Icons.close),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ElevatedButton.icon(
                                  icon: Icon(Icons.vertical_align_top,
                                      color: Colors.blue),
                                  label: Text(
                                    '맨 위로 올리기',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  onPressed: () {
                                    ref
                                        .read(ideaViewModelProvider.notifier)
                                        .changeOrderIdea(sortedIdea[index],
                                            beforeOrder:
                                                sortedIdea.first.order);
                                    Navigator.pop(context);
                                  },
                                  style: buttonStyle),
                              SizedBox(height: 6),
                              // 한 칸 올리기 버튼
                              ElevatedButton.icon(
                                  icon: Icon(Icons.arrow_upward_rounded),
                                  label: Text('올리기'),
                                  onPressed: () {
                                    ref
                                        .read(ideaViewModelProvider.notifier)
                                        .changeOrderIdea(sortedIdea[index],
                                            beforeOrder:
                                                sortedIdea[index - 1].order);
                                    Navigator.pop(context);
                                  },
                                  style: buttonStyle),
                              SizedBox(height: 6),
                              // 한 칸 내리기 버튼
                              ElevatedButton.icon(
                                  icon: Icon(Icons.arrow_downward_rounded),
                                  label: Text('내리기'),
                                  onPressed: () {
                                    ref
                                        .read(ideaViewModelProvider.notifier)
                                        .changeOrderIdea(sortedIdea[index],
                                            beforeOrder: index !=
                                                    sortedIdea.length - 2
                                                ? sortedIdea[index + 2].order
                                                : null);
                                    Navigator.pop(context);
                                  },
                                  style: buttonStyle),
                            ],
                          ),
                        );
                      },
                    );
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
