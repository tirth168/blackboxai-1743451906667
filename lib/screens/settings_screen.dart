import 'package:flutter/material.dart';
import 'package:image_editing_app/controllers/ai_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _apiKey = '';
  double _exportQuality = 0.8;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('AI Service', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(
              labelText: 'API Key',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => _apiKey = value,
          ),
          const SizedBox(height: 24),
          const Text('Export Settings', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Slider(
            value: _exportQuality,
            min: 0.1,
            max: 1.0,
            divisions: 9,
            label: 'Quality: ${(_exportQuality * 100).round()}%',
            onChanged: (value) => setState(() => _exportQuality = value),
          ),
          const SizedBox(height: 24),
          const Text('Appearance', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _darkMode,
            onChanged: (value) => setState(() => _darkMode = value),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              AIController().setApiKey(_apiKey);
              Navigator.pop(context);
            },
            child: const Text('Save Settings'),
          ),
        ],
      ),
    );
  }
}