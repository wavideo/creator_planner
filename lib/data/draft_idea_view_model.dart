import 'package:creator_planner/data/models/idea.dart';
import 'package:creator_planner/data/models/idea_tag.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class DraftIdeaState {
  final Idea? draftIdea;
  final List<IdeaTag> draftIdeaTags;
  DraftIdeaState({this.draftIdea, required this.draftIdeaTags});

  DraftIdeaState copyWith({Idea? draftIdea, List<IdeaTag>? draftIdeaTags}) {
    return DraftIdeaState(
      draftIdea: draftIdea ?? this.draftIdea,
      draftIdeaTags: draftIdeaTags ?? this.draftIdeaTags,
    );
  }
}

class DraftIdeaViewModel extends StateNotifier<DraftIdeaState> {
  DraftIdeaViewModel()
      : super(DraftIdeaState(draftIdea: null, draftIdeaTags: []));

  void setState({Idea? draftIdea, List<IdeaTag>? draftIdeaTags}) {
    state = state.copyWith(
      draftIdea: draftIdea ?? state.draftIdea,
      draftIdeaTags: draftIdeaTags ?? state.draftIdeaTags,
    );
  }

  void startIdea(Idea idea) {
    setState(draftIdea: idea);
    Logger().d('startDraftIdea 호출됨, draftIdea: ${state.draftIdea?.id}');
  }

  void updateIdea(Idea idea) {
    if (state.draftIdea == null) return;
    setState(draftIdea: idea);
  }

  void startIdeaTag(List<IdeaTag> ideaTagList) {
    setState(draftIdeaTags: ideaTagList);
    Logger().d('AppViewModel에서 IdeaTag()를 create');
  }

  void createIdeaTag(IdeaTag ideaTag) {
    final updatedTags = List<IdeaTag>.from(state.draftIdeaTags)..add(ideaTag);
    setState(draftIdeaTags: updatedTags);
    Logger().d('AppViewModel에서 IdeaTag()를 create');
  }

  void updateIdeaTag(IdeaTag ideaTag) {
    var ideaTags = state.draftIdeaTags
        .map((item) => item.id == ideaTag.id ? ideaTag : item)
        .toList();
    setState(draftIdeaTags: ideaTags);
    Logger().d('AppViewModel에서 IdeaTag()를 update');
  }

  void deleteIdeaTag(IdeaTag ideaTag) {
    final deletedTags = List<IdeaTag>.from(state.draftIdeaTags)
      ..removeWhere((item) => item.id == ideaTag.id);
    setState(draftIdeaTags: deletedTags);
    Logger().d('AppViewModel에서 IdeaTag()를 delete');
  }

  void clear() {
    setState(draftIdea: null, draftIdeaTags: []);
  }
}

final draftIdeaViewModelProvider =
    StateNotifierProvider<DraftIdeaViewModel, DraftIdeaState>(
  (ref) => DraftIdeaViewModel(),
);
