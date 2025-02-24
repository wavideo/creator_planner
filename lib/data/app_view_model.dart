import 'package:cloud_firestore/cloud_firestore.dart';
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<List<Idea>>? _ideasStream;
  Stream<List<IdeaTag>>? _ideaTagsStream;

  AppViewModel() : super(AppState(ideas: [], ideaTags: [])) {
    _init();
  }

  Future<void> _init() async {
    try {
      final List<Idea> ideas = await IdeaFirestoreService().getItemList();
      final List<IdeaTag> ideaTags =
          await IdeaTagFirestoreService().getItemList();
      state = AppState(ideas: ideas, ideaTags: ideaTags);

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
        state = AppState(ideas: ideas, ideaTags: state.ideaTags);
      });

      _ideaTagsStream?.listen((ideaTags) {
        state = AppState(ideas: state.ideas, ideaTags: ideaTags);
      });

      if (_ideasStream == null) {
        // 서버에서 가져오는 코드
        Logger().d('서버에서 아이디어 데이터를 가져옵니다.');
      } else {
        Logger().d('캐시에서 아이디어 데이터를 가져옵니다.');
      }

      Logger().d('AppViewModel에서 모든 데이터를 init');
    } catch (e) {
      Logger().e('AppViewModel에서 Idea(), IdeaTag()를 init 실패', error: e);
      throw Exception(
        "AppViewModel에서 Idea(), IdeaTag()를 init 하는 과정에 문제가 발생했습니다. 에러: $e",
      );
    }
  }

  Stream<List<Idea>> get ideasStream {
    return _firestore.collection('ideas').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Idea.fromMap(doc.data());
      }).toList();
    });
  }

  Stream<List<IdeaTag>> get ideaTagsStream {
    return _firestore.collection('ideaTags').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return IdeaTag.fromMap(doc.data());
      }).toList();
    });
  }

  Future<void> loadIdeas() async {
    // try {
    //   List<Idea> ideas = await IdeaFirestoreService().getItemList();
    //   state = AppState(ideas: ideas, ideaTags: state.ideaTags);
    // } catch (e) {
    //   Logger().e('AppViewModel에서 Idea()를 load 실패', error: e);
    //   throw Exception("AppViewModel에서 Idea()를 load 하는 과정에 문제가 발생했습니다. 에러: $e");
    // }
  }

  Future<void> loadIdeaTag() async {
    // try {
    //   List<Idea> ideas = await IdeaFirestoreService().getItemList();
    //   state = AppState(ideas: ideas, ideaTags: state.ideaTags);
    // } catch (e) {
    //   Logger().e('AppViewModel에서 IdeaTag()를 load 실패', error: e);
    //   throw Exception(
    //     "AppViewModel에서 IdeaTag()를 load 하는 과정에 문제가 발생했습니다. 에러: $e",
    //   );
    // }
  }

  Future<void> createIdea(Idea idea) async {
    state.ideas.add(idea);
    state = AppState(ideas: state.ideas, ideaTags: state.ideaTags);
    await IdeaFirestoreService().addItem(idea);
    await loadIdeas();
    Logger().d('AppViewModel에서 Idea()를 create');
  }

  Future<void> updateIdea(Idea idea) async {
    Idea currentIdea = state.ideas.firstWhere((item) => item.id == idea.id);
    if (currentIdea == idea) return;

    idea = idea.copyWith(updatedAt: DateTime.now());
    List<Idea> ideas =
        state.ideas.map((item) => item.id == idea.id ? idea : item).toList();
    state = AppState(ideas: ideas, ideaTags: state.ideaTags);
    await IdeaFirestoreService().updateItem(idea);
    await loadIdeas();
    final previousState = state.ideas;
// 새로운 아이디어 리스트를 받아온 후 비교
    if (previousState == state.ideas) {
      Logger().d('캐시에서 가져온 데이터입니다.');
    } else {
      Logger().d('서버에서 데이터를 새로 받아왔습니다.');
    }
    Logger().d('AppViewModel에서 Idea()를 update');
  }

  Future<void> deleteIdea(Idea idea) async {
    state.ideas.removeWhere((item) => item.id == idea.id);
    state = AppState(ideas: state.ideas, ideaTags: state.ideaTags);
    await IdeaFirestoreService().deleteItem(idea.id);
    await loadIdeas();
    Logger().d('AppViewModel에서 Idea()를 delete');
  }

  Future<void> createIdeaTag(IdeaTag ideaTag) async {
    state.ideaTags.add(ideaTag);
    state = AppState(ideas: state.ideas, ideaTags: state.ideaTags);
    await IdeaTagFirestoreService().addItem(ideaTag);
    await loadIdeaTag();
    Logger().d('AppViewModel에서 IdeaTag()를 create');
  }

  Future<void> updateIdeaTag(IdeaTag ideaTag) async {
    var ideaTags = state.ideaTags
        .map((item) => item.id == ideaTag.id ? ideaTag : item)
        .toList();
    state = AppState(ideas: state.ideas, ideaTags: ideaTags);
    await IdeaTagFirestoreService().updateItem(ideaTag);
    await loadIdeaTag();
    Logger().d('AppViewModel에서 IdeaTag()를 update');
  }

  Future<void> deleteIdeaTag(IdeaTag ideaTag) async {
    state.ideaTags.removeWhere((item) => item.id == ideaTag.id);
    state = AppState(ideas: state.ideas, ideaTags: state.ideaTags);
    await IdeaTagFirestoreService().deleteItem(ideaTag.id);
    await loadIdeaTag();
    Logger().d('AppViewModel에서 IdeaTag()를 delete');
  }
}

final appViewModelProvider = StateNotifierProvider<AppViewModel, AppState>(
  (ref) => AppViewModel(),
);