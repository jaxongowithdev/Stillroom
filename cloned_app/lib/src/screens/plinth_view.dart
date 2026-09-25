import 'package:flutter/material.dart';
import '../database/storage_manager.dart';
import '../models/user_preferences.dart';
import '../utils/visual_theme.dart';

class PlinthView extends StatefulWidget {
  final VoidCallback onPrefsChanged;
  const PlinthView({super.key, required this.onPrefsChanged});

  @override
  State<PlinthView> createState() => _PlinthViewState();
}

class _PlinthViewState extends State<PlinthView> {
  UserPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await StorageManager.instance.getPreferences();
    if (!mounted) return;
    setState(() => _prefs = prefs);
  }

  Future<void> _save(UserPreferences next) async {
    await StorageManager.instance.savePreferences(next);
    widget.onPrefsChanged();
    setState(() => _prefs = next);
  }

  @override
  Widget build(BuildContext context) {
    final prefs = _prefs;
    final ink = VisualTheme.inkOf(context);
    final muted = VisualTheme.mutedOf(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Plinth')),
      body: prefs == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              children: [
                Text('WALK ASPECT', style: VisualTheme.micro(9, color: VisualTheme.fuchsia)),
                const SizedBox(height: 8),
                ...[
                  ('ease', 'Ease'),
                  ('sleep', 'Sleep'),
                  ('stretch', 'Stretch'),
                  ('sit', 'Sit'),
                ].map(
                  (g) => _Pick(
                    label: g.$2,
                    selected: prefs.aspect == g.$1,
                    onTap: () => _save(prefs.copyWith(aspect: g.$1)),
                  ),
                ),
                const SizedBox(height: 18),
                Text('MINUTES', style: VisualTheme.micro(9, color: VisualTheme.fuchsia)),
                const SizedBox(height: 8),
                ...VisualTheme.minuteChoices.map(
                  (m) => _Pick(
                    label: '$m minutes',
                    selected: prefs.minutes == m,
                    onTap: () => _save(prefs.copyWith(minutes: m)),
                  ),
                ),
                const SizedBox(height: 18),
                Text('GRAIN', style: VisualTheme.micro(9, color: VisualTheme.fuchsia)),
                const SizedBox(height: 8),
                ...[
                  ('smooth', 'Smooth'),
                  ('even', 'Even'),
                  ('rough', 'Rough'),
                ].map(
                  (g) => _Pick(
                    label: g.$2,
                    selected: prefs.grain == g.$1,
                    onTap: () => _save(prefs.copyWith(grain: g.$1)),
                  ),
                ),
                const SizedBox(height: 18),
                Text('LIGHT', style: VisualTheme.micro(9, color: VisualTheme.fuchsia)),
                const SizedBox(height: 8),
                ...[
                  ('system', 'Follow the colonnade'),
                  ('light', 'Day mist'),
                  ('dark', 'Night shade'),
                ].map(
                  (g) => _Pick(
                    label: g.$2,
                    selected: prefs.theme == g.$1,
                    onTap: () => _save(prefs.copyWith(theme: g.$1)),
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  'Pewter Stoa keeps every walk, tablet note, and preference on this device. There is no account, no login, no cloud sync, and no remote AI.',
                  style: VisualTheme.body(14, color: muted),
                ),
                const SizedBox(height: 12),
                Text('v1.9.0', style: VisualTheme.micro(9, color: ink)),
              ],
            ),
    );
  }
}

class _Pick extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Pick({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          color: VisualTheme.bayOf(context),
          child: Row(
            children: [
              Container(width: 6, height: 22, color: selected ? VisualTheme.fuchsia : Colors.transparent),
              const SizedBox(width: 12),
              Text(label, style: VisualTheme.heading(16, color: VisualTheme.inkOf(context))),
            ],
          ),
        ),
      ),
    );
  }
}
