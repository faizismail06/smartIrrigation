import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_irrigation/models/fuzzy_config.dart';
import 'package:smart_irrigation/models/irrigation_system.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late FuzzyConfig _fuzzyConfig;
  bool _isLoading = false;
  bool _isEditing = false;

  // Controllers for text fields
  final TextEditingController _veryDryMinController = TextEditingController();
  final TextEditingController _veryDryMaxController = TextEditingController();
  final TextEditingController _dryMinController = TextEditingController();
  final TextEditingController _dryMaxController = TextEditingController();
  final TextEditingController _moistMinController = TextEditingController();
  final TextEditingController _moistMaxController = TextEditingController();
  final TextEditingController _wetMinController = TextEditingController();
  final TextEditingController _wetMaxController = TextEditingController();
  final TextEditingController _veryWetMinController = TextEditingController();
  final TextEditingController _veryWetMaxController = TextEditingController();

  final TextEditingController _pumpDurationVeryLongController =
      TextEditingController();
  final TextEditingController _pumpDurationLongController =
      TextEditingController();
  final TextEditingController _pumpDurationMediumController =
      TextEditingController();
  final TextEditingController _pumpDurationShortController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final irrigationSystem =
          Provider.of<IrrigationSystem>(context, listen: false);
      _fuzzyConfig = irrigationSystem.fuzzyConfig;
      _updateTextControllers();
    });
  }

  @override
  void dispose() {
    _veryDryMinController.dispose();
    _veryDryMaxController.dispose();
    _dryMinController.dispose();
    _dryMaxController.dispose();
    _moistMinController.dispose();
    _moistMaxController.dispose();
    _wetMinController.dispose();
    _wetMaxController.dispose();
    _veryWetMinController.dispose();
    _veryWetMaxController.dispose();

    _pumpDurationVeryLongController.dispose();
    _pumpDurationLongController.dispose();
    _pumpDurationMediumController.dispose();
    _pumpDurationShortController.dispose();

    super.dispose();
  }

  void _updateTextControllers() {
    _veryDryMinController.text = _fuzzyConfig.veryDryMin.toString();
    _veryDryMaxController.text = _fuzzyConfig.veryDryMax.toString();
    _dryMinController.text = _fuzzyConfig.dryMin.toString();
    _dryMaxController.text = _fuzzyConfig.dryMax.toString();
    _moistMinController.text = _fuzzyConfig.moistMin.toString();
    _moistMaxController.text = _fuzzyConfig.moistMax.toString();
    _wetMinController.text = _fuzzyConfig.wetMin.toString();
    _wetMaxController.text = _fuzzyConfig.wetMax.toString();
    _veryWetMinController.text = _fuzzyConfig.veryWetMin.toString();
    _veryWetMaxController.text = _fuzzyConfig.veryWetMax.toString();

    _pumpDurationVeryLongController.text =
        _fuzzyConfig.pumpDurationVeryLong.toString();
    _pumpDurationLongController.text = _fuzzyConfig.pumpDurationLong.toString();
    _pumpDurationMediumController.text =
        _fuzzyConfig.pumpDurationMedium.toString();
    _pumpDurationShortController.text =
        _fuzzyConfig.pumpDurationShort.toString();
  }

  Future<void> _saveChanges() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Parse values from controllers
      final updatedConfig = FuzzyConfig(
        veryDryMin: int.parse(_veryDryMinController.text),
        veryDryMax: int.parse(_veryDryMaxController.text),
        dryMin: int.parse(_dryMinController.text),
        dryMax: int.parse(_dryMaxController.text),
        moistMin: int.parse(_moistMinController.text),
        moistMax: int.parse(_moistMaxController.text),
        wetMin: int.parse(_wetMinController.text),
        wetMax: int.parse(_wetMaxController.text),
        veryWetMin: int.parse(_veryWetMinController.text),
        veryWetMax: int.parse(_veryWetMaxController.text),
        pumpDurationVeryLong: int.parse(_pumpDurationVeryLongController.text),
        pumpDurationLong: int.parse(_pumpDurationLongController.text),
        pumpDurationMedium: int.parse(_pumpDurationMediumController.text),
        pumpDurationShort: int.parse(_pumpDurationShortController.text),
        pumpDurationNone: 0, // Always 0
      );

      // Save to Firebase
      final irrigationSystem =
          Provider.of<IrrigationSystem>(context, listen: false);
      await irrigationSystem.updateFuzzyConfig(updatedConfig);

      setState(() {
        _fuzzyConfig = updatedConfig;
        _isEditing = false;
      });

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Konfigurasi berhasil disimpan'),
            backgroundColor: Theme.of(context).colorScheme.secondary,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan konfigurasi: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _resetToDefault() {
    final defaultConfig = FuzzyConfig.defaultConfig();

    setState(() {
      _fuzzyConfig = defaultConfig;
      _updateTextControllers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Pengaturan',
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
        actions: [
          if (_isEditing) ...[
            IconButton(
              icon: const Icon(Icons.restore),
              color: theme.colorScheme.error,
              onPressed: _resetToDefault,
              tooltip: 'Reset ke Default',
            ),
            IconButton(
              icon: const Icon(Icons.save),
              color: theme.colorScheme.primary,
              onPressed: _saveChanges,
              tooltip: 'Simpan Perubahan',
            ),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.edit),
              color: theme.colorScheme.primary,
              onPressed: () => setState(() => _isEditing = true),
              tooltip: 'Edit Konfigurasi',
            ),
          ],
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fuzzy Membership Ranges
                  Text(
                    'Rentang Kelembapan Fuzzy',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Atur rentang nilai kelembapan untuk setiap kategori fuzzy',
                    style: TextStyle(
                      color: theme.colorScheme.onBackground.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Membership Ranges Card
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
                      child: Column(
                        children: [
                          _buildRangeInput(
                            context,
                            title: 'Sangat Kering',
                            minController: _veryDryMinController,
                            maxController: _veryDryMaxController,
                            color: const Color(0xFFE57373),
                            enabled: _isEditing,
                          ),
                          const Divider(),
                          _buildRangeInput(
                            context,
                            title: 'Kering',
                            minController: _dryMinController,
                            maxController: _dryMaxController,
                            color: const Color(0xFFFFB74D),
                            enabled: _isEditing,
                          ),
                          const Divider(),
                          _buildRangeInput(
                            context,
                            title: 'Lembap',
                            minController: _moistMinController,
                            maxController: _moistMaxController,
                            color: const Color(0xFF81C784),
                            enabled: _isEditing,
                          ),
                          const Divider(),
                          _buildRangeInput(
                            context,
                            title: 'Basah',
                            minController: _wetMinController,
                            maxController: _wetMaxController,
                            color: const Color(0xFF4FC3F7),
                            enabled: _isEditing,
                          ),
                          const Divider(),
                          _buildRangeInput(
                            context,
                            title: 'Sangat Basah',
                            minController: _veryWetMinController,
                            maxController: _veryWetMaxController,
                            color: const Color(0xFF5C6BC0),
                            enabled: _isEditing,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Pump Duration Settings
                  Text(
                    'Durasi Pompa',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Atur durasi pompa untuk setiap kategori kelembapan (dalam detik)',
                    style: TextStyle(
                      color: theme.colorScheme.onBackground.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Pump Duration Card
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
                      child: Column(
                        children: [
                          _buildDurationInput(
                            context,
                            title: 'Sangat Kering',
                            controller: _pumpDurationVeryLongController,
                            color: const Color(0xFFE57373),
                            enabled: _isEditing,
                          ),
                          const Divider(),
                          _buildDurationInput(
                            context,
                            title: 'Kering',
                            controller: _pumpDurationLongController,
                            color: const Color(0xFFFFB74D),
                            enabled: _isEditing,
                          ),
                          const Divider(),
                          _buildDurationInput(
                            context,
                            title: 'Lembap',
                            controller: _pumpDurationMediumController,
                            color: const Color(0xFF81C784),
                            enabled: _isEditing,
                          ),
                          const Divider(),
                          _buildDurationInput(
                            context,
                            title: 'Basah',
                            controller: _pumpDurationShortController,
                            color: const Color(0xFF4FC3F7),
                            enabled: _isEditing,
                          ),
                          const Divider(),
                          ListTile(
                            leading: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFF5C6BC0).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.water,
                                color: Color(0xFF5C6BC0),
                                size: 16,
                              ),
                            ),
                            title: const Text('Sangat Basah'),
                            trailing: const Text(
                              '0 detik',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: const Text('Pompa selalu mati'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Info
                  if (!_isEditing) ...[
                    Card(
                      elevation: 0,
                      color: theme.colorScheme.primaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Informasi',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tekan tombol Edit di pojok kanan atas untuk mengubah konfigurasi sistem fuzzy.',
                              style: TextStyle(
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  // Save Button
                  if (_isEditing) ...[
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text('Simpan Perubahan'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _isLoading ? null : _saveChanges,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.restore),
                        label: const Text('Reset ke Default'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: theme.colorScheme.error,
                          side: BorderSide(color: theme.colorScheme.error),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _isLoading ? null : _resetToDefault,
                      ),
                    ),
                  ],

                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _buildRangeInput(
    BuildContext context, {
    required String title,
    required TextEditingController minController,
    required TextEditingController maxController,
    required Color color,
    required bool enabled,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.water_drop,
                color: color,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: minController,
                enabled: enabled,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Min',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  isDense: true,
                ),
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: maxController,
                enabled: enabled,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Max',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  isDense: true,
                ),
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDurationInput(
    BuildContext context, {
    required String title,
    required TextEditingController controller,
    required Color color,
    required bool enabled,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.water_drop,
            color: color,
            size: 16,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Durasi pompa saat kelembapan $title',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 80,
          child: TextField(
            controller: controller,
            enabled: enabled,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              suffix: const Text('s'),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              isDense: true,
            ),
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
