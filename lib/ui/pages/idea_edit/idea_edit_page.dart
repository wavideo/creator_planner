import 'dart:math';

import 'package:creator_planner/core/config/theme/colors.dart';
import 'package:creator_planner/core/utils/format_util.dart';
import 'package:creator_planner/data/app_view_model.dart';
import 'package:creator_planner/data/message_view_model.dart';
import 'package:creator_planner/data/models/idea.dart';
import 'package:creator_planner/data/models/idea_tag.dart';
import 'package:creator_planner/ui/pages/home/widgets/idea_card/prototype_section.dart';
import 'package:creator_planner/ui/pages/home/widgets/idea_card/research_section.dart';
import 'package:creator_planner/ui/pages/home/widgets/idea_card/tag_list_with_gradients.dart';
import 'package:creator_planner/ui/pages/home/widgets/idea_card/task_schedule_section.dart';
import 'package:creator_planner/ui/pages/idea_edit/widgets/new_idea_tag_item.dart';
import 'package:creator_planner/ui/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

// DIVIDER: StatefulWidget

class IdeaEditPage extends ConsumerStatefulWidget {
  final Idea idea;
  final bool isCreated;
  const IdeaEditPage({required this.idea, this.isCreated = false, super.key});

  @override
  ConsumerState<IdeaEditPage> createState() => _IdeaEditPageState();
}

// DIVIDER: State

