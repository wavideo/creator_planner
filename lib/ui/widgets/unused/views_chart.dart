import 'package:creator_planner/core/theme/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ViewsChart extends StatelessWidget {
  const ViewsChart(
    this.context, {
    super.key,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
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
}
