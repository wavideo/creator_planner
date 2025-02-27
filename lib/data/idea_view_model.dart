import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creator_planner/data/models/idea.dart';
import 'package:creator_planner/data/models/idea_tag.dart';
import 'package:creator_planner/data/services/idea_firestore_service.dart';
import 'package:creator_planner/data/services/idea_tag_firestore_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class IdeaState {
  final List<Idea> ideas;
  final List<IdeaTag> ideaTags;
  IdeaState({required this.ideas, required this.ideaTags});
}

class IdeaViewModel extends StateNotifier<IdeaState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<List<Idea>>? _ideasStream;
  Stream<List<IdeaTag>>? _ideaTagsStream;

  IdeaViewModel() : super(IdeaState(ideas: [], ideaTags: [])) {
    _init();
  }

  Future<void> _init() async {
    try {
      state = IdeaState(ideas: state.ideas, ideaTags: state.ideaTags);

      // 스트림 구독
      _ideasStream = _firestore.collection('ideas').snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return Idea.fromMap(doc.data());
        }).toList();
      });

      _ideaTagsStream =
          _firestore.collection('ideaTags').snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return IdeaTag.fromMap(doc.data());
        }).toList();
      });

      // 스트림에 변화가 있을 때마다 상태를 업데이트
      _ideasStream?.listen((ideas) {
        setState(ideas: ideas);
      });

      _ideaTagsStream?.listen((ideaTags) {
        setState(ideaTags: ideaTags);
      });

      Logger().d('AppViewModel에서 모든 데이터를 init');
    } catch (e) {
      Logger().e('AppViewModel에서 Idea(), IdeaTag()를 init 실패', error: e);
      throw Exception(
        "AppViewModel에서 Idea(), IdeaTag()를 init 하는 과정에 문제가 발생했습니다. 에러: $e",
      );
    }
  }

  void setState({List<Idea>? ideas, List<IdeaTag>? ideaTags}) {
    state = IdeaState(
      ideas: ideas ?? state.ideas,
      ideaTags: ideaTags ?? state.ideaTags,
    );
  }

  Future<void> createIdea(Idea idea) async {
    state.ideas.add(idea);
    setState();
    await IdeaFirestoreService().addItem(idea);
    Logger().d('AppViewModel에서 Idea()를 create');
  }

  Future<void> updateIdea(Idea idea) async {
    Idea currentIdea = state.ideas.firstWhere((item) => item.id == idea.id);
    // if (currentIdea == idea) return;
    Logger().d('#뷰모델저장 currentIdea : $currentIdea');
    Logger().d('#뷰모델저장 idea : $idea');

    idea = idea.copyWith(updatedAt: DateTime.now());
    List<Idea> ideas =
        state.ideas.map((item) => item.id == idea.id ? idea : item).toList();

    setState(ideas: ideas);
    await IdeaFirestoreService().updateItem(idea);

    Logger().d('AppViewModel에서 Idea()를 update');
  }

  Future<void> deleteIdea(Idea idea) async {
    state.ideas.removeWhere((item) => item.id == idea.id);
    setState();
    await IdeaFirestoreService().deleteItem(idea.id);
    Logger().d('AppViewModel에서 Idea()를 delete');
  }

  Future<void> createIdeaTag(IdeaTag ideaTag) async {
    state.ideaTags.add(ideaTag);
    setState();
    await IdeaTagFirestoreService().addItem(ideaTag);
    Logger().d('AppViewModel에서 IdeaTag()를 create');
  }

  Future<void> updateIdeaTag(IdeaTag ideaTag) async {
    var ideaTags = state.ideaTags
        .map((item) => item.id == ideaTag.id ? ideaTag : item)
        .toList();
    setState(ideaTags: ideaTags);
    await IdeaTagFirestoreService().updateItem(ideaTag);
    Logger().d('AppViewModel에서 IdeaTag()를 update');
  }

  Future<void> deleteIdeaTag(IdeaTag ideaTag) async {
    state.ideaTags.removeWhere((item) => item.id == ideaTag.id);
    setState();
    await IdeaTagFirestoreService().deleteItem(ideaTag.id);
    Logger().d('AppViewModel에서 IdeaTag()를 delete');
  }
}

final ideaViewModelProvider = StateNotifierProvider<IdeaViewModel, IdeaState>(
  (ref) => IdeaViewModel(),
);
