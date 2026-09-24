import 'package:flutter/material.dart';
import '../data/library.dart';
import '../models/practice_models.dart';
import '../utils/visual_theme.dart';
import '../widgets/kiln_chrome.dart';
import 'pose_view.dart';
import 'session_player_view.dart';

class BatchView extends StatefulWidget {
  const BatchView({super.key});

  @override
  State<BatchView> createState() => _BatchViewState();
}

class _BatchViewState extends State<BatchView> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final muted = VisualTheme.mutedOf(context);
    final sessions = _filter == 'all'
        ? PracticeLibrary.sessions.where((s) => s.kind != 'sleep').toList()
        : PracticeLibrary.sessions.where((s) => s.kind == _filter).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final f in ['all', 'yoga', 'breath', 'sit', 'mobility'])
              GestureDetector(
                onTap: () => setState(() => _filter = f),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: _filter == f ? VisualTheme.umber : VisualTheme.bisqueOf(context),
                    borderRadius: BorderRadius.circular(20),
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
            child: KilnCard(
              session: s,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => SessionPlayerView(session: s))),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text('POSE SHELF', style: VisualTheme.micro(9, color: VisualTheme.lichen)),
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
      padding: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        tileColor: VisualTheme.bisqueOf(context),
        shape: const RoundedRectangleBorder(borderRadius: potRadius),
        title: Text(pose.name, style: VisualTheme.heading(16, color: VisualTheme.inkOf(context))),
        subtitle: Text(pose.aka, style: VisualTheme.body(12, color: VisualTheme.mutedOf(context))),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PoseView(pose: pose))),
      ),
    );
  }
}
