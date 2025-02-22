import 'package:creator_planner/core/config/theme/colors.dart';
import 'package:creator_planner/ui/pages/home/widgets/idea_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.containerWhite.of(context),
      appBar: AppBar(
        title: Text('아이디어 보드'),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        double maxContentWidth = 600.0; // 최대 가로폭 제한
        double horizontalPadding = (constraints.maxWidth - maxContentWidth) / 2;
        horizontalPadding =
            horizontalPadding > 0 ? horizontalPadding : 6.0; // 최소 패딩 보장
        return Center(
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                ),
                child: Column(
                  children: [
                    IdeaCard(ideaId: '1'),
                    IdeaCard(ideaId: '2'),
                    IdeaCard(ideaId: '3', isTask: true),
                    IdeaCard(ideaId: '1', isPrototype: true, isResearch: true),
                    IdeaCard(ideaId: '2', isResearch: true),
                    IdeaCard(ideaId: '3', isPrototype: true, isTask: true),
                    IdeaCard(ideaId: '1', isPrototype: true),
                    IdeaCard(ideaId: '2', isResearch: true),
                    IdeaCard(ideaId: '3', isPrototype: true, isResearch: true, isTask: true),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
