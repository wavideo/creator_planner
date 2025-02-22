import 'package:creator_planner/core/config/theme/colors.dart';
import 'package:creator_planner/data/mock_data.dart';
import 'package:creator_planner/ui/pages/home/widgets/idea_card.dart';
import 'package:creator_planner/ui/pages/idea_edit/idea_edit_page.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return IdeaEditPage();
          }));
        },
        child: Icon(Icons.add),
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
                    ListView.builder(
                        itemCount: mockIdeas.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final idea = mockIdeas[index];
                          return IdeaCard(id: idea.id);
                        })
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
