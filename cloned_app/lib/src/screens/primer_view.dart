import 'package:flutter/material.dart';
import '../database/storage_manager.dart';
import '../models/user_preferences.dart';
import '../utils/visual_theme.dart';
import '../widgets/gesso_chrome.dart';

class PrimerView extends StatefulWidget {
  final VoidCallback onPrefsChanged;
  const PrimerView({super.key, required this.onPrefsChanged});

  @override
  State<PrimerView> createState() => _PrimerViewState();
}

class _PrimerViewState extends State<PrimerView> {
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
      appBar: AppBar(title: const Text('Primer')),
      body: GessoWash(
        child: prefs == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                children: [
                  Text(
                    'The primer is local. Wash, minutes, and appearance never leave the device. No account. No cloud.',
                    style: VisualTheme.body(15, color: muted),
                  ),
                  const SizedBox(height: 18),
                  _Section(
                    title: 'Appearance',
                    children: [
                      for (final t in ['light', 'dark', 'system'])
                        _Pick(label: t[0].toUpperCase() + t.substring(1), selected: prefs.theme == t, onTap: () => _save(prefs.copyWith(theme: t))),
                    ],
                  ),
                  _Section(
                    title: 'The wash holds',
                    children: [
                      for (final g in VisualTheme.washes)
                        _Pick(label: VisualTheme.washLabel(g), selected: prefs.wash == g, onTap: () => _save(prefs.copyWith(wash: g))),
                    ],
                  ),
                  _Section(
                    title: 'Minutes',
                    children: [
                      for (final m in VisualTheme.minuteChoices)
                        _Pick(label: '$m minutes', selected: prefs.minutes == m, onTap: () => _save(prefs.copyWith(minutes: m))),
                    ],
                  ),
                  _Section(
                    title: 'Paper lately',
                    children: [
                      for (final b in VisualTheme.teeth)
                        _Pick(label: b[0].toUpperCase() + b.substring(1), selected: prefs.tooth == b, onTap: () => _save(prefs.copyWith(tooth: b))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'There is no account, no login, no cloud sync, and no remote AI. Sessions, breath patterns, sketch pages, and logs live in gesso_attic.db on this phone.',
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
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: VisualTheme.micro(9, color: VisualTheme.rose)),
          const SizedBox(height: 8),
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
      padding: const EdgeInsets.only(bottom: 4),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: VisualTheme.canvasOf(context),
            border: Border(
              left: BorderSide(color: selected ? VisualTheme.prussian : Colors.transparent, width: 3),
            ),
          ),
          child: Text(label, style: VisualTheme.body(16, color: VisualTheme.inkOf(context))),
        ),
      ),
    );
  }
}
