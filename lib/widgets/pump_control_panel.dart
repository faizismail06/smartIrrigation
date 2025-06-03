import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PumpControlPanel extends StatefulWidget {
  final bool pumpStatus;
  final int pumpDuration;
  final int pumpRemainingTime;
  final Function(int) onManualPump;

  const PumpControlPanel({
    super.key,
    required this.pumpStatus,
    required this.pumpDuration,
    required this.pumpRemainingTime,
    required this.onManualPump,
  });

  @override
  State<PumpControlPanel> createState() => _PumpControlPanelState();
}

class _PumpControlPanelState extends State<PumpControlPanel> {
  int _selectedDuration = 5;

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
            // Pump Status Animation
            SizedBox(
              height: 100,
              child: widget.pumpStatus
                  ? Lottie.network(
                      'https://lottie.host/eba0ee1d-05c3-4dab-b1cc-f6833c95e52a/1U7Yi9eyrc.json',
                      animate: true,
                      repeat: true,
                    )
                  : Lottie.network(
                      'https://assets3.lottiefiles.com/packages/lf20_usmfx6bp.json',
                      animate: true,
                      repeat: false,
                    ),
            ),

            const SizedBox(height: 16),

            // Pump Status
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.pumpStatus ? Icons.flash_on : Icons.flash_off,
                  color: widget.pumpStatus
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withOpacity(0.5),
                ),
                const SizedBox(width: 8),
                Text(
                  'Status Pompa: ${widget.pumpStatus ? 'AKTIF' : 'NONAKTIF'}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: widget.pumpStatus
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),

            // Show remaining time if pump is active
            if (widget.pumpStatus) ...[
              const SizedBox(height: 8),
              Text(
                'Durasi: ${widget.pumpDuration} detik',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Sisa Waktu: ${widget.pumpRemainingTime} detik',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: widget.pumpRemainingTime / widget.pumpDuration,
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  color: theme.colorScheme.primary,
                  minHeight: 8,
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Manual Control
            Text(
              'Kontrol Manual',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: 16),

            // Duration Selection
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDurationChip(context, 5),
                _buildDurationChip(context, 10),
                _buildDurationChip(context, 15),
                _buildDurationChip(context, 20),
              ],
            ),

            const SizedBox(height: 16),

            // Activate Pump Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.power_settings_new),
                label: const Text('Nyalakan Pompa'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor:
                      theme.colorScheme.onSurface.withOpacity(0.12),
                  disabledForegroundColor:
                      theme.colorScheme.onSurface.withOpacity(0.38),
                ),
                onPressed: widget.pumpStatus
                    ? null
                    : () => _activatePumpManually(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationChip(BuildContext context, int duration) {
    final theme = Theme.of(context);
    final isSelected = _selectedDuration == duration;

    return ChoiceChip(
      label: Text('${duration}s'),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedDuration = duration;
          });
        }
      },
      backgroundColor: theme.colorScheme.surfaceVariant,
      selectedColor: theme.colorScheme.primary,
      labelStyle: TextStyle(
        color: isSelected
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSurfaceVariant,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  void _activatePumpManually(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          'Nyalakan Pompa Manual',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
          ),
        ),
        content: Text(
          'Pompa akan menyala selama $_selectedDuration detik. Lanjutkan?',
          style: TextStyle(
            color: theme.colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        actions: [
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
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
            ),
            child: const Text('Nyalakan'),
            onPressed: () {
              widget.onManualPump(_selectedDuration);
              Navigator.of(context).pop();

              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Pompa dinyalakan selama $_selectedDuration detik',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  backgroundColor: theme.colorScheme.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
