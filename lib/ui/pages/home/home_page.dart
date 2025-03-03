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

  @override
  void initState() {
    super.initState();
    isGridView = true;
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
        return Center(
          child: ListView(
            controller: _scrollController,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                ),
                child: Consumer(builder: (context, ref, child) {
                  var ideasState = ref.watch(ideaViewModelProvider).ideas;

                  ref.listen<List<Idea>>(
                    ideaViewModelProvider
                        .select((viewModel) => viewModel.ideas),
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
                    ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
                  return isGridView!
                      ? StaggeredGrid.count(
                          crossAxisCount: 2, // 한 줄에 아이템 몇 개
                          mainAxisSpacing: 6.0,
                          crossAxisSpacing: 6.0,
                          children: sortedIdea.map((idea) {
                            return IdeaCard(idea: idea);
                          }).toList(),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: sortedIdea.length,
                          itemBuilder: (context, index) {
                            return IdeaCard(idea: sortedIdea[index]);
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(height: 6);
                          },
                        );
                }),
              ),
            ],
          ),
        );
      }),
    );
  }
}
