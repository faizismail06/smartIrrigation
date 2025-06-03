import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:smart_irrigation/models/system_config.dart';
import 'package:smart_irrigation/models/sensor_data.dart';
import 'package:smart_irrigation/services/firebase_service.dart';

class IrrigationSystem with ChangeNotifier {
  final FirebaseService _firebaseService;

  SensorData _currentData = SensorData.empty();
  SystemConfig _systemConfig = SystemConfig.defaultConfig();
  List<SensorData> _historyData = [];
  bool _isSystemActive = true;
  bool _isLoading = true;

  // Konstruktor
  IrrigationSystem(this._firebaseService) {
    _initializeData();
  }

  // Getters
  SensorData get currentData => _currentData;
  SystemConfig get systemConfig => _systemConfig;
  List<SensorData> get historyData => _historyData;
  bool get isSystemActive => _isSystemActive;
  bool get isLoading => _isLoading;

  // Inisialisasi data
  Future<void> _initializeData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Ambil konfigurasi sistem
      _systemConfig = await _firebaseService.getSystemConfig();

      // Ambil status sistem
      _isSystemActive = await _firebaseService.getSystemStatus();

      // Langganan data sensor terbaru
      _firebaseService.latestSensorData.listen((data) {
        _currentData = data;
        notifyListeners();
      });

      // Langganan data riwayat
      _firebaseService.streamSensorHistory(50).listen((history) {
        _historyData = history;
        notifyListeners();
      });

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing data: $e');
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update konfigurasi sistem
  Future<void> updateSystemConfig(SystemConfig newConfig) async {
    try {
      await _firebaseService.updateSystemConfig(newConfig);
      _systemConfig = newConfig;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error updating system config: $e');
      }
      rethrow;
    }
  }

  // Nyalakan/matikan sistem
  Future<void> toggleSystemStatus() async {
    try {
      final newStatus = !_isSystemActive;
      await _firebaseService.updateSystemStatus(newStatus);
      _isSystemActive = newStatus;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error toggling system status: $e');
      }
      rethrow;
    }
  }

  // Nyalakan pompa secara manual
  Future<void> triggerPumpManually(int durationSeconds) async {
    try {
      await _firebaseService.triggerPumpManually(durationSeconds);
    } catch (e) {
      if (kDebugMode) {
        print('Error triggering pump manually: $e');
      }
      rethrow;
    }
  }

  // Muat ulang semua data
  Future<void> refreshData() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _initializeData();
    } catch (e) {
      if (kDebugMode) {
        print('Error refreshing data: $e');
      }
      _isLoading = false;
      notifyListeners();
    }
  }
}
