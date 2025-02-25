import 'dart:math';

import 'package:creator_planner/core/config/theme/colors.dart';
import 'package:creator_planner/core/utils/format_util.dart';
import 'package:creator_planner/data/app_view_model.dart';
import 'package:creator_planner/data/message_view_model.dart';
import 'package:creator_planner/data/models/idea.dart';
import 'package:creator_planner/ui/pages/home/widgets/idea_card/prototype_section.dart';
import 'package:creator_planner/ui/pages/home/widgets/idea_card/research_section.dart';
import 'package:creator_planner/ui/pages/home/widgets/idea_card/tag_list_with_gradients.dart';
import 'package:creator_planner/ui/pages/home/widgets/idea_card/task_schedule_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class IdeaEditPage extends ConsumerStatefulWidget {
  final Idea idea;
  final bool isCreated;
  const IdeaEditPage({required this.idea, this.isCreated = false, super.key});

  @override
  ConsumerState<IdeaEditPage> createState() => _IdeaEditPageState();
}

class _IdeaEditPageState extends ConsumerState<IdeaEditPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _contentFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadIdea();
  }

  Future<void> _loadIdea() async {
    Logger().d('아이디 : ${widget.idea.id}');
    _titleController.text = widget.idea.title;
    _contentController.text = widget.idea.content ?? '';

    if (widget.isCreated && !_titleFocusNode.hasFocus) {
      _titleFocusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }

  Future<void> _updateIdea() async {
    bool isEmpty =
        _titleController.text.isEmpty && _contentController.text.isEmpty;
    bool isChanged =
        (_titleController.text != widget.idea.title ||
            _contentController.text != (widget.idea.content ?? "") ||
            ref.read(appViewModelProvider).draftIdea?.targetViews !=
                widget.idea.targetViews);

    if (widget.isCreated && isEmpty) return;
    if (!widget.isCreated && isEmpty) {
      ref.read(homePageMessageProvider.notifier).setMessage('아이디어가 삭제되었습니다.');
      if (!mounted) return;
      await ref.read(appViewModelProvider.notifier).deleteIdea(widget.idea);
      ref.read(appViewModelProvider.notifier).clearDraftIdea();
      return;
    }
    if (!isChanged) {
      ref.read(appViewModelProvider.notifier).clearDraftIdea();
      return;
    }

    var idea = ref.read(appViewModelProvider).draftIdea;

    var updatedIdea = idea?.copyWith(
      title:
          (_titleController.text.isEmpty && _contentController.text.isNotEmpty)
              ? _contentController.text.substring(
                0,
                min(40, _contentController.text.length),
              )
              : _titleController.text,
      content: _contentController.text,
    );

    if (widget.isCreated) {
      ref.read(homePageMessageProvider.notifier).setMessage('새로운 아이디어를 저장했습니다');
      if (!mounted) return;
      await ref.read(appViewModelProvider.notifier).createIdea(updatedIdea!);
      ref.read(appViewModelProvider.notifier).clearDraftIdea();
    } else {
      ref.read(homePageMessageProvider.notifier).setMessage('아이디어를 수정했습니다.');
      await ref.read(appViewModelProvider.notifier).updateIdea(updatedIdea!);
      ref.read(appViewModelProvider.notifier).clearDraftIdea();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColor.containerWhite.of(context),
      appBar: AppBar(
        title: Text('아이디어 수정'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () async {
            await _updateIdea();
            Navigator.pop(context);
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double maxContentWidth = 600.0; // 최대 가로폭 제한
          double horizontalPadding =
              (constraints.maxWidth - maxContentWidth) / 2;
          horizontalPadding =
              horizontalPadding > 0 ? horizontalPadding : 6.0; // 최소 패딩 보장
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 20,
                            bottom: 300,
                          ),
                          child: Column(
                            children: [
                              TextField(
                                controller: _titleController,
                                focusNode: _titleFocusNode,
                                minLines: 1,
                                maxLines: 5,
                                maxLength: 40,
                                decoration: InputDecoration(
                                  counterStyle: TextStyle(
                                    color:
                                        (_titleController.text.length > 30 &&
                                                _titleFocusNode.hasFocus)
                                            ? Colors.red
                                            : Colors.transparent,
                                  ),
                                  hintText: '제목',
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                                onChanged: (text) {
                                  if (text.length >= 40 &&
                                      _contentController.text.isEmpty) {
                                    _contentController.text =
                                        _titleController.text;
                                    _titleFocusNode.unfocus();
                                    FocusScope.of(
                                      context,
                                    ).requestFocus(_contentFocusNode);
                                  }
                                  setState(() {
                                    _contentController;
                                  });
                                },
                                textInputAction: TextInputAction.next,
                              ),
                              TextField(
                                controller: _contentController,
                                focusNode: _contentFocusNode,
                                minLines: 1,
                                maxLines: 999,
                                decoration: InputDecoration(
                                  hintText: '메모',
                                  border: InputBorder.none,
                                ),
                                onTap: () {
                                  setState(() {
                                    _titleFocusNode;
                                  });
                                },
                                onChanged: (text) {
                                  setState(() {
                                    _titleFocusNode;
                                  });
                                },
                              ),
                              SizedBox(height: 50),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                height: 50,
                                child: Row(
                                  children: [
                                    TagListWithGradients(
                                      ideaId:
                                          ref
                                              .watch(appViewModelProvider)
                                              .draftIdea!
                                              .id,
                                    ),
                                  ],
                                ),
                              ),
                              PrototypeSection(
                                title: '내가 정한 이름',
                                channelName: '내 채널',
                                targetViews: 13004,
                              ),
                              ResearchSection(
                                title: '반드시 봐야하는 인터넷 꿀팁 3가지',
                                channelName: '아정당',
                                views: 22232200,
                                subscribers: 1000000,
                              ),
                              TaskScheduleSection(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      double keyboardHeight =
                          MediaQuery.of(context).viewInsets.bottom;

                      return Positioned(
                        bottom: keyboardHeight > 0 ? keyboardHeight : 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              // BoxShadow(
                              //   color: Colors.black26.withValues(alpha: 0.04),
                              //   spreadRadius: 0,
                              //   blurRadius: 10,
                              //   offset: Offset(0, -10),
                              // )
                            ],
                          ),
                          height: 50,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.new_label,
                                    size: 24,
                                    color: AppColor.gray10.of(context),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '태그 추가',
                                    style: TextStyle(
                                      color: AppColor.gray10.of(context),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              groupTargetViews(context),
                              SizedBox(width: 20),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(height: 30),
    );
  }

  Widget groupTargetViews(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Consumer(
              builder: (context, ref, child) {
                Idea idea = ref.watch(appViewModelProvider).draftIdea!;

                return Container(
                  height: 200,
                  child: Column(
                    children: [
                      Slider(
                        value: idea.targetViews?.toDouble() ?? 1000,
                        min: 100,
                        max: 5000000,
                        divisions: 100,
                        label: formatCompactNumber(idea.targetViews ?? 1000),
                        onChanged: (value) {
                          ref
                              .read(appViewModelProvider.notifier)
                              .updateDraftIdea(
                                idea.copyWith(targetViews: value.toInt()),
                              );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
      child: Row(
        children: [
          Icon(Icons.flag, size: 20, color: AppColor.primaryBlue.of(context)),
          SizedBox(width: 4),
          Consumer(
            builder: (context, ref, child) {
              Idea idea = ref.watch(appViewModelProvider).draftIdea!;
              return Text(
                idea.targetViews == null
                    ? '목표 추가'
                    : '목표 : ${formatCompactNumber(idea.targetViews!)}뷰',
                style: TextStyle(
                  color: AppColor.primaryBlue.of(context),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
