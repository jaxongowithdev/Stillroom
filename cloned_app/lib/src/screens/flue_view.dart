import 'package:flutter/material.dart';
import '../database/storage_manager.dart';
import '../models/user_preferences.dart';
import '../utils/visual_theme.dart';
import '../widgets/kiln_chrome.dart';

class FlueView extends StatefulWidget {
  final VoidCallback onPrefsChanged;
  const FlueView({super.key, required this.onPrefsChanged});

  @override
  State<FlueView> createState() => _FlueViewState();
}

class _FlueViewState extends State<FlueView> {
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
      appBar: AppBar(title: const Text('Flue')),
      body: SandWash(
        child: prefs == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                children: [
                  Text(
                    'The flue is local. Glaze, minutes, and appearance never leave the device. No account. No cloud.',
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
                    title: 'The glaze holds',
                    children: [
                      for (final g in VisualTheme.glazes)
                        _Pick(label: VisualTheme.glazeLabel(g), selected: prefs.glaze == g, onTap: () => _save(prefs.copyWith(glaze: g))),
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
                    title: 'Bisque lately',
                    children: [
                      for (final b in VisualTheme.bisques)
                        _Pick(label: b[0].toUpperCase() + b.substring(1), selected: prefs.bisque == b, onTap: () => _save(prefs.copyWith(bisque: b))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'There is no account, no login, no cloud sync, and no remote AI. Sessions, breath patterns, folio pages, and logs live in lichen_kiln.db on this phone.',
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
          Text(title.toUpperCase(), style: VisualTheme.micro(9, color: VisualTheme.lichen)),
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
      padding: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: potRadius,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: VisualTheme.bisqueOf(context),
            borderRadius: potRadius,
            border: Border.all(color: selected ? VisualTheme.lichen : Colors.transparent, width: 2),
          ),
          child: Text(label, style: VisualTheme.body(16, color: VisualTheme.inkOf(context))),
        ),
      ),
    );
  }
}
