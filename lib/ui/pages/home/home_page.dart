import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('홈'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 10,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.video_call),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                '엔비디아 관련 콘텐츠',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            '어떤어떤 방식으로 제작하고 어떤어떤방시긍로 제작한다음엔 어떤어떤 방시긍로 제작하면 재미있을것 같다...',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 24,
                        bottom: 8,
                        left: 14,
                        right: 26,
                      ),
                      child: Column(
                        children: [
                          ReferenceVideo(),
                          ReferenceVideo(),
                          ReferenceVideo(),
                        ],
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 6,
                        left: 14,
                        right: 26,
                      ),
                      child: Row(
                        children: [
                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6), // 안쪽 여백
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey, // 테두리 색상 (회색)
                                  width: 1, // 테두리 두께
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Text('유튜브 아이디어')),
                          Spacer(),
                          Text('중요', style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReferenceVideo extends StatelessWidget {
  const ReferenceVideo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.grey,
            ),
            width: 80,
            child: AspectRatio(aspectRatio: 16 / 9, child: Container()),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('엔비디아 샀다가 폭삭 망한 이뉴는...', style: TextStyle(fontSize: 14)),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Icon(Icons.local_fire_department),
                      SizedBox(width: 4),
                      Text('720%',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600))
                    ]),
                    Row(
                      children: [
                        Row(children: [
                          Icon(Icons.bar_chart, size: 16),
                          SizedBox(width: 4),
                          Text('3.6만뷰',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600))
                        ]),
                        SizedBox(width: 10),
                        Row(children: [
                          Text('/', style: TextStyle(fontSize: 12)),
                          SizedBox(width: 4),
                          Icon(Icons.group, size: 16),
                          SizedBox(width: 4),
                          Text('3.6만명', style: TextStyle(fontSize: 12))
                        ])
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
