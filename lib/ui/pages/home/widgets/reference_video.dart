import 'package:creator_planner/theme/colors.dart';
import 'package:creator_planner/ui/widgets/custom_box2.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ReferenceVideoBox extends StatelessWidget {
  const ReferenceVideoBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomBox2(
      icon: Icons.search,
      title: '주제 시장조사',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          groupVideoRow(context),
          SizedBox(height: 20),
          viewsChart(context),
          SizedBox(height: 10),
          groupViewsRow(context),
        ],
      ),
    );
  }

  Widget viewsChart(BuildContext context) {
    return Row(
      children: [
        Flexible(flex: 0, child: SizedBox()),
        Flexible(
          flex: 1,
          child: SizedBox(
            height: 80,
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Colors.blue,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((touchedSpot) {
                          return LineTooltipItem(
                            '${touchedSpot.x.toInt()}일 ${touchedSpot.y.toInt()}회',
                            TextStyle(color: Colors.white),
                          );
                        }).toList();
                      },
                    )),
                gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    drawHorizontalLine: true,
                    horizontalInterval: 25),
                borderData: FlBorderData(
                    show: false,
                    border: Border(
                        bottom: BorderSide(
                      color: AppColor.gray10.of(context), // 바닥에 그릴 선의 색상
                      width: 1, // 선의 두께
                    ))),
                minX: 0,
                maxX: 10,
                minY: 0,
                maxY: 100,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(),
                  rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 60,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            if (value == 30) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 14.0),
                                child: Text(
                                  '구독자수',
                                  // '←${value.toInt()}만명',
                                  style: TextStyle(fontSize: 12),
                                ),
                              );
                            } else {
                              return Container(); // 나머지 값은 표시하지 않음
                            }
                          })),
                  topTitles: AxisTitles(sideTitles: SideTitles()),
                  bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 20,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            if (value == 1) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 14.0),
                                child: Text(
                                  '24시간',
                                  // '←${value.toInt()}만명',
                                  style: TextStyle(fontSize: 12),
                                ),
                              );
                            } else if (value == 10) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 14.0),
                                child: Text(
                                  '10일',
                                  // '←${value.toInt()}만명',
                                  style: TextStyle(fontSize: 12),
                                ),
                              );
                            } else {
                              return Container(); // 나머지 값은 표시하지 않음
                            }
                          })),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 0),
                      FlSpot(1, 70),
                      FlSpot(2, 70),
                      FlSpot(3, 80),
                      FlSpot(4, 80),
                      FlSpot(5, 90),
                      FlSpot(6, 90),
                      FlSpot(7, 100),
                      FlSpot(8, 100),
                      FlSpot(9, 100),
                      FlSpot(10, 100),
                    ],
                    preventCurveOverShooting: true,
                    isCurved: true,
                    gradient: LinearGradient(colors: [Colors.blue, Colors.red]),
                    barWidth: 5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(colors: [
                        Colors.blue.withValues(alpha: 0.3),
                        Colors.red.withValues(alpha: 0.3)
                      ]),
                      color: Colors.blue.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget groupVideoRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: AppColor.lightGray20.of(context),
            ),
            child: AspectRatio(aspectRatio: 16 / 9, child: Container()),
          ),
        ),
        SizedBox(width: 12),
        Flexible(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('엔비디아  폭삭 망sadfgasdgdsagssdgsdags한 이뉴는?!',
                  style: TextStyle(fontSize: 15),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              SizedBox(height: 4),
              Text('15일 전',
                  style: TextStyle(
                      fontSize: 13, color: AppColor.gray20.of(context))),
            ],
          ),
        ),
      ],
    );
  }

  Row groupViewsRow(BuildContext context) {
    var primaryColor = AppColor.primaryRed.of(context);
    var color = AppColor.gray30.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
            flex: 6,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_fire_department, color: primaryColor),
                  SizedBox(width: 4),
                  Text('720%',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: primaryColor))
                ])),
        SizedBox(
            height: 20,
            child: VerticalDivider(width: 1, thickness: 1, color: color)),
        Flexible(
            flex: 5,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bar_chart, size: 16, color: color),
                  SizedBox(width: 4),
                  Text('3.6만뷰',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: color)),
                ])),
        SizedBox(
            height: 20,
            child: VerticalDivider(width: 1, thickness: 1, color: color)),
        Flexible(
            flex: 5,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.group, size: 16, color: color),
                  SizedBox(width: 4),
                  Text('3.6만명', style: TextStyle(fontSize: 12, color: color))
                ])),
      ],
    );
  }
}
