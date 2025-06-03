import 'package:intl/intl.dart';

class SensorData {
  final DateTime timestamp;
  final int moisture;
  final bool pumpStatus;
  final int pumpDuration;
  final int pumpRemainingTime;
  final FuzzyData fuzzyData;

  SensorData({
    required this.timestamp,
    required this.moisture,
    required this.pumpStatus,
    required this.pumpDuration,
    required this.pumpRemainingTime,
    required this.fuzzyData,
  });

  // Konstruktor untuk nilai default
  factory SensorData.empty() {
    return SensorData(
      timestamp: DateTime.now(),
      moisture: 0,
      pumpStatus: false,
      pumpDuration: 0,
      pumpRemainingTime: 0,
      fuzzyData: FuzzyData.empty(),
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

    // Pastikan fuzzy_data ada, jika tidak gunakan nilai default
    final fuzzyDataMap = map['fuzzy_data'] as Map<dynamic, dynamic>?;
    final fuzzyData = fuzzyDataMap != null
        ? FuzzyData.fromMap(Map<String, dynamic>.from(fuzzyDataMap))
        : FuzzyData.empty();

    return SensorData(
      timestamp: parsedTimestamp,
      moisture: map['moisture'] ?? 0,
      pumpStatus: map['pump_status'] ?? false,
      pumpDuration: map['pump_duration'] ?? 0,
      pumpRemainingTime: map['pump_remaining_time'] ?? 0,
      fuzzyData: fuzzyData,
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
      'fuzzy_data': fuzzyData.toMap(),
    };
  }

  // Get moisture level category
  String get moistureCategory {
    if (moisture < 200) return 'Sangat Kering';
    if (moisture < 450) return 'Kering';
    if (moisture < 700) return 'Lembap';
    if (moisture < 900) return 'Basah';
    return 'Sangat Basah';
  }

  // Get moisture color
  int get moistureColorValue {
    if (moisture < 200) return 0xFFE57373; // Merah - Sangat Kering
    if (moisture < 450) return 0xFFFFB74D; // Oranye - Kering
    if (moisture < 700) return 0xFF81C784; // Hijau - Lembap
    if (moisture < 900) return 0xFF4FC3F7; // Biru Muda - Basah
    return 0xFF5C6BC0; // Indigo - Sangat Basah
  }
}

class FuzzyData {
  final double veryDry;
  final double dry;
  final double moist;
  final double wet;
  final double veryWet;

  FuzzyData({
    required this.veryDry,
    required this.dry,
    required this.moist,
    required this.wet,
    required this.veryWet,
  });

  // Konstruktor untuk nilai default
  factory FuzzyData.empty() {
    return FuzzyData(
      veryDry: 0.0,
      dry: 0.0,
      moist: 0.0,
      wet: 0.0,
      veryWet: 0.0,
    );
  }

  // Konversi dari Map (Firebase)
  factory FuzzyData.fromMap(Map<String, dynamic> map) {
    return FuzzyData(
      veryDry: (map['very_dry'] ?? 0.0).toDouble(),
      dry: (map['dry'] ?? 0.0).toDouble(),
      moist: (map['moist'] ?? 0.0).toDouble(),
      wet: (map['wet'] ?? 0.0).toDouble(),
      veryWet: (map['very_wet'] ?? 0.0).toDouble(),
    );
  }

  // Konversi ke Map (untuk Firebase)
  Map<String, dynamic> toMap() {
    return {
      'very_dry': veryDry,
      'dry': dry,
      'moist': moist,
      'wet': wet,
      'very_wet': veryWet,
    };
  }

  // Get dominant category
  String get dominantCategory {
    final values = {
      'Sangat Kering': veryDry,
      'Kering': dry,
      'Lembap': moist,
      'Basah': wet,
      'Sangat Basah': veryWet,
    };

    return values.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }
}
