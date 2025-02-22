import 'package:creator_planner/data/models/idea.dart';
import 'package:creator_planner/data/models/idea_tag.dart';

final List<Idea> mockIdeas = [
  Idea(
      title: "Flutter 앱 개발",
      content: '테스트',
      tagIds: ["001", "002", "003", "004", "006", "005"],
      targetViews: 320300),
  Idea(title: "AI 기반 콘텐츠 추천", content: '테스트'),
  Idea(title: "AI 기반 콘텐츠 추천", content: '테스트', targetViews: 560200),
  Idea(title: "AI 기반 콘텐츠 추천"),
  Idea(title: "AI 기반 콘텐츠 추천", tagIds: ["001", "002", "003", "004"], targetViews: 560200),
  Idea(
    title: "AI 기반 콘텐츠 추천",
    content: '테스트',
    tagIds: ["005", "006"],
  ),
  Idea(
      title: "블록체인 결제 시스템",
      content: '테스트',
      tagIds: ["005", "006"],
      targetViews: 560200),
];

final List<IdeaTag> mockTags = [
  IdeaTag(id: "001", name: "flutter"),
  IdeaTag(id: "002", name: "mobile"),
  IdeaTag(id: "003", name: "AI"),
  IdeaTag(id: "004", name: "recommendation"),
  IdeaTag(id: "005", name: "blockchain"),
  IdeaTag(id: "006", name: "finance")
];
