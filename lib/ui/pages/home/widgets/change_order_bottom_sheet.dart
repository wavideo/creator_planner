import 'package:creator_planner/data/view_models/idea_view_model.dart';
import 'package:creator_planner/data/models/idea.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// DIVIDER: 바텀 모달 소환 메서드

Future<dynamic> showChangeOrderBottomSheet(
    BuildContext context, List<Idea> sortedIdea, int index) {
  return showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return ChangeOrderBottomSheet(sortedIdea: sortedIdea, index: index);
    },
  );
}

// DIVIDER: 바텀 모달 UI

class ChangeOrderBottomSheet extends ConsumerWidget {
  const ChangeOrderBottomSheet({
    required this.sortedIdea,
    required this.index,
    super.key,
  });
  final List<Idea> sortedIdea;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 40),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppBar(
            title: Text('순서 변경',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close),
              ),
            ],
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          SizedBox(
            height: 20,
          ),

          // DIVIDER: 버튼 3개

          ElevatedButton.icon(
              icon: Icon(Icons.vertical_align_top, color: Colors.blue),
              label: Text(
                '맨 위로 올리기',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                ref.read(ideaViewModelProvider.notifier).changeOrderIdea(
                    sortedIdea[index],
                    beforeOrder: sortedIdea.first.order);
                Navigator.pop(context);
              },
              style: _buttonStyle),
          SizedBox(height: 6),
          ElevatedButton.icon(
              icon: Icon(Icons.arrow_upward_rounded),
              label: Text('올리기'),
              onPressed: () {
                ref.read(ideaViewModelProvider.notifier).changeOrderIdea(
                    sortedIdea[index],
                    beforeOrder: sortedIdea[index - 1].order);
                Navigator.pop(context);
              },
              style: _buttonStyle),
          SizedBox(height: 6),
          ElevatedButton.icon(
              icon: Icon(Icons.arrow_downward_rounded),
              label: Text('내리기'),
              onPressed: () {
                ref.read(ideaViewModelProvider.notifier).changeOrderIdea(
                    sortedIdea[index],
                    beforeOrder: index != sortedIdea.length - 2
                        ? sortedIdea[index + 2].order
                        : null);
                Navigator.pop(context);
              },
              style: _buttonStyle),
        ],
      ),
    );
  }
}

// DIVIDER: 스타일

ButtonStyle _buttonStyle = ButtonStyle(
  padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 14)),
  textStyle: MaterialStateProperty.all(
    TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
  ),
  iconSize: MaterialStateProperty.all(20),
  backgroundColor: MaterialStateProperty.all(Colors.grey[200]!), // 밝은 회색 배경
  iconColor:
      MaterialStateProperty.all(Colors.grey[700]), // 아이콘 색상 (원하는 색으로 변경 가능)
  foregroundColor:
      MaterialStateProperty.all(Colors.grey[700]), // 텍스트 색상 (원하는 색으로 변경 가능)
  shape: MaterialStateProperty.all(RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8.0), // 모서리 둥글기
  )),
  elevation: MaterialStateProperty.all(0), // 그림자 없애기
  shadowColor: MaterialStateProperty.all(Colors.transparent), // 그림자 없애기
);