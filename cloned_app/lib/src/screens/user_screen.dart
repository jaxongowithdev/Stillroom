import 'package:flutter/material.dart';
import '../database/storage_manager.dart';
import '../models/user_preferences.dart';
import '../utils/visual_theme.dart';
import '../widgets/brume_chrome.dart';
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
      debugPrint('Brume Lamp boot: $e\n$st');
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
    var mode = ThemeMode.dark;
    switch (_prefs?.theme) {
      case 'light':
        mode = ThemeMode.light;
        break;
      case 'system':
        mode = ThemeMode.system;
        break;
      default:
        mode = ThemeMode.dark;
    }

    return MaterialApp(
      title: 'Brume Lamp',
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
      backgroundColor: VisualTheme.night,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 14,
              height: 28,
              decoration: BoxDecoration(
                color: VisualTheme.lamp,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 22),
            Text('BRUME LAMP', style: VisualTheme.micro(12, color: VisualTheme.fog)),
            const SizedBox(height: 10),
            Text('The wick is catching…', style: VisualTheme.body(15, color: VisualTheme.fog)),
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
  String _aim = 'unwind';
  int _minutes = 14;
  String _feel = 'even';

  Future<void> _finish() async {
    final storage = StorageManager.instance;
    final current = await storage.getPreferences();
    await storage.savePreferences(
      current.copyWith(aim: _aim, minutes: _minutes, bodyFeel: _feel, showOnboarding: false),
    );
    widget.onFinished();
  }

  @override
  Widget build(BuildContext context) {
    final ink = VisualTheme.inkOf(context);
    final muted = VisualTheme.mutedOf(context);
    return Scaffold(
      body: NightWash(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('BRUME LAMP', style: VisualTheme.micro(11, color: VisualTheme.lamp)),
                const Spacer(),
                if (_page == 0) ...[
                  Text('A lamp you\ncan dim.', style: VisualTheme.display(40, color: ink)),
                  const SizedBox(height: 18),
                  Text(
                    'Personalized sessions, breathing, sleep, and a private journal — fully offline. No account. No cloud.',
                    style: VisualTheme.body(16, color: muted),
                  ),
                ] else if (_page == 1) ...[
                  Text('What should the lamp hold?', style: VisualTheme.display(32, color: ink)),
                  const SizedBox(height: 20),
                  ...[
                    ('unwind', 'Unwind', 'Unhook the day from the shoulders.'),
                    ('sleep', 'Sleep', 'A lantern you can set down in bed.'),
                    ('stretch', 'Stretch', 'Hips, spine, a window unknot.'),
                    ('sit', 'Sit', 'Count, park a worry, hear the room.'),
                  ].map((g) => _Pill(label: g.$2, detail: g.$3, selected: _aim == g.$1, onTap: () => setState(() => _aim = g.$1))),
                ] else if (_page == 2) ...[
                  Text('How many minutes, most days?', style: VisualTheme.display(32, color: ink)),
                  const SizedBox(height: 20),
                  ...VisualTheme.minuteChoices.map(
                    (m) => _Pill(
                      label: '$m minutes',
                      detail: m == 8 ? 'A glass of four, a short sit.' : m == 14 ? 'A full wick or a body lantern.' : 'Room for dusk ember.',
                      selected: _minutes == m,
                      onTap: () => setState(() => _minutes = m),
                    ),
                  ),
                ] else ...[
                  Text('How does the body feel lately?', style: VisualTheme.display(32, color: ink)),
                  const SizedBox(height: 20),
                  ...[
                    ('tender', 'Tender', 'Keep strong shapes off the menu.'),
                    ('even', 'Even', 'Most days, a middle path.'),
                    ('ready', 'Ready', 'Hills yesterday are welcome.'),
                  ].map((g) => _Pill(label: g.$2, detail: g.$3, selected: _feel == g.$1, onTap: () => setState(() => _feel = g.$1))),
                ],
                const Spacer(),
                Row(
                  children: [
                    Text('${_page + 1}  /  4', style: VisualTheme.micro(10, color: muted)),
                    const Spacer(),
                    FilledButton(
                      onPressed: () {
                        if (_page < 3) {
                          setState(() => _page += 1);
                        } else {
                          _finish();
                        }
                      },
                      child: Text(_page < 3 ? 'Next' : 'Light the lamp'),
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

class _Pill extends StatelessWidget {
  final String label;
  final String detail;
  final bool selected;
  final VoidCallback onTap;
  const _Pill({required this.label, required this.detail, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: VisualTheme.panelOf(context),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: selected ? VisualTheme.lamp : Colors.transparent,
              width: 1.4,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: VisualTheme.heading(18, color: VisualTheme.inkOf(context))),
              const SizedBox(height: 2),
              Text(detail, style: VisualTheme.body(13, color: VisualTheme.mutedOf(context))),
            ],
          ),
        ),
      ),
    );
  }
}
