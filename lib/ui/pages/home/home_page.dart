import 'package:creator_planner/core/theme/colors.dart';
import 'package:creator_planner/data/view_models/idea_view_model.dart';
import 'package:creator_planner/data/view_models/message_view_model.dart';
import 'package:creator_planner/service/auth/sign_out.dart';
import 'package:creator_planner/ui/pages/home/widgets/create_idea_floating_action_button.dart';
import 'package:creator_planner/core/utils/custom_snackbar_helper.dart';
import 'package:creator_planner/ui/pages/home/widgets/idea_card/sections/tag_list_with_gradients.dart';
import 'package:creator_planner/ui/pages/home/widgets/idea_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool? isGridView;
  IconData? gridViewIcon; // gridView <-> listView 스위칭

  @override
  void initState() {
    super.initState();
    isGridView = false;
    gridViewIcon = Icons.grid_view;
  }

  // DIVIDER: 플로팅 버튼 + 앱바 세팅

  @override
  Widget build(BuildContext context) {
    // 상단 스낵바 세팅
    final message = ref.watch(homePageMessageProvider);
    showCustomSnackbar(message: message, context: context);

    return Scaffold(
      // 플로팅 액션 버튼 -> 아이디어 추가
      floatingActionButton: CreateIdeaFloatingActionButton(),
      backgroundColor: AppColor.containerWhite.of(context),
      appBar: AppBar(
          centerTitle: true,
          title: Text('아이디어 보드'),
          actions: [
            // gridView <-> listView 스위칭 버튼
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
            // 메뉴 버튼 -> 로그아웃 및 초기화
            IconButton(
                onPressed: () {
                  if (mounted) {
                    signOut(context, ref);
                  }
                },
                icon: Icon(Icons.more_vert)),
          ],
          //TODO: 필터링 기능 개발 필요
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TagListWithGradients(
                  ideaId: ref
                      .watch(
                        ideaViewModelProvider,
                      )
                      .ideas
                      .last
                      .id,
                  isDraft: false),
            ),
          )),

      // DIVIDER: Idea 리스트

      // PC모드 가로폭 제한
      body: LayoutBuilder(builder: (context, constraints) {
        double maxContentWidth = 600.0; // 최대 가로폭 제한
        double horizontalPadding = (constraints.maxWidth - maxContentWidth) / 2;
        horizontalPadding =
            horizontalPadding > 0 ? horizontalPadding : 6.0; // 최소 패딩 보장
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
          ),
          // 아이디어 목록
          child: IdeaList(isGridView: isGridView ?? false),
        );
      }),
    );
  }
}