class _IdeaEditPageState extends ConsumerState<IdeaEditPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _targetViewsController = TextEditingController();
  final TextEditingController _addTagController = TextEditingController();

  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _contentFocusNode = FocusNode();

  // DIVIDER: init - dispose

  Future<void> _loadIdea() async {
    _titleController.text = widget.idea.title;
    _contentController.text = widget.idea.content ?? '';

    // 최초 진입 시, TextField에 포커스
    if (widget.isCreated && !_titleFocusNode.hasFocus) {
      _titleFocusNode.requestFocus();
    }
    Logger().d('아이디 : ${widget.idea.id}');
  }

  @override
  void initState() {
    super.initState();
    _loadIdea();
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }

  // DIVIDER2:Build

  @override
  Widget build(BuildContext context) {
    final message = ref.watch(IdeaEditPageMessageProvider);
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
        ref.read(IdeaEditPageMessageProvider.notifier).clearMessage();
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColor.containerWhite.of(context),

      // START: 앱바
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

      // END:
      body: LayoutBuilder(
        builder: (context, constraints) {
          // START: 데스크탑을 위한 반응형
          double maxContentWidth = 600.0; // 최대 가로폭 제한
          double horizontalPadding =
              (constraints.maxWidth - maxContentWidth) / 2;
          horizontalPadding =
              horizontalPadding > 0 ? horizontalPadding : 6.0; // 최소 패딩 보장
          //END:

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
                              // START: 본문 영역
                              _buildTitleTextField(),
                              _buildContentTextField(),
                              SizedBox(height: 50),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                height: 50,
                                child: Row(
                                  children: [
                                    // 태그
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
                              //END:

                              // START: 하단 분석 위젯
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
                              // END:
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // DIVIDER: 바텀 키보드 위젯
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
                              BoxShadow(
                                color: Colors.black26.withValues(alpha: 0.04),
                                spreadRadius: 0,
                                blurRadius: 10,
                                offset: Offset(0, -10),
                              ),
                            ],
                          ),
                          height: 50,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: 16),
                              //START: 태그 추가버튼
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    enableDrag: true,
                                    isScrollControlled: true,
                                    builder: (BuildContext context) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          bottom:
                                              MediaQuery.of(
                                                context,
                                              ).viewInsets.bottom,
                                        ),
                                        child: _buildAddTagBottomSheet(),
                                      );
                                    },
                                  ).whenComplete(() {
                                    updateTargetViews();
                                  });
                                },
                                child: Row(
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
                              ),
                              //END:
                              Spacer(),

                              //START: 목표 추가 버튼
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    enableDrag: true,
                                    isScrollControlled: true,
                                    builder: (BuildContext context) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          bottom:
                                              MediaQuery.of(
                                                context,
                                              ).viewInsets.bottom,
                                        ),
                                        child: _buildTargetViewsBottomSheet(),
                                      );
                                    },
                                  ).whenComplete(() {
                                    updateTargetViews();
                                  });
                                  ;
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.flag,
                                      size: 20,
                                      color: AppColor.primaryBlue.of(context),
                                    ),
                                    SizedBox(width: 4),
                                    Consumer(
                                      builder: (context, ref, child) {
                                        Idea idea =
                                            ref
                                                .watch(appViewModelProvider)
                                                .draftIdea!;
                                        return Text(
                                          idea.targetViews == null
                                              ? '목표 추가'
                                              : '목표 : ${formatCompactNumber(idea.targetViews!)}뷰',
                                          style: TextStyle(
                                            color: AppColor.primaryBlue.of(
                                              context,
                                            ),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              // END:
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

  // DIVIDER2: 주요 메서드
  // DIVIDER: 데이터 업데이트

  Future<void> _updateIdea() async {
    bool isEmpty =
        _titleController.text.isEmpty && _contentController.text.isEmpty;
    bool isChanged =
        (_titleController.text != widget.idea.title ||
            _contentController.text != (widget.idea.content ?? "") ||
            ref.read(appViewModelProvider).draftIdea?.targetViews !=
                widget.idea.targetViews);

    // 내용이 없어서 삭제
    if (!widget.isCreated && isEmpty) {
      ref.read(homePageMessageProvider.notifier).setMessage('아이디어가 삭제되었습니다.');
      if (!mounted) return;
      await ref.read(appViewModelProvider.notifier).deleteIdea(widget.idea);
      ref.read(appViewModelProvider.notifier).clearDraftIdea();
      return;
    }

    // 단순 열람
    if ((widget.isCreated && isEmpty) || !isChanged) {
      ref.read(appViewModelProvider.notifier).clearDraftIdea();
      return;
    }

    // 업데이트할 아이디어 준비
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

    // 생성 또는 수정
    if (widget.isCreated) {
      ref.read(homePageMessageProvider.notifier).setMessage('새로운 아이디어를 저장했습니다');
      await ref.read(appViewModelProvider.notifier).createIdea(updatedIdea!);
      ref.read(appViewModelProvider.notifier).clearDraftIdea();
    } else {
      ref.read(homePageMessageProvider.notifier).setMessage('아이디어를 수정했습니다.');
      await ref.read(appViewModelProvider.notifier).updateIdea(updatedIdea!);
      ref.read(appViewModelProvider.notifier).clearDraftIdea();
    }
  }

  // DIVIDER2: 분할 위젯

  Widget _buildAddTagBottomSheet() {
    return Container(
      // height: double.infinity,
      height: 800,
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 40),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '태그',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Text(
                  '태그 추천',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColor.gray10.of(context),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 20,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,

                    children: [
                      AddIdeaTagItem(ideaTag: IdeaTag(name: '반갑습니다')),
                      AddIdeaTagItem(ideaTag: IdeaTag(name: '오늘')),
                      AddIdeaTagItem(ideaTag: IdeaTag(name: '이왜진')),
                      AddIdeaTagItem(ideaTag: IdeaTag(name: '그')),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Divider(),
            SizedBox(height: 30),
            Row(
              children: [
                Text(
                  '태그 입력',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColor.gray10.of(context),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return Wrap(
                        spacing: 10,
                        runSpacing: 20,
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.center,

                        children: [
                          // NewIdeaTagItem(ideaTag: IdeaTag(name: '반갑습니다')),
                          // NewIdeaTagItem(ideaTag: IdeaTag(name: '오늘')),
                          // NewIdeaTagItem(ideaTag: IdeaTag(name: '이왜진')),
                          // NewIdeaTagItem(ideaTag: IdeaTag(name: '그')),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add),
                              SizedBox(width: 5),
                              Flexible(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      double _calculateWidth(String text) {
                                        final textPainter = TextPainter(
                                          text: TextSpan(
                                            // text: text,
                                            text: text.isEmpty ? '새로 입력' : text,
                                            style: TextStyle(fontSize: 17),
                                          ),
                                          textDirection: TextDirection.ltr,
                                        )..layout();

                                        return textPainter.width +
                                            30; // +20은 padding을 위한 여유 공간
                                      }

                                      double width = _calculateWidth(
                                        _addTagController.text,
                                      );
                                      return Container(
                                        constraints: BoxConstraints(
                                          maxWidth: constraints.maxWidth,
                                        ),
                                        width: width,
                                        alignment: Alignment.center,
                                        child: TextField(
                                          controller: _addTagController,
                                          scrollPhysics:
                                              BouncingScrollPhysics(),
                                          // maxLength: 20,
                                          style: TextStyle(fontSize: 16),
                                          textAlign: TextAlign.start,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            counterText: '',
                                            hintText: '새로 입력',
                                          ),
                                          onEditingComplete: () {
                                            _addTagController.clear();
                                          },
                                          onChanged: (value) {
                                            setState(() {
                                              if (_addTagController.text
                                                  .contains(' ')) {
                                                _addTagController.clear();
                                              }
                                            });
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 4,
                    ),
                    child: Text(
                      "확인",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // DIVIDER: 슬라이더 바텀시트
  Widget _buildTargetViewsBottomSheet() {
    double logScale(double value) {
      return log(value / 100) / log(10); // 100을 기준으로 로그 변환
    }

    double reverseLogScale(double logValue) {
      return pow(10, logValue) * 100; // 로그 값을 다시 원래 값으로 변환
    }

    return Consumer(
      builder: (context, ref, child) {
        Idea idea = ref.watch(appViewModelProvider).draftIdea!;
        return Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '목표 조회수',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppColor.containerBlue10.of(context),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    width: 200,
                    child: TextField(
                      controller: _targetViewsController,
                      maxLength: 7,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: TextStyle(fontSize: 30),
                      textAlign: TextAlign.end,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                        hintText: formatCompactNumber(
                          idea.targetViews ?? 10000,
                        ),
                      ),
                      onChanged: (value) {
                        String format(value) {
                          return formatNumber(
                            int.parse(value.replaceAll(RegExp(r'[^0-9]'), '')),
                          );
                        }

                        if (value != format(value)) {
                          _targetViewsController.text = format(value);
                        }
                      },
                    ),
                  ),
                  Text('  뷰 ', style: TextStyle(fontSize: 18)),
                ],
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(Icons.flag, color: Colors.blue),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              bottom: 0,
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 30,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 6,
                                        child: VerticalDivider(
                                          color: Colors.blue,
                                          thickness: 1,
                                        ),
                                      ),
                                      Text(
                                        '백',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                SizedBox(
                                  width: 30,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 6,
                                        child: VerticalDivider(
                                          color: Colors.blue,
                                          thickness: 1,
                                        ),
                                      ),
                                      Text(
                                        '천',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                SizedBox(
                                  width: 30,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 6,
                                        child: VerticalDivider(
                                          color: Colors.blue,
                                          thickness: 1,
                                        ),
                                      ),
                                      Text(
                                        '만',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                SizedBox(
                                  width: 30,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 6,
                                        child: VerticalDivider(
                                          color: Colors.blue,
                                          thickness: 1,
                                        ),
                                      ),
                                      Text(
                                        '십만',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                SizedBox(
                                  width: 30,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 6,
                                        child: VerticalDivider(
                                          color: Colors.blue,
                                          thickness: 1,
                                        ),
                                      ),
                                      Text(
                                        '백만',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                SizedBox(
                                  width: 30,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 6,
                                        child: VerticalDivider(
                                          color: Colors.blue,
                                          thickness: 1,
                                        ),
                                      ),
                                      Text(
                                        '천만',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Slider(
                              activeColor: Colors.blue,
                              value: logScale(
                                idea.targetViews?.toDouble() ?? 10000,
                              ),
                              min: logScale(100),
                              max: logScale(10000000),
                              divisions: null,
                              label: formatCompactNumber(
                                idea.targetViews ?? 10000,
                              ),
                              onChanged: (value) {
                                _targetViewsController.clear();
                                ref
                                    .read(appViewModelProvider.notifier)
                                    .updateDraftIdea(
                                      idea.copyWith(
                                        targetViews:
                                            reverseLogScale(value).toInt(),
                                      ),
                                    );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (updateTargetViews()) {
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // 기본 배경색
                        foregroundColor: Colors.white, // 글자 색상
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ), // 버튼 패딩
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // 살짝 둥근 모서리
                        ),
                        elevation: 4, // 그림자 효과
                      ),
                      child: Text(
                        "확인", // 버튼 텍스트
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // DIVIDER: 타이틀 Text
  Widget _buildTitleTextField() {
    return TextField(
      controller: _titleController,
      focusNode: _titleFocusNode,
      minLines: 1,
      maxLines: 5,
      maxLength: 40,
      decoration: InputDecoration(
        counterStyle: TextStyle(
          color:
              (_titleController.text.length > 30 && _titleFocusNode.hasFocus)
                  ? Colors.red
                  : Colors.transparent,
        ),
        hintText: '제목',
        border: InputBorder.none,
      ),
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      onChanged: (text) {
        if (text.length >= 40 && _contentController.text.isEmpty) {
          _contentController.text = _titleController.text;
          _titleFocusNode.unfocus();
          FocusScope.of(context).requestFocus(_contentFocusNode);
        }
        setState(() {
          _contentController;
        });
      },
      textInputAction: TextInputAction.next,
    );
  }

  // DIVIDER: 콘텐츠 Text
  Widget _buildContentTextField() {
    return TextField(
      controller: _contentController,
      focusNode: _contentFocusNode,
      minLines: 1,
      maxLines: 999,
      decoration: InputDecoration(hintText: '메모', border: InputBorder.none),
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
    );
  }

  bool updateTargetViews() {
    // Slider만 조절했을 경우
    if (_targetViewsController.text.isEmpty) {
      return true;
    }

    // 콤마 제거
    int value =
        int.tryParse(
          (_targetViewsController.text).replaceAll(RegExp(r'[^0-9]'), ''),
        ) ??
        0;
    _targetViewsController.clear();

    // false 출력해 경고
    if (value < 100 || value > 10000000) {
      ref
          .read(homePageMessageProvider.notifier)
          .setMessage('100 이상 1000만 이하로 입력해주세요');
      return false;
    }
    // TextField 값 저장
    else {
      ref
          .read(appViewModelProvider.notifier)
          .updateDraftIdea(
            ref
                .read(appViewModelProvider)
                .draftIdea!
                .copyWith(targetViews: value),
          );
      return true;
    }
  }
}
