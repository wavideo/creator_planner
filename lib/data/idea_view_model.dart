import 'dart:async';
import 'package:creator_planner/data/models/idea.dart';
import 'package:creator_planner/data/models/idea_tag.dart';
import 'package:creator_planner/data/services/idea_firestore_service.dart';
import 'package:creator_planner/data/services/idea_tag_firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class IdeaState {
  final List<Idea> ideas;
  final List<IdeaTag> ideaTags;
  IdeaState({required this.ideas, required this.ideaTags});
}

class IdeaViewModel extends StateNotifier<IdeaState> {
  StreamSubscription? ideasStreamSubscription;
  StreamSubscription? ideaTagsStreamSubscription;

  IdeaViewModel() : super(IdeaState(ideas: [], ideaTags: [])) {
    _init();
  }

  // Stream 세팅
  Future<void> _init() async {
    try {
      state = IdeaState(ideas: state.ideas, ideaTags: state.ideaTags);

      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        Logger().e('사용자가 로그인하지 않았습니다.');
        throw Exception("로그인된 사용자가 없습니다.");
      }

      // 스트림 구독
      Stream ideasStream = IdeaFirestoreService().getStream();
      ideasStreamSubscription = ideasStream.listen((ideas) {
        setState(ideas: ideas);
      });

      Stream ideaTagsStream = IdeaTagFirestoreService().getStream();
      ideaTagsStreamSubscription = ideaTagsStream.listen((ideaTags) {
        setState(ideaTags: ideaTags);
      });

      Logger().d('init');
    } catch (e) {
      Logger().e('AppViewModel에서 Idea(), IdeaTag()를 init 실패', error: e);
      throw Exception(
        "AppViewModel에서 Idea(), IdeaTag()를 init 하는 과정에 문제가 발생했습니다. 에러: $e",
      );
    }
  }

  @override
  void dispose() {
    ideasStreamSubscription?.cancel();
    ideaTagsStreamSubscription?.cancel();
    super.dispose();
  }

  // 상태 업데이트
  void setState({List<Idea>? ideas, List<IdeaTag>? ideaTags}) {
    state = IdeaState(
      ideas: ideas ?? state.ideas,
      ideaTags: ideaTags ?? state.ideaTags,
    );
  }

  Future<void> createIdea(Idea idea) async {
    state.ideas.add(idea);
    setState();
    await IdeaFirestoreService().add(idea);
    Logger().d('AppViewModel에서 Idea()를 create');
  }

  Future<void> createIdeaTag(IdeaTag ideaTag) async {
    state.ideaTags.add(ideaTag);
    setState();
    await IdeaTagFirestoreService().add(ideaTag);
    Logger().d('AppViewModel에서 IdeaTag()를 create');
  }

  Future<void> updateIdea(Idea idea) async {
    idea = idea.copyWith(updatedAt: DateTime.now());
    List<Idea> ideas =
        state.ideas.map((item) => item.id == idea.id ? idea : item).toList();
    setState(ideas: ideas);
    await IdeaFirestoreService().update(idea);

    Logger().d('AppViewModel에서 Idea()를 update');
  }

  Future<void> updateIdeaTag(IdeaTag ideaTag) async {
    var ideaTags = state.ideaTags
        .map((item) => item.id == ideaTag.id ? ideaTag : item)
        .toList();
    setState(ideaTags: ideaTags);
    await IdeaTagFirestoreService().update(ideaTag);
    Logger().d('AppViewModel에서 IdeaTag()를 update');
  }

  Future<void> deleteIdea(Idea idea) async {
    state.ideas.removeWhere((item) => item.id == idea.id);
    setState();
    await IdeaFirestoreService().delete(idea.id);
    Logger().d('AppViewModel에서 Idea()를 delete');
  }

  Future<void> deleteIdeaTag(IdeaTag ideaTag) async {
    state.ideaTags.removeWhere((item) => item.id == ideaTag.id);
    setState();
    await IdeaTagFirestoreService().delete(ideaTag.id);
    Logger().d('AppViewModel에서 IdeaTag()를 delete');
  }

  Future<void> clear() async {
    state = IdeaState(ideas: [], ideaTags: []);
    await IdeaFirestoreService().deleteAll();
    await IdeaTagFirestoreService().deleteAll();
    Logger().d('AppViewModel에서 모든 데이터를 delete');
  }
}

final ideaViewModelProvider = StateNotifierProvider<IdeaViewModel, IdeaState>(
  (ref) => IdeaViewModel(),
);
