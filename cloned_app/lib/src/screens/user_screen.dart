import 'package:flutter/material.dart';
import '../database/storage_manager.dart';
import '../models/user_preferences.dart';
import '../utils/visual_theme.dart';
import '../widgets/kiln_chrome.dart';
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
      debugPrint('Lichen Kiln boot: $e\n$st');
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
      title: 'Lichen Kiln',
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
      backgroundColor: VisualTheme.umber,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const VentPair(t: 0.55, color: VisualTheme.lichen),
            const SizedBox(height: 22),
            Text('LICHEN KILN', style: VisualTheme.micro(11, color: VisualTheme.lichen)),
            const SizedBox(height: 8),
            Text('Warming the first batch…', style: VisualTheme.body(15, color: VisualTheme.sand)),
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
  String _glaze = 'ease';
  int _minutes = 18;
  String _bisque = 'even';

  Future<void> _finish() async {
    final storage = StorageManager.instance;
    final current = await storage.getPreferences();
    await storage.savePreferences(
      current.copyWith(glaze: _glaze, minutes: _minutes, bisque: _bisque, showOnboarding: false),
    );
    widget.onFinished();
  }

  @override
  Widget build(BuildContext context) {
    final ink = VisualTheme.inkOf(context);
    final muted = VisualTheme.mutedOf(context);
    return Scaffold(
      body: SandWash(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('LICHEN KILN', style: VisualTheme.micro(11, color: VisualTheme.lichen)),
                const Spacer(),
                if (_page == 0) ...[
                  Text('A kiln\nyou can sit with.', style: VisualTheme.display(36, color: ink)),
                  const SizedBox(height: 16),
                  Text(
                    'Personalized sessions, breathing, sleep, and a private journal — fully offline. No account. No cloud.',
                    style: VisualTheme.body(16, color: muted),
                  ),
                ] else if (_page == 1) ...[
                  Text('What should the glaze hold?', style: VisualTheme.display(30, color: ink)),
                  const SizedBox(height: 16),
                  ...[
                    ('ease', 'Ease', 'Unhook the day from the shoulders.'),
                    ('sleep', 'Sleep', 'A firing you can set down in ash.'),
                    ('stretch', 'Stretch', 'Hips, spine, a shelf unknot.'),
                    ('sit', 'Sit', 'Count, park a worry, hear the loft.'),
                  ].map((g) => _Pot(label: g.$2, detail: g.$3, selected: _glaze == g.$1, onTap: () => setState(() => _glaze = g.$1))),
                ] else if (_page == 2) ...[
                  Text('How many minutes?', style: VisualTheme.display(30, color: ink)),
                  const SizedBox(height: 16),
                  ...VisualTheme.minuteChoices.map(
                    (m) => _Pot(
                      label: '$m minutes',
                      detail: m == 12 ? 'Four vents, a short sit.' : m == 18 ? 'A full batch or a body scan.' : 'Room for dusk ash.',
                      selected: _minutes == m,
                      onTap: () => setState(() => _minutes = m),
                    ),
                  ),
                ] else ...[
                  Text('How does the bisque feel?', style: VisualTheme.display(30, color: ink)),
                  const SizedBox(height: 16),
                  ...[
                    ('soft', 'Soft', 'Keep strong shapes off the shelf.'),
                    ('even', 'Even', 'Most days, a middle firing.'),
                    ('fired', 'Fired', 'Hills yesterday are welcome.'),
                  ].map((g) => _Pot(label: g.$2, detail: g.$3, selected: _bisque == g.$1, onTap: () => setState(() => _bisque = g.$1))),
                ],
                const Spacer(),
                Row(
                  children: [
                    Text('${_page + 1}  —  4', style: VisualTheme.micro(10, color: muted)),
                    const Spacer(),
                    FilledButton(
                      onPressed: () {
                        if (_page < 3) {
                          setState(() => _page += 1);
                        } else {
                          _finish();
                        }
                      },
                      child: Text(_page < 3 ? 'Next' : 'Enter the kiln'),
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

class _Pot extends StatelessWidget {
  final String label;
  final String detail;
  final bool selected;
  final VoidCallback onTap;
  const _Pot({required this.label, required this.detail, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: VisualTheme.heading(17, color: VisualTheme.inkOf(context))),
              Text(detail, style: VisualTheme.body(13, color: VisualTheme.mutedOf(context))),
            ],
          ),
        ),
      ),
    );
  }
}
