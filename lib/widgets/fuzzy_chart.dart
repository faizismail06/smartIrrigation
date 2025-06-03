import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smart_irrigation/models/sensor_data.dart';

class FuzzyChart extends StatelessWidget {
  final FuzzyData fuzzyData;

  const FuzzyChart({
    super.key,
    required this.fuzzyData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 1,
                  minY: 0,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: theme.colorScheme.inverseSurface,
                      tooltipPadding: const EdgeInsets.all(8),
                      tooltipMargin: 8,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        String category;
                        switch (groupIndex) {
                          case 0:
                            category = 'Sangat Kering';
                            break;
                          case 1:
                            category = 'Kering';
                            break;
                          case 2:
                            category = 'Lembap';
                            break;
                          case 3:
                            category = 'Basah';
                            break;
                          case 4:
                            category = 'Sangat Basah';
                            break;
                          default:
                            category = '';
                        }
                        return BarTooltipItem(
                          '$category\n',
                          TextStyle(
                            color: theme.colorScheme.onInverseSurface,
                            fontWeight: FontWeight.bold,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: (rod.toY * 100).toStringAsFixed(1) + '%',
                              style: TextStyle(
                                color: theme.colorScheme.onInverseSurface,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          );

                          IconData iconData;
                          Color iconColor;
                          String text;

                          switch (value.toInt()) {
                            case 0:
                              text = 'S.Kering';
                              iconData = Icons.water_drop_outlined;
                              iconColor = const Color(0xFFE57373);
                              break;
                            case 1:
                              text = 'Kering';
                              iconData = Icons.water_drop_outlined;
                              iconColor = const Color(0xFFFFB74D);
                              break;
                            case 2:
                              text = 'Lembap';
                              iconData = Icons.water_drop;
                              iconColor = const Color(0xFF81C784);
                              break;
                            case 3:
                              text = 'Basah';
                              iconData = Icons.water_drop;
                              iconColor = const Color(0xFF4FC3F7);
                              break;
                            case 4:
                              text = 'S.Basah';
                              iconData = Icons.water;
                              iconColor = const Color(0xFF5C6BC0);
                              break;
                            default:
                              text = '';
                              iconData = Icons.water_drop;
                              iconColor = Colors.grey;
                          }

                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Column(
                              children: [
                                Icon(
                                  iconData,
                                  color: iconColor,
                                  size: 16,
                                ),
                                const SizedBox(height: 2),
                                Text(text, style: style),
                              ],
                            ),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 0.2,
                        getTitlesWidget: (value, meta) {
                          if (value == 0) return const SizedBox.shrink();

                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              (value * 100).toInt().toString() + '%',
                              style: TextStyle(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.7),
                                fontSize: 10,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 0.2,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: theme.colorScheme.outline.withOpacity(0.2),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: fuzzyData.veryDry,
                          color: const Color(0xFFE57373),
                          width: 25,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: fuzzyData.dry,
                          color: const Color(0xFFFFB74D),
                          width: 25,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(
                          toY: fuzzyData.moist,
                          color: const Color(0xFF81C784),
                          width: 25,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 3,
                      barRods: [
                        BarChartRodData(
                          toY: fuzzyData.wet,
                          color: const Color(0xFF4FC3F7),
                          width: 25,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 4,
                      barRods: [
                        BarChartRodData(
                          toY: fuzzyData.veryWet,
                          color: const Color(0xFF5C6BC0),
                          width: 25,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Dominan: ',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(fuzzyData.dominantCategory),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    fuzzyData.dominantCategory,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
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

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Sangat Kering':
        return const Color(0xFFE57373);
      case 'Kering':
        return const Color(0xFFFFB74D);
      case 'Lembap':
        return const Color(0xFF81C784);
      case 'Basah':
        return const Color(0xFF4FC3F7);
      case 'Sangat Basah':
        return const Color(0xFF5C6BC0);
      default:
        return Colors.grey;
    }
  }
}
