import 'package:intl/intl.dart';

class SensorData {
  final DateTime timestamp;
  final int moisture;
  final bool pumpStatus;
  final int pumpDuration;
  final int pumpRemainingTime;
  final String moistureStatus; // "DRY" atau "WET"

  SensorData({
    required this.timestamp,
    required this.moisture,
    required this.pumpStatus,
    required this.pumpDuration,
    required this.pumpRemainingTime,
    required this.moistureStatus,
  });

  // Konstruktor untuk nilai default
  factory SensorData.empty() {
    return SensorData(
      timestamp: DateTime.now(),
      moisture: 0,
      pumpStatus: false,
      pumpDuration: 0,
      pumpRemainingTime: 0,
      moistureStatus: "DRY",
    );
  }

  // Konversi dari Map (Firebase)
  factory SensorData.fromMap(Map<String, dynamic> map) {
    // Konversi timestamp dari berbagai format yang mungkin
    DateTime parsedTimestamp;
    final timestamp = map['timestamp'];

    if (timestamp is int) {
      // Unix timestamp (milliseconds)
      parsedTimestamp = DateTime.fromMillisecondsSinceEpoch(timestamp);
    } else if (timestamp is String) {
      try {
        // ISO format atau format custom lainnya
        parsedTimestamp = DateTime.parse(timestamp);
      } catch (e) {
        // Format yang mungkin: "2025-05-31 12:34:56"
        try {
          parsedTimestamp = DateFormat('yyyy-MM-dd HH:mm:ss').parse(timestamp);
        } catch (e) {
          parsedTimestamp = DateTime.now();
        }
      }
    } else {
      parsedTimestamp = DateTime.now();
    }

    return SensorData(
      timestamp: parsedTimestamp,
      moisture: map['moisture'] ?? 0,
      pumpStatus: map['pump_status'] ?? false,
      pumpDuration: map['pump_duration'] ?? 0,
      pumpRemainingTime: map['pump_remaining_time'] ?? 0,
      moistureStatus: map['moisture_status'] ?? "DRY",
    );
  }

  // Konversi ke Map (untuk Firebase)
  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'moisture': moisture,
      'pump_status': pumpStatus,
      'pump_duration': pumpDuration,
      'pump_remaining_time': pumpRemainingTime,
      'moisture_status': moistureStatus,
    };
  }

  // Get moisture color
  int get moistureColorValue {
    return moistureStatus == "DRY"
        ? 0xFFE57373 // Merah untuk DRY
        : 0xFF81C784; // Hijau untuk WET
  }
}
