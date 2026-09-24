import 'package:flutter/material.dart';
import '../data/engine.dart';
import '../data/library.dart';
import '../database/storage_manager.dart';
import '../models/practice_models.dart';
import '../models/user_preferences.dart';
import '../utils/visual_theme.dart';
import '../widgets/gesso_chrome.dart';
import 'breath_view.dart';
import 'session_player_view.dart';

class EaselView extends StatefulWidget {
  const EaselView({super.key});

  @override
  State<EaselView> createState() => _EaselViewState();
}

class _EaselViewState extends State<EaselView> {
  UserPreferences? _prefs;
  PracticeSession? _pick;
  int _streak = 0;
  int _week = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final storage = StorageManager.instance;
    final prefs = await storage.getPreferences();
    final logs = await storage.recentLogs();
    final streak = await storage.streak();
    final week = await storage.minutesThisWeek();
    if (!mounted) return;
    setState(() {
      _prefs = prefs;
      _pick = PracticeEngine.pickCanvas(prefs: prefs, recent: logs);
      _streak = streak;
      _week = week;
    });
  }

  @override
  Widget build(BuildContext context) {
    final muted = VisualTheme.mutedOf(context);
    final now = DateTime.now();
    final pick = _pick;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      children: [
        Text(PracticeEngine.hourGreeting(now).toUpperCase(), style: VisualTheme.micro(9, color: VisualTheme.rose)),
        const SizedBox(height: 8),
        Text(PracticeEngine.lessonOfDay(now), style: VisualTheme.body(16, color: muted)),
        const SizedBox(height: 16),
        Row(
          children: [
            _Stat(label: 'Days', value: '$_streak'),
            const SizedBox(width: 8),
            _Stat(label: 'Week', value: '$_week'),
            const SizedBox(width: 8),
            _Stat(label: 'Min', value: '${_prefs?.minutes ?? 17}'),
          ],
        ),
        const SizedBox(height: 16),
        if (pick != null)
          CanvasCard(
            session: pick,
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(builder: (_) => SessionPlayerView(session: pick)));
              _load();
            },
          ),
        if (pick != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(pick.teaching, style: VisualTheme.body(14, color: muted)),
          ),
        const SizedBox(height: 14),
        FilledButton(
          onPressed: pick == null
              ? null
              : () async {
                  await Navigator.of(context).push(MaterialPageRoute(builder: (_) => SessionPlayerView(session: pick)));
                  _load();
                },
          child: const Text('Prime this session'),
        ),
        const SizedBox(height: 22),
        Text('BREATH FRAMES', style: VisualTheme.micro(9, color: VisualTheme.rose)),
        const SizedBox(height: 10),
        ...PracticeLibrary.patterns.map(
          (p) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              tileColor: VisualTheme.canvasOf(context),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              title: Text(p.name, style: VisualTheme.heading(16, color: VisualTheme.inkOf(context))),
              subtitle: Text('${p.rounds} rounds', style: VisualTheme.body(12, color: muted)),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => BreathView(pattern: p))),
            ),
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        color: VisualTheme.canvasOf(context),
        child: Column(
          children: [
            Text(label.toUpperCase(), style: VisualTheme.micro(7, color: VisualTheme.mutedOf(context))),
            const SizedBox(height: 4),
            Text(value, style: VisualTheme.heading(16, color: VisualTheme.inkOf(context))),
          ],
        ),
      ),
    );
  }
}
