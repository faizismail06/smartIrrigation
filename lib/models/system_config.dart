class SystemConfig {
  final int moistureThreshold;
  final int pumpDurationLong;
  final int pumpDurationNone;
  
  SystemConfig({
    required this.moistureThreshold,
    required this.pumpDurationLong,
    required this.pumpDurationNone,
  });
  
  // Konfigurasi default
  factory SystemConfig.defaultConfig() {
    return SystemConfig(
      moistureThreshold: 500,
      pumpDurationLong: 20,
      pumpDurationNone: 0,
    );
  }
  
  // Konversi dari Map (Firebase)
  factory SystemConfig.fromMap(Map<String, dynamic> map) {
    return SystemConfig(
      moistureThreshold: map['moisture_threshold'] ?? 500,
      pumpDurationLong: map['pump_duration_long'] ?? 20,
      pumpDurationNone: map['pump_duration_none'] ?? 0,
    );
  }
  
  // Konversi ke Map (untuk Firebase)
  Map<String, dynamic> toMap() {
    return {
      'moisture_threshold': moistureThreshold,
      'pump_duration_long': pumpDurationLong,
      'pump_duration_none': pumpDurationNone,
    };
  }
  
  // Copy with untuk update nilai
  SystemConfig copyWith({
    int? moistureThreshold,
    int? pumpDurationLong,
    int? pumpDurationNone,
  }) {
    return SystemConfig(
      moistureThreshold: moistureThreshold ?? this.moistureThreshold,
      pumpDurationLong: pumpDurationLong ?? this.pumpDurationLong,
      pumpDurationNone: pumpDurationNone ?? this.pumpDurationNone,
    );
  }
}