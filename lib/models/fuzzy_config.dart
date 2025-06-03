// class FuzzyConfig {
//   final int veryDryMin;
//   final int veryDryMax;
//   final int dryMin;
//   final int dryMax;
//   final int moistMin;
//   final int moistMax;
//   final int wetMin;
//   final int wetMax;
//   final int veryWetMin;
//   final int veryWetMax;
//   final int pumpDurationVeryLong;
//   final int pumpDurationLong;
//   final int pumpDurationMedium;
//   final int pumpDurationShort;
//   final int pumpDurationNone;

//   FuzzyConfig({
//     required this.veryDryMin,
//     required this.veryDryMax,
//     required this.dryMin,
//     required this.dryMax,
//     required this.moistMin,
//     required this.moistMax,
//     required this.wetMin,
//     required this.wetMax,
//     required this.veryWetMin,
//     required this.veryWetMax,
//     required this.pumpDurationVeryLong,
//     required this.pumpDurationLong,
//     required this.pumpDurationMedium,
//     required this.pumpDurationShort,
//     required this.pumpDurationNone,
//   });

//   // Konfigurasi default
//   factory FuzzyConfig.defaultConfig() {
//     return FuzzyConfig(
//       veryDryMin: 0,
//       veryDryMax: 200,
//       dryMin: 150,
//       dryMax: 450,
//       moistMin: 400,
//       moistMax: 700,
//       wetMin: 650,
//       wetMax: 900,
//       veryWetMin: 850,
//       veryWetMax: 1000,
//       pumpDurationVeryLong: 20,
//       pumpDurationLong: 10,
//       pumpDurationMedium: 5,
//       pumpDurationShort: 2,
//       pumpDurationNone: 0,
//     );
//   }

//   // Konversi dari Map (Firebase)
//   factory FuzzyConfig.fromMap(Map<String, dynamic> map) {
//     return FuzzyConfig(
//       veryDryMin: map['very_dry_min'] ?? 0,
//       veryDryMax: map['very_dry_max'] ?? 200,
//       dryMin: map['dry_min'] ?? 150,
//       dryMax: map['dry_max'] ?? 450,
//       moistMin: map['moist_min'] ?? 400,
//       moistMax: map['moist_max'] ?? 700,
//       wetMin: map['wet_min'] ?? 650,
//       wetMax: map['wet_max'] ?? 900,
//       veryWetMin: map['very_wet_min'] ?? 850,
//       veryWetMax: map['very_wet_max'] ?? 1000,
//       pumpDurationVeryLong: map['pump_duration_very_long'] ?? 20,
//       pumpDurationLong: map['pump_duration_long'] ?? 10,
//       pumpDurationMedium: map['pump_duration_medium'] ?? 5,
//       pumpDurationShort: map['pump_duration_short'] ?? 2,
//       pumpDurationNone: map['pump_duration_none'] ?? 0,
//     );
//   }

//   // Konversi ke Map (untuk Firebase)
//   Map<String, dynamic> toMap() {
//     return {
//       'very_dry_min': veryDryMin,
//       'very_dry_max': veryDryMax,
//       'dry_min': dryMin,
//       'dry_max': dryMax,
//       'moist_min': moistMin,
//       'moist_max': moistMax,
//       'wet_min': wetMin,
//       'wet_max': wetMax,
//       'very_wet_min': veryWetMin,
//       'very_wet_max': veryWetMax,
//       'pump_duration_very_long': pumpDurationVeryLong,
//       'pump_duration_long': pumpDurationLong,
//       'pump_duration_medium': pumpDurationMedium,
//       'pump_duration_short': pumpDurationShort,
//       'pump_duration_none': pumpDurationNone,
//     };
//   }

//   // Copy with untuk update nilai
//   FuzzyConfig copyWith({
//     int? veryDryMin,
//     int? veryDryMax,
//     int? dryMin,
//     int? dryMax,
//     int? moistMin,
//     int? moistMax,
//     int? wetMin,
//     int? wetMax,
//     int? veryWetMin,
//     int? veryWetMax,
//     int? pumpDurationVeryLong,
//     int? pumpDurationLong,
//     int? pumpDurationMedium,
//     int? pumpDurationShort,
//     int? pumpDurationNone,
//   }) {
//     return FuzzyConfig(
//       veryDryMin: veryDryMin ?? this.veryDryMin,
//       veryDryMax: veryDryMax ?? this.veryDryMax,
//       dryMin: dryMin ?? this.dryMin,
//       dryMax: dryMax ?? this.dryMax,
//       moistMin: moistMin ?? this.moistMin,
//       moistMax: moistMax ?? this.moistMax,
//       wetMin: wetMin ?? this.wetMin,
//       wetMax: wetMax ?? this.wetMax,
//       veryWetMin: veryWetMin ?? this.veryWetMin,
//       veryWetMax: veryWetMax ?? this.veryWetMax,
//       pumpDurationVeryLong: pumpDurationVeryLong ?? this.pumpDurationVeryLong,
//       pumpDurationLong: pumpDurationLong ?? this.pumpDurationLong,
//       pumpDurationMedium: pumpDurationMedium ?? this.pumpDurationMedium,
//       pumpDurationShort: pumpDurationShort ?? this.pumpDurationShort,
//       pumpDurationNone: pumpDurationNone ?? this.pumpDurationNone,
//     );
//   }
// }
