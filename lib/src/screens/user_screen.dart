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
      debugPrint('Stillroom boot: $e\n$st');
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
      title: 'Stillroom',
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
            Text(
              'STILLROOM',
              style: VisualTheme.micro(11, color: VisualTheme.apricot),
            ),
            const SizedBox(height: 8),
            Text(
              'Opening a quiet room…',
              style: VisualTheme.body(15, color: VisualTheme.mist),
            ),
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
      current.copyWith(
        aspect: _aspect,
        minutes: _minutes,
        grain: _grain,
        showOnboarding: false,
      ),
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
                Text(
                  'STILLROOM  ·  YOUR OFFLINE TEACHER',
                  style: VisualTheme.micro(10, color: VisualTheme.fuchsia),
                ),
                const Spacer(),
                if (_page == 0) ...[
                  Text(
                    'Make a little\nroom for yourself.',
                    style: VisualTheme.display(36, color: ink),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'A private teacher for movement, breath, rest and reflection. It lives entirely on your device — no account, cloud or remote AI.',
                    style: VisualTheme.body(16, color: muted),
                  ),
                ] else if (_page == 1) ...[
                  Text(
                    'What would help\nright now?',
                    style: VisualTheme.display(30, color: ink),
                  ),
                  const SizedBox(height: 16),
                  ...[
                    ('ease', 'Ease', 'A gentler pace for a busy day.'),
                    ('sleep', 'Sleep', 'A softer landing before bed.'),
                    (
                      'stretch',
                      'Stretch',
                      'Give the desk-bound places some space.',
                    ),
                    ('sit', 'Sit', 'Settle, count, and begin again.'),
                  ].map(
                    (g) => _Bay(
                      label: g.$2,
                      detail: g.$3,
                      selected: _aspect == g.$1,
                      onTap: () => setState(() => _aspect = g.$1),
                    ),
                  ),
                ] else if (_page == 2) ...[
                  Text(
                    'How much time\ncan we borrow?',
                    style: VisualTheme.display(30, color: ink),
                  ),
                  const SizedBox(height: 16),
                  ...VisualTheme.minuteChoices.map(
                    (m) => _Bay(
                      label: '$m minutes',
                      detail: m == 13
                          ? 'A meaningful pause, even on a full day.'
                          : m == 19
                              ? 'Enough time to move and settle.'
                              : 'A longer, unhurried practice.',
                      selected: _minutes == m,
                      onTap: () => setState(() => _minutes = m),
                    ),
                  ),
                ] else ...[
                  Text(
                    'How is your\nenergy today?',
                    style: VisualTheme.display(30, color: ink),
                  ),
                  const SizedBox(height: 16),
                  ...[
                    ('smooth', 'Tender', 'Keep things simple and kind.'),
                    ('even', 'Steady', 'A balanced place to begin.'),
                    ('rough', 'Ready', 'You have some energy to explore.'),
                  ].map(
                    (g) => _Bay(
                      label: g.$2,
                      detail: g.$3,
                      selected: _grain == g.$1,
                      onTap: () => setState(() => _grain = g.$1),
                    ),
                  ),
                ],
                const Spacer(),
                Row(
                  children: [
                    Text(
                      '${_page + 1}  ·  4',
                      style: VisualTheme.micro(10, color: muted),
                    ),
                    const Spacer(),
                    Flexible(
                        child: FilledButton(
                      onPressed: () {
                        if (_page < 3) {
                          setState(() => _page += 1);
                        } else {
                          _finish();
                        }
                      },
                      child: Text(_page < 3 ? 'Continue' : 'Enter Stillroom'),
                    )),
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
  const _Bay({
    required this.label,
    required this.detail,
    required this.selected,
    required this.onTap,
  });

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
              Container(
                width: 6,
                height: 36,
                color: selected ? VisualTheme.fuchsia : Colors.transparent,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: VisualTheme.heading(
                        17,
                        color: VisualTheme.inkOf(context),
                      ),
                    ),
                    Text(
                      detail,
                      style: VisualTheme.body(
                        13,
                        color: VisualTheme.mutedOf(context),
                      ),
                    ),
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
