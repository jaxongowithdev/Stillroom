import 'package:flutter/material.dart';
import '../database/storage_manager.dart';
import '../models/user_preferences.dart';
import '../utils/visual_theme.dart';
import '../widgets/brume_chrome.dart';

class NookView extends StatefulWidget {
  final VoidCallback onPrefsChanged;
  const NookView({super.key, required this.onPrefsChanged});

  @override
  State<NookView> createState() => _NookViewState();
}

class _NookViewState extends State<NookView> {
  UserPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await StorageManager.instance.getPreferences();
    if (mounted) setState(() => _prefs = prefs);
  }

  Future<void> _save(UserPreferences next) async {
    await StorageManager.instance.savePreferences(next);
    widget.onPrefsChanged();
    setState(() => _prefs = next);
  }

  @override
  Widget build(BuildContext context) {
    final prefs = _prefs;
    final muted = VisualTheme.mutedOf(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Nook')),
      body: NightWash(
        child: prefs == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 36),
                children: [
                  Text(
                    'The nook is local. Aim, minutes, and appearance never leave the device. No account. No cloud.',
                    style: VisualTheme.body(15, color: muted),
                  ),
                  const SizedBox(height: 22),
                  _Section(
                    title: 'Appearance',
                    children: [
                      for (final t in ['dark', 'light', 'system'])
                        _Pick(
                          label: t[0].toUpperCase() + t.substring(1),
                          selected: prefs.theme == t,
                          onTap: () => _save(prefs.copyWith(theme: t)),
                        ),
                    ],
                  ),
                  _Section(
                    title: 'The lamp holds',
                    children: [
                      for (final g in VisualTheme.aims)
                        _Pick(
                          label: VisualTheme.aimLabel(g),
                          selected: prefs.aim == g,
                          onTap: () => _save(prefs.copyWith(aim: g)),
                        ),
                    ],
                  ),
                  _Section(
                    title: 'Minutes',
                    children: [
                      for (final m in VisualTheme.minuteChoices)
                        _Pick(
                          label: '$m minutes',
                          selected: prefs.minutes == m,
                          onTap: () => _save(prefs.copyWith(minutes: m)),
                        ),
                    ],
                  ),
                  _Section(
                    title: 'Body lately',
                    children: [
                      for (final b in VisualTheme.bodyFeels)
                        _Pick(
                          label: b[0].toUpperCase() + b.substring(1),
                          selected: prefs.bodyFeel == b,
                          onTap: () => _save(prefs.copyWith(bodyFeel: b)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'There is no account, no login, no cloud sync, and no remote AI. Sessions, breath patterns, pages, and logs live in brume_lamp.db on this phone.',
                    style: VisualTheme.body(14, color: muted),
                  ),
                ],
              ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: VisualTheme.micro(10, color: VisualTheme.lamp)),
          const SizedBox(height: 10),
          ...children,
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
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: VisualTheme.panelOf(context),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: selected ? VisualTheme.lamp : Colors.transparent, width: 1.4),
          ),
          child: Text(label, style: VisualTheme.body(16, color: VisualTheme.inkOf(context))),
        ),
      ),
    );
  }
}
