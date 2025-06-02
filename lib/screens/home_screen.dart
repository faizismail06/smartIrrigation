import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:smart_irrigation/models/irrigation_system.dart';
import 'package:smart_irrigation/screens/history_screen.dart';
import 'package:smart_irrigation/screens/settings_screen.dart';
import 'package:smart_irrigation/widgets/pump_control_panel.dart';
import 'package:smart_irrigation/widgets/status_card.dart';
import 'package:smart_irrigation/widgets/moisture_status_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final irrigationSystem = Provider.of<IrrigationSystem>(context);

    if (irrigationSystem.isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: theme.colorScheme.primary,
          ),
        ),
      );
    }

    final currentData = irrigationSystem.currentData;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Smart Irrigation',
          style: TextStyle(
            color: theme.colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: theme.colorScheme.onBackground,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => irrigationSystem.refreshData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // System Status Card
              StatusCard(
                title: 'Status Sistem',
                value: irrigationSystem.isSystemActive ? 'Aktif' : 'Nonaktif',
                icon: Icons.power_settings_new,
                color: irrigationSystem.isSystemActive
                    ? theme.colorScheme.secondary
                    : theme.colorScheme.error,
                onTap: () => _confirmToggleSystem(context, irrigationSystem),
              ),

              const SizedBox(height: 16),

              // Last Update
              Center(
                child: Text(
                  'Pembaruan Terakhir: ${DateFormat('dd MMM yyyy, HH:mm:ss').format(currentData.timestamp)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onBackground.withOpacity(0.6),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Moisture Gauge
              Text(
                'Kelembapan Tanah',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 8),
              _buildMoistureGauge(context, currentData.moisture),

              const SizedBox(height: 16),

              // Moisture Status Card - Pengganti Fuzzy Chart
              // Moisture Status Card - Pengganti Fuzzy Chart
              MoistureStatusCard(
                moistureStatus: currentData.moistureStatus,
                moistureValue: currentData.moisture,
              ),

              const SizedBox(height: 24),

// Pump Control Panel
              Text(
                'Kontrol Pompa',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 16),
              PumpControlPanel(
                pumpStatus: currentData.pumpStatus,
                pumpDuration: currentData.pumpDuration,
                pumpRemainingTime: currentData.pumpRemainingTime,
                // PERBAIKAN: Buat callback yang mengembalikan Future
                onManualPump: (duration) async {
                  try {
                    // Pastikan method ini mengembalikan Future
                    await irrigationSystem.triggerPumpManually(duration);
                  } catch (e) {
                    // Re-throw error agar bisa ditangkap oleh PumpControlPanel
                    throw 'Gagal mengaktifkan pompa: $e';
                  }
                },
              ),

              const SizedBox(height: 24),

// View History Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.history),
                  label: const Text('Lihat Riwayat'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HistoryScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoistureGauge(BuildContext context, int moistureValue) {
    final theme = Theme.of(context);
    final threshold =
        Provider.of<IrrigationSystem>(context).systemConfig.moistureThreshold;

    return SizedBox(
      height: 200,
      child: SfRadialGauge(
        enableLoadingAnimation: true,
        animationDuration: 2000,
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 1000,
            startAngle: 150,
            endAngle: 30,
            interval: 200,
            radiusFactor: 0.8,
            showLabels: true,
            showAxisLine: true,
            showTicks: true,
            labelsPosition: ElementsPosition.outside,
            axisLabelStyle: GaugeTextStyle(
              color: theme.colorScheme.onBackground,
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
            majorTickStyle: MajorTickStyle(
              length: 10,
              thickness: 1.5,
              color: theme.colorScheme.onBackground,
            ),
            minorTickStyle: MinorTickStyle(
              length: 5,
              thickness: 1,
              color: theme.colorScheme.onBackground,
            ),
            axisLineStyle: AxisLineStyle(
              thickness: 10,
              color: theme.colorScheme.surfaceVariant,
              cornerStyle: CornerStyle.bothCurve,
            ),
            ranges: <GaugeRange>[
              GaugeRange(
                startValue: 0,
                endValue: threshold.toDouble(),
                color: const Color(0xFFE57373), // Merah untuk DRY
                startWidth: 10,
                endWidth: 10,
              ),
              GaugeRange(
                startValue: threshold.toDouble(),
                endValue: 1000,
                color: const Color(0xFF81C784), // Hijau untuk WET
                startWidth: 10,
                endWidth: 10,
              ),
            ],
            pointers: <GaugePointer>[
              NeedlePointer(
                value: moistureValue.toDouble(),
                needleLength: 0.7,
                needleStartWidth: 1,
                needleEndWidth: 6,
                knobStyle: KnobStyle(
                  knobRadius: 0.1,
                  color: theme.colorScheme.primary,
                ),
                needleColor: theme.colorScheme.primary,
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      moistureValue.toString(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Text(
                      'Nilai',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onBackground.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                angle: 90,
                positionFactor: 0.5,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirmToggleSystem(
      BuildContext context, IrrigationSystem irrigationSystem) async {
    final isActive = irrigationSystem.isSystemActive;
    final theme = Theme.of(context);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          title: Text(
            isActive ? 'Nonaktifkan Sistem?' : 'Aktifkan Sistem?',
            style: TextStyle(
              color: theme.colorScheme.onSurface,
            ),
          ),
          content: Text(
            isActive
                ? 'Pompa tidak akan menyala otomatis jika sistem dinonaktifkan.'
                : 'Pompa akan menyala otomatis berdasarkan kelembapan tanah.',
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Batal',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: isActive
                    ? theme.colorScheme.error
                    : theme.colorScheme.secondary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
              child: Text(
                isActive ? 'Nonaktifkan' : 'Aktifkan',
              ),
              onPressed: () {
                irrigationSystem.toggleSystemStatus();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
