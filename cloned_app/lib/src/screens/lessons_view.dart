import 'package:flutter/material.dart';
import '../data/library.dart';
import '../models/practice_models.dart';
import '../utils/visual_theme.dart';
import '../widgets/brume_chrome.dart';
import 'pose_view.dart';
import 'session_player_view.dart';

class LessonsView extends StatefulWidget {
  const LessonsView({super.key});

  @override
  State<LessonsView> createState() => _LessonsViewState();
}

class _LessonsViewState extends State<LessonsView> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final muted = VisualTheme.mutedOf(context);
    final sessions = _filter == 'all'
        ? PracticeLibrary.sessions
        : PracticeLibrary.sessions.where((s) => s.kind == _filter).toList();

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          const GlowHeader(kicker: 'The chimney', title: 'Lessons'),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final f in ['all', 'yoga', 'breath', 'sit', 'mobility', 'sleep'])
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _filter = f),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: _filter == f ? VisualTheme.lamp : VisualTheme.panelOf(context),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            f.toUpperCase(),
                            style: VisualTheme.micro(
                              9,
                              color: _filter == f ? VisualTheme.night : VisualTheme.inkOf(context),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          ...sessions.map(
            (s) => Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
              child: LampCard(
                session: s,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => SessionPlayerView(session: s, dim: s.kind == 'sleep'),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
            child: Text('POSE CHIMNEY', style: VisualTheme.micro(10, color: VisualTheme.lamp)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
            child: Text(
              'Short lessons without a timer — setup, breath, and what to do if a joint objects.',
              style: VisualTheme.body(14, color: muted),
            ),
          ),
          ...PracticeLibrary.poses.map((p) => _PosePill(pose: p)),
        ],
      ),
    );
  }
}

class _PosePill extends StatelessWidget {
  final PoseCard pose;
  const _PosePill({required this.pose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
      child: Material(
        color: VisualTheme.panelOf(context),
        borderRadius: BorderRadius.circular(20),
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(pose.name, style: VisualTheme.heading(16, color: VisualTheme.inkOf(context))),
          subtitle: Text(pose.aka, style: VisualTheme.body(12, color: VisualTheme.mutedOf(context))),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => PoseView(pose: pose)),
          ),
        ),
      ),
    );
  }
}
