import 'package:creator_planner/core/config/theme/colors.dart';
import 'package:creator_planner/data/app_view_model.dart';
import 'package:creator_planner/data/message_view_model.dart';
import 'package:creator_planner/data/models/idea.dart';
import 'package:creator_planner/ui/pages/home/widgets/idea_card.dart';
import 'package:creator_planner/ui/pages/idea_edit/idea_edit_page.dart';
import 'package:creator_planner/ui/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final message = ref.watch(homePageMessageProvider);
    Future.delayed(Duration(milliseconds: 300), () {
      if (message.isNotEmpty) {
        final overlay = Overlay.of(context);
        final overlayEntry = OverlayEntry(
          builder: (context) => CustomSnackbar(message: message),
        );
        overlay.insert(overlayEntry);

        // 잠시 후 OverlayEntry 제거 (2초 후)
        Future.delayed(Duration(seconds: 2), () {
          overlayEntry.remove();
        });

        // 메시지 표시 후 메시지를 비워줍니다 (1번만 띄우도록)
        ref.read(homePageMessageProvider.notifier).clearMessage();
      }
    });

    return Scaffold(
      backgroundColor: AppColor.containerWhite.of(context),
      appBar: AppBar(
        title: Text('아이디어 보드'),
      ),
      floatingActionButton: Consumer(
        builder: (context, ref, child) {
          return FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
              var idea = Idea(title: '');
              ref.read(appViewModelProvider.notifier).startDraftIdea(idea);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return IdeaEditPage(idea: idea, isCreated: true);
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
                  var ideasState = ref.watch(appViewModelProvider).ideas;

                  ref.listen<List<Idea>>(
                    appViewModelProvider.select((viewModel) => viewModel.ideas),
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

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: sortedIdea.length,
                    itemBuilder: (context, index) {
                      return IdeaCard(idea: sortedIdea[index]);
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
