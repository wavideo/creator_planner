import 'package:creator_planner/data/models/idea.dart';
import 'package:creator_planner/data/models/idea_tag.dart';
import 'package:creator_planner/data/services/idea_firestore_service.dart';
import 'package:creator_planner/data/services/idea_tag_firestore_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class AppState {
  final List<Idea> ideas;
  final List<IdeaTag> ideaTags;

  AppState({required this.ideas, required this.ideaTags});
}

class AppViewModel extends StateNotifier<AppState> {
  AppViewModel() : super(AppState(ideas: [], ideaTags: [])) {
    _init();
  }

  Future<void> _init() async {
    try {
      final List<Idea> ideas = await IdeaFirestoreService().getItemList();
      final List<IdeaTag> ideaTags =
          await IdeaTagFirestoreService().getItemList();
      state = AppState(ideas: ideas, ideaTags: ideaTags);
    } catch (e) {
      Logger().e('AppViewModel에서 Idea(), IdeaTag()를 init 실패', error: e);
      throw Exception(
        "AppViewModel에서 Idea(), IdeaTag()를 init 하는 과정에 문제가 발생했습니다. 에러: $e",
      );
    }
  }

  Future<void> loadIdeas() async {
    try {
      List<Idea> ideas = await IdeaFirestoreService().getItemList();
      state = AppState(ideas: ideas, ideaTags: state.ideaTags);
    } catch (e) {
      Logger().e('AppViewModel에서 Idea()를 load 실패', error: e);
      throw Exception("AppViewModel에서 Idea()를 load 하는 과정에 문제가 발생했습니다. 에러: $e");
    }
  }

  Future<void> createIdea(Idea idea) async {
    await IdeaFirestoreService().addItem(idea);
    Logger().d('AppViewModel에서 Idea()를 create');
    await loadIdeas();
  }

  Future<void> updateIdea(Idea idea) async {
    await IdeaFirestoreService().updateItem(idea);
    Logger().d('AppViewModel에서 Idea()를 update');
    await loadIdeas();
  }

  Future<void> deleteIdea(Idea idea) async {
    await IdeaFirestoreService().deleteItem(idea.id);
    Logger().d('AppViewModel에서 Idea()를 delete');
    await loadIdeas();
  }

  Future<void> loadIdeaTag() async {
    try {
      List<Idea> ideas = await IdeaFirestoreService().getItemList();
      state = AppState(ideas: ideas, ideaTags: state.ideaTags);
    } catch (e) {
      Logger().e('AppViewModel에서 IdeaTag()를 load 실패', error: e);
      throw Exception(
        "AppViewModel에서 IdeaTag()를 load 하는 과정에 문제가 발생했습니다. 에러: $e",
      );
    }
  }

  Future<void> createIdeaTag(IdeaTag ideaTag) async {
    await IdeaTagFirestoreService().addItem(ideaTag);
    Logger().d('AppViewModel에서 IdeaTag()를 create');
    await loadIdeaTag();
  }

  Future<void> updateIdeaTag(IdeaTag ideaTag) async {
    await IdeaTagFirestoreService().updateItem(ideaTag);
    Logger().d('AppViewModel에서 IdeaTag()를 update');
    await loadIdeaTag();
  }

  Future<void> deleteIdeaTag(IdeaTag ideaTag) async {
    await IdeaTagFirestoreService().deleteItem(ideaTag.id);
    Logger().d('AppViewModel에서 IdeaTag()를 delete');
    await loadIdeaTag();
  }

  // Idea? getIdeaById(String id) {
  //   return state.ideas
  //       .firstWhere((idea) => idea.id == id, orElse: () => null as Idea);
  // }
  // IdeaTag? getIdeaTagById(String id) {
  //   return state.ideaTags.firstWhere((ideaTag) => ideaTag.id == id,
  //       orElse: () => null as IdeaTag);
  // }
}

final appViewModelProvider = StateNotifierProvider<AppViewModel, AppState>(
  (ref) => AppViewModel(),
);
