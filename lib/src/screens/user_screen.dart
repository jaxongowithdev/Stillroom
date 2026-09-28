import 'package:flutter/material.dart';
import '../database/storage_manager.dart';
import '../models/user_preferences.dart';
import '../utils/visual_theme.dart';
import '../widgets/stoa_chrome.dart';
import 'dashboard_view.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _storage = StorageManager.instance;
  bool _ready = false;
  UserPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    try {
      await _storage.database;
      final prefs = await _storage.getPreferences();
      setState(() {
        _prefs = prefs;
        _ready = true;
      });
    } catch (e, st) {
      debugPrint('Pewter Stoa boot: $e\n$st');
      setState(() {
        _prefs = UserPreferences();
        _ready = true;
      });
    }
  }

  Future<void> reload() async {
    final prefs = await _storage.getPreferences();
    setState(() => _prefs = prefs);
  }

  @override
  Widget build(BuildContext context) {
    var mode = ThemeMode.light;
    switch (_prefs?.theme) {
      case 'dark':
        mode = ThemeMode.dark;
        break;
      case 'system':
        mode = ThemeMode.system;
        break;
    }

    return MaterialApp(
      title: 'Pewter Stoa',
      debugShowCheckedModeBanner: false,
      theme: VisualTheme.lightTheme,
      darkTheme: VisualTheme.darkTheme,
      themeMode: mode,
      home: !_ready || _prefs == null
          ? const _Boot()
          : _prefs!.showOnboarding
              ? WelcomeView(onFinished: reload)
              : DashboardView(onPrefsChanged: reload),
    );
  }
}

class _Boot extends StatelessWidget {
  const _Boot();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VisualTheme.ink,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ColumnWalk(t: 0.7, color: VisualTheme.fuchsia),
            const SizedBox(height: 22),
            Text('PEWTER STOA', style: VisualTheme.micro(11, color: VisualTheme.fuchsia)),
            const SizedBox(height: 8),
            Text('Raising the first column…', style: VisualTheme.body(15, color: VisualTheme.mist)),
          ],
        ),
      ),
    );
  }
}

class WelcomeView extends StatefulWidget {
  final VoidCallback onFinished;
  const WelcomeView({super.key, required this.onFinished});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  int _page = 0;
  String _aspect = 'ease';
  int _minutes = 19;
  String _grain = 'even';

  Future<void> _finish() async {
    final storage = StorageManager.instance;
    final current = await storage.getPreferences();
    await storage.savePreferences(
      current.copyWith(aspect: _aspect, minutes: _minutes, grain: _grain, showOnboarding: false),
    );
    widget.onFinished();
  }

  @override
  Widget build(BuildContext context) {
    final ink = VisualTheme.inkOf(context);
    final muted = VisualTheme.mutedOf(context);
    return Scaffold(
      body: MistWash(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('PEWTER STOA', style: VisualTheme.micro(11, color: VisualTheme.fuchsia)),
                const Spacer(),
                if (_page == 0) ...[
                  Text('A walk\nyou can keep.', style: VisualTheme.display(36, color: ink)),
                  const SizedBox(height: 16),
                  Text(
                    'Personalized sessions, breathing, sleep, and a private journal — fully offline. No account. No cloud.',
                    style: VisualTheme.body(16, color: muted),
                  ),
                ] else if (_page == 1) ...[
                  Text('What should the walk hold?', style: VisualTheme.display(30, color: ink)),
                  const SizedBox(height: 16),
                  ...[
                    ('ease', 'Ease', 'Unhook the day from the shoulders.'),
                    ('sleep', 'Sleep', 'A walk you can set down in the shade.'),
                    ('stretch', 'Stretch', 'Hips, spine, a plinth unknot.'),
                    ('sit', 'Sit', 'Count, park a worry, hear the columns.'),
                  ].map((g) => _Bay(label: g.$2, detail: g.$3, selected: _aspect == g.$1, onTap: () => setState(() => _aspect = g.$1))),
                ] else if (_page == 2) ...[
                  Text('How many minutes?', style: VisualTheme.display(30, color: ink)),
                  const SizedBox(height: 16),
                  ...VisualTheme.minuteChoices.map(
                    (m) => _Bay(
                      label: '$m minutes',
                      detail: m == 13 ? 'Four columns, a short sit.' : m == 19 ? 'A full range or a body scan.' : 'Room for dusk shade.',
                      selected: _minutes == m,
                      onTap: () => setState(() => _minutes = m),
                    ),
                  ),
                ] else ...[
                  Text('How does the grain feel?', style: VisualTheme.display(30, color: ink)),
                  const SizedBox(height: 16),
                  ...[
                    ('smooth', 'Smooth', 'Keep strong shapes off the walk.'),
                    ('even', 'Even', 'Most days, a middle range.'),
                    ('rough', 'Rough', 'Hills yesterday are welcome.'),
                  ].map((g) => _Bay(label: g.$2, detail: g.$3, selected: _grain == g.$1, onTap: () => setState(() => _grain = g.$1))),
                ],
                const Spacer(),
                Row(
                  children: [
                    Text('${_page + 1}  ·  4', style: VisualTheme.micro(10, color: muted)),
                    const Spacer(),
                    FilledButton(
                      onPressed: () {
                        if (_page < 3) {
                          setState(() => _page += 1);
                        } else {
                          _finish();
                        }
                      },
                      child: Text(_page < 3 ? 'Next' : 'Enter the stoa'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Bay extends StatelessWidget {
  final String label;
  final String detail;
  final bool selected;
  final VoidCallback onTap;
  const _Bay({required this.label, required this.detail, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: VisualTheme.bayOf(context),
          child: Row(
            children: [
              Container(width: 6, height: 36, color: selected ? VisualTheme.fuchsia : Colors.transparent),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: VisualTheme.heading(17, color: VisualTheme.inkOf(context))),
                    Text(detail, style: VisualTheme.body(13, color: VisualTheme.mutedOf(context))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
