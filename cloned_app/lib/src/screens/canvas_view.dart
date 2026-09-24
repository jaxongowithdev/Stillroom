import 'package:flutter/material.dart';
import '../data/library.dart';
import '../models/practice_models.dart';
import '../utils/visual_theme.dart';
import '../widgets/gesso_chrome.dart';
import 'pose_view.dart';
import 'session_player_view.dart';

class CanvasView extends StatefulWidget {
  const CanvasView({super.key});

  @override
  State<CanvasView> createState() => _CanvasViewState();
}

class _CanvasViewState extends State<CanvasView> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final muted = VisualTheme.mutedOf(context);
    final sessions = _filter == 'all'
        ? PracticeLibrary.sessions.where((s) => s.kind != 'sleep').toList()
        : PracticeLibrary.sessions.where((s) => s.kind == _filter).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      children: [
        Wrap(
          spacing: 0,
          runSpacing: 0,
          children: [
            for (final f in ['all', 'yoga', 'breath', 'sit', 'mobility'])
              GestureDetector(
                onTap: () => setState(() => _filter = f),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: _filter == f ? VisualTheme.prussian : VisualTheme.canvasOf(context),
                    border: Border(right: BorderSide(color: VisualTheme.rule, width: 1)),
                  ),
                  child: Text(
                    f.toUpperCase(),
                    style: VisualTheme.micro(8, color: _filter == f ? Colors.white : VisualTheme.inkOf(context)),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),
        ...sessions.map(
          (s) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: CanvasCard(
              session: s,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => SessionPlayerView(session: s))),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text('POSE FRAMES', style: VisualTheme.micro(9, color: VisualTheme.rose)),
        const SizedBox(height: 8),
        Text('Short lessons without a timer — setup, breath, and what to do if a joint objects.', style: VisualTheme.body(14, color: muted)),
        const SizedBox(height: 10),
        ...PracticeLibrary.poses.map((p) => _PoseRow(pose: p)),
      ],
    );
  }
}

class _PoseRow extends StatelessWidget {
  final PoseCard pose;
  const _PoseRow({required this.pose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 1),
      child: ListTile(
        tileColor: VisualTheme.canvasOf(context),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Text(pose.name, style: VisualTheme.heading(16, color: VisualTheme.inkOf(context))),
        subtitle: Text(pose.aka, style: VisualTheme.body(12, color: VisualTheme.mutedOf(context))),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PoseView(pose: pose))),
      ),
    );
  }
}
