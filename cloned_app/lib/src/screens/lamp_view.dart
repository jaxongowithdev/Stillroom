import 'package:flutter/material.dart';
import '../data/engine.dart';
import '../data/library.dart';
import '../database/storage_manager.dart';
import '../models/practice_models.dart';
import '../models/user_preferences.dart';
import '../utils/visual_theme.dart';
import '../widgets/brume_chrome.dart';
import 'breath_view.dart';
import 'session_player_view.dart';

class LampView extends StatefulWidget {
  final VoidCallback onOpenNook;
  const LampView({super.key, required this.onOpenNook});

  @override
  State<LampView> createState() => _LampViewState();
}

class _LampViewState extends State<LampView> {
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
      _pick = PracticeEngine.pickLamp(prefs: prefs, recent: logs);
      _streak = streak;
      _week = week;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ink = VisualTheme.inkOf(context);
    final muted = VisualTheme.mutedOf(context);
    final now = DateTime.now();
    final pick = _pick;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 16),
        children: [
          GlowHeader(
            kicker: PracticeEngine.hourGreeting(now),
            title: 'Brume Lamp',
            trailing: IconButton(
              onPressed: widget.onOpenNook,
              icon: Icon(Icons.tune_rounded, color: muted),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 18),
            child: Text(PracticeEngine.lessonOfDay(now), style: VisualTheme.body(16, color: muted)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                _GlowStat(label: 'Wick', value: '$_streak d'),
                const SizedBox(width: 12),
                _GlowStat(label: 'Week', value: '$_week min'),
                const SizedBox(width: 12),
                _GlowStat(label: 'Aim', value: '${_prefs?.minutes ?? 14}'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (pick != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: LampCard(
                session: pick,
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => SessionPlayerView(session: pick)),
                  );
                  _load();
                },
              ),
            ),
          if (pick != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
              child: Text(pick.teaching, style: VisualTheme.body(14, color: muted)),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 8),
            child: FilledButton(
              onPressed: pick == null
                  ? null
                  : () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => SessionPlayerView(session: pick)),
                      );
                      _load();
                    },
              child: const Text('Light this session'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
            child: Text('FOG GLASS', style: VisualTheme.micro(10, color: VisualTheme.lamp)),
          ),
          SizedBox(
            height: 138,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              scrollDirection: Axis.horizontal,
              itemCount: PracticeLibrary.patterns.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                final p = PracticeLibrary.patterns[i];
                return GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => BreathView(pattern: p)),
                  ),
                  child: Container(
                    width: 200,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: VisualTheme.panelOf(context),
                      borderRadius: BorderRadius.circular(VisualTheme.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.air, color: VisualTheme.fog, size: 18),
                        const Spacer(),
                        Text(p.name, style: VisualTheme.heading(16, color: ink)),
                        Text('${p.rounds} rounds', style: VisualTheme.body(12, color: muted)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowStat extends StatelessWidget {
  final String label;
  final String value;
  const _GlowStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: VisualTheme.panelOf(context),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(label.toUpperCase(), style: VisualTheme.micro(8, color: VisualTheme.mutedOf(context))),
            const SizedBox(height: 6),
            Text(value, style: VisualTheme.heading(16, color: VisualTheme.inkOf(context))),
          ],
        ),
      ),
    );
  }
}
