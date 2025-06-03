import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_irrigation/models/irrigation_system.dart';

class MoistureStatusCard extends StatelessWidget {
  final String moistureStatus;
  final int moistureValue;

  const MoistureStatusCard({
    super.key,
    required this.moistureStatus,
    required this.moistureValue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final threshold =
        Provider.of<IrrigationSystem>(context).systemConfig.moistureThreshold;
    final isDry = moistureStatus == "DRY";

    // Warna untuk status
    final Color statusColor = isDry
        ? const Color(0xFFE57373) // Merah untuk DRY
        : const Color(0xFF81C784); // Hijau untuk WET

    // Icon untuk status
    final IconData statusIcon = isDry
        ? Icons.water_drop_outlined // Empty drop untuk DRY
        : Icons.water_drop; // Filled drop untuk WET

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
            // Status Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                statusIcon,
                color: statusColor,
                size: 36,
              ),
            ),

            const SizedBox(height: 16),

            // Status Text
            Text(
              moistureStatus,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),

            const SizedBox(height: 8),

            // Description
            Text(
              isDry
                  ? 'Tanah dalam kondisi kering'
                  : 'Tanah dalam kondisi basah',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),

            const SizedBox(height: 16),

            // Progress bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Kelembapan:',
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      '$moistureValue / 1000',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Stack(
                    children: [
                      // Background
                      Container(
                        height: 8,
                        color: theme.colorScheme.surfaceVariant,
                      ),

                      // Threshold marker
                      Positioned(
                        left: (threshold /
                                    1000 *
                                    MediaQuery.of(context).size.width -
                                32) -
                            1,
                        child: Container(
                          width: 2,
                          height: 8,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),

                      // Progress
                      Container(
                        height: 8,
                        width: (moistureValue / 1000) *
                            (MediaQuery.of(context).size.width - 32),
                        color: statusColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'DRY',
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color(0xFFE57373),
                      ),
                    ),
                    Text(
                      'WET',
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color(0xFF81C784),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Recommendation
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: isDry
                    ? const Color(0xFFE57373).withOpacity(0.1)
                    : const Color(0xFF81C784).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDry
                      ? const Color(0xFFE57373).withOpacity(0.3)
                      : const Color(0xFF81C784).withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isDry ? Icons.warning_amber : Icons.check_circle,
                    color: isDry
                        ? const Color(0xFFE57373)
                        : const Color(0xFF81C784),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isDry
                          ? 'Tanah membutuhkan penyiraman'
                          : 'Tanah tidak perlu disiram',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
