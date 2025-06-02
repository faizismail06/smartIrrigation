import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:smart_irrigation/models/irrigation_system.dart';
import 'package:smart_irrigation/models/sensor_data.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final irrigationSystem = Provider.of<IrrigationSystem>(context);
    final threshold = irrigationSystem.systemConfig.moistureThreshold;
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Riwayat Data',
          style: TextStyle(
            color: theme.colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: theme.colorScheme.onBackground,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.colorScheme.primary,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.colorScheme.onBackground.withOpacity(0.7),
          tabs: const [
            Tab(text: 'Grafik'),
            Tab(text: 'Log Aktivitas'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Chart Tab
          _buildChartTab(context, irrigationSystem, threshold),
          
          // Log Tab
          _buildLogTab(context, irrigationSystem, threshold),
        ],
      ),
    );
  }
  
  Widget _buildChartTab(BuildContext context, IrrigationSystem irrigationSystem, int threshold) {
    final theme = Theme.of(context);
    final historyData = irrigationSystem.historyData;
    
    if (historyData.isEmpty) {
      return Center(
        child: Text(
          'Belum ada data riwayat',
          style: TextStyle(
            color: theme.colorScheme.onBackground.withOpacity(0.7),
          ),
        ),
      );
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Kelembapan Tanah (24 Jam Terakhir)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onBackground,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Chart
          Card(
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
              child: SizedBox(
                height: 300,
                child: LineChart(
                  _mainLineChartData(context, historyData, threshold),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Title
          Text(
            'Statistik',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onBackground,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Statistics
          _buildStatisticCards(context, historyData, threshold),
        ],
      ),
    );
  }
  
  Widget _buildLogTab(BuildContext context, IrrigationSystem irrigationSystem, int threshold) {
    final theme = Theme.of(context);
    final historyData = irrigationSystem.historyData;
    
    if (historyData.isEmpty) {
      return Center(
        child: Text(
          'Belum ada data log',
          style: TextStyle(
            color: theme.colorScheme.onBackground.withOpacity(0.7),
          ),
        ),
      );
    }
    
    // Reverse history data to show newest first
    final reversedData = historyData.reversed.toList();
    
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: reversedData.length,
      itemBuilder: (context, index) {
        final data = reversedData[index];
        final isToday = data.timestamp.day == DateTime.now().day;
        
        String timeText;
        if (isToday) {
          timeText = 'Hari ini, ${DateFormat('HH:mm').format(data.timestamp)}';
        } else {
          timeText = timeago.format(data.timestamp, locale: 'id');
        }
        
        final isDry = data.moistureStatus == "DRY";
        final statusColor = isDry
            ? const Color(0xFFE57373) // Merah untuk DRY
            : const Color(0xFF81C784); // Hijau untuk WET
        
        return Card(
          elevation: 0,
          color: theme.colorScheme.surface,
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: theme.colorScheme.outline.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isDry ? Icons.water_drop_outlined : Icons.water_drop,
                color: statusColor,
              ),
            ),
            title: Text(
              'Kelembapan: ${data.moisture}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.moistureStatus,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      data.pumpStatus ? Icons.flash_on : Icons.flash_off,
                      color: data.pumpStatus
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withOpacity(0.5),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      data.pumpStatus ? 'Pompa Aktif' : 'Pompa Nonaktif',
                      style: TextStyle(
                        color: data.pumpStatus
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    if (data.pumpStatus) ...[
                      const SizedBox(width: 8),
                      Text(
                        '(${data.pumpDuration}s)',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  timeText,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('dd/MM/yyyy').format(data.timestamp),
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  LineChartData _mainLineChartData(BuildContext context, List<SensorData> historyData, int threshold) {
    final theme = Theme.of(context);
    
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 200,
        getDrawingHorizontalLine: (value) {
          // Special line for threshold
          if (value == threshold.toDouble()) {
            return FlLine(
              color: theme.colorScheme.primary.withOpacity(0.5),
              strokeWidth: 1.5,
              dashArray: [5, 5],
            );
          }
          
          return FlLine(
            color: theme.colorScheme.outline.withOpacity(0.2),
            strokeWidth: 1,
          );
        },
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
            reservedSize: 30,
            interval: historyData.length > 10 ? (historyData.length / 5).floor().toDouble() : 1,
            getTitlesWidget: (value, meta) {
              if (value.toInt() >= historyData.length || value.toInt() < 0) {
                return const SizedBox.shrink();
              }
              
              final timestamp = historyData[value.toInt()].timestamp;
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(
                  DateFormat('HH:mm').format(timestamp),
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    fontSize: 10,
                  ),
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: 200,
            getTitlesWidget: (value, meta) {
              // Special label for threshold
              if (value == threshold.toDouble()) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    '⭐ $threshold',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
              
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    fontSize: 10,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      minX: 0,
      maxX: (historyData.length - 1).toDouble(),
      minY: 0,
      maxY: 1000,
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: theme.colorScheme.inverseSurface,
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((spot) {
              final data = historyData[spot.x.toInt()];
              return LineTooltipItem(
                '${data.moisture}',
                TextStyle(
                  color: theme.colorScheme.onInverseSurface,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: '\n${data.moistureStatus}',
                    style: TextStyle(
                      color: theme.colorScheme.onInverseSurface,
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                  TextSpan(
                    text: '\n${DateFormat('dd/MM HH:mm').format(data.timestamp)}',
                    style: TextStyle(
                      color: theme.colorScheme.onInverseSurface.withOpacity(0.7),
                      fontWeight: FontWeight.normal,
                      fontSize: 10,
                    ),
                  ),
                ],
              );
            }).toList();
          },
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(
            historyData.length,
            (index) => FlSpot(index.toDouble(), historyData[index].moisture.toDouble()),
          ),
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary.withOpacity(0.5),
              theme.colorScheme.primary,
            ],
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
            getDotPainter: _getStatusDotPainter,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary.withOpacity(0.2),
                theme.colorScheme.primary.withOpacity(0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
      extraLinesData: ExtraLinesData(
        horizontalLines: [
          HorizontalLine(
            y: threshold.toDouble(),
            color: theme.colorScheme.primary.withOpacity(0.7),
            strokeWidth: 1.5,
            dashArray: [5, 5],
            label: HorizontalLineLabel(
              show: true,
              alignment: Alignment.topRight,
              padding: const EdgeInsets.only(left: 8),
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              labelResolver: (line) => 'Threshold',
            ),
          ),
        ],
      ),
    );
  }
  
  static FlDotPainter _getStatusDotPainter(spot, percent, barData, index) {
    return FlDotCirclePainter(
      radius: 4,
      color: spot.y >= 500 ? const Color(0xFF81C784) : const Color(0xFFE57373),
      strokeWidth: 1,
      strokeColor: Colors.white,
    );
  }
  
  Widget _buildStatisticCards(BuildContext context, List<SensorData> historyData, int threshold) {
    final theme = Theme.of(context);
    
    // Calculate statistics
    int minMoisture = 1000;
    int maxMoisture = 0;
    int sumMoisture = 0;
    int pumpActiveCount = 0;
    int dryCount = 0;
    int wetCount = 0;
    
    for (final data in historyData) {
      if (data.moisture < minMoisture) minMoisture = data.moisture;
      if (data.moisture > maxMoisture) maxMoisture = data.moisture;
      sumMoisture += data.moisture;
      if (data.pumpStatus) pumpActiveCount++;
      if (data.moistureStatus == "DRY") dryCount++;
      if (data.moistureStatus == "WET") wetCount++;
    }
    
    final avgMoisture = historyData.isNotEmpty ? sumMoisture ~/ historyData.length : 0;
    
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      children: [
        _buildStatCard(
          context,
          title: 'Min. Kelembapan',
          value: minMoisture.toString(),
          icon: Icons.arrow_downward,
          color: const Color(0xFFE57373),
        ),
        _buildStatCard(
          context,
          title: 'Maks. Kelembapan',
          value: maxMoisture.toString(),
          icon: Icons.arrow_upward,
          color: const Color(0xFF81C784),
        ),
        _buildStatCard(
          context,
          title: 'Rata-rata',
          value: avgMoisture.toString(),
          icon: Icons.calculate,
          color: theme.colorScheme.primary,
        ),
        _buildStatCard(
          context,
          title: 'Pompa Aktif',
          value: '$pumpActiveCount kali',
          icon: Icons.flash_on,
          color: const Color(0xFFFFA726),
        ),
        _buildStatCard(
          context,
          title: 'Status DRY',
          value: '$dryCount kali',
          icon: Icons.water_drop_outlined,
          color: const Color(0xFFE57373),
        ),
        _buildStatCard(
          context,
          title: 'Status WET',
          value: '$wetCount kali',
          icon: Icons.water_drop,
          color: const Color(0xFF81C784),
        ),
      ],
    );
  }
  
  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}