import 'package:creator_planner/theme/colors.dart';
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
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
            ),
            child: Column(
              children: [
                IdeaCard(ideaId: '1'),
                IdeaCard(ideaId: '2'),
                IdeaCard(ideaId: '3'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}