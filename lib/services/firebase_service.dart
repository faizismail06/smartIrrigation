import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:smart_irrigation/models/fuzzy_config.dart';
import 'package:smart_irrigation/models/sensor_data.dart';

class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Stream untuk data sensor terbaru
  Stream<SensorData> get latestSensorData {
    return _database
        .child('irrigation-system/sensor_data')
        .onValue
        .map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return SensorData.empty();

      return SensorData.fromMap(Map<String, dynamic>.from(data));
    });
  }

  // Mendapatkan konfigurasi fuzzy
  Future<FuzzyConfig> getFuzzyConfig() async {
    final snapshot =
        await _database.child('irrigation-system/fuzzy_config').get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      return FuzzyConfig.fromMap(Map<String, dynamic>.from(data));
    } else {
      return FuzzyConfig.defaultConfig();
    }
  }

  // Update konfigurasi fuzzy
  Future<void> updateFuzzyConfig(FuzzyConfig config) async {
    await _database
        .child('irrigation-system/fuzzy_config')
        .update(config.toMap());
  }

  // Mendapatkan riwayat data sensor
  Future<List<SensorData>> getSensorHistory(int limitToLast) async {
    final snapshot = await _database
        .child('irrigation-system/sensor_history')
        .limitToLast(limitToLast)
        .get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      final List<SensorData> history = [];

      data.forEach((key, value) {
        history.add(SensorData.fromMap(Map<String, dynamic>.from(value)));
      });

      // Urutkan berdasarkan timestamp
      history.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      return history;
    } else {
      return [];
    }
  }

  // Stream untuk riwayat data sensor terbaru
  Stream<List<SensorData>> streamSensorHistory(int limitToLast) {
    return _database
        .child('irrigation-system/sensor_history')
        .limitToLast(limitToLast)
        .onValue
        .map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return <SensorData>[];

      final List<SensorData> history = [];
      data.forEach((key, value) {
        history.add(SensorData.fromMap(Map<String, dynamic>.from(value)));
      });

      // Urutkan berdasarkan timestamp
      history.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      return history;
    });
  }

  // Mendapatkan status sistem terbaru
  Future<bool> getSystemStatus() async {
    final snapshot =
        await _database.child('irrigation-system/system_status').get();
    if (snapshot.exists) {
      return snapshot.value as bool;
    } else {
      return true; // Default status adalah aktif
    }
  }

  // Mengubah status sistem (aktif/nonaktif)
  Future<void> updateSystemStatus(bool isActive) async {
    await _database.child('irrigation-system/system_status').set(isActive);
  }

  void startCountdown(int duration) async {
    for (int i = duration; i >= 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      await _database
          .child('irrigation-system/sensor_data/pump_remaining_time')
          .set(i);
    }

    // Setelah countdown selesai, matikan pompa
    await _database
        .child('irrigation-system/sensor_data/pump_status')
        .set(false);
  }

  // Memaksa pompa menyala secara manual
  Future<void> triggerPumpManually(int durationSeconds) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _database.child('irrigation-system/sensor_data').update({
      'pump_status': true,
      'pump_duration': durationSeconds,
      'pump_remaining_time': durationSeconds,
      'timestamp': now,
    });

    // Mulai countdown di sisi client
    startCountdown(durationSeconds);
  }
}
