import 'package:flutter/material.dart';
import '../data/library.dart';
import '../models/practice_models.dart';
import '../utils/visual_theme.dart';
import '../widgets/stoa_chrome.dart';
import 'pose_view.dart';
import 'session_player_view.dart';

class RangeView extends StatefulWidget {
  const RangeView({super.key});

  @override
  State<RangeView> createState() => _RangeViewState();
}

class _RangeViewState extends State<RangeView> {
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
        Row(
          children: [
            for (final f in ['all', 'yoga', 'breath', 'sit', 'mobility'])
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _filter = f),
                  child: Container(
                    height: 36,
                    alignment: Alignment.center,
                    color: _filter == f ? VisualTheme.fuchsia : VisualTheme.bayOf(context),
                    child: Text(
                      f == 'all' ? 'ALL' : f.substring(0, 1).toUpperCase(),
                      style: VisualTheme.micro(8, color: _filter == f ? Colors.white : VisualTheme.inkOf(context)),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),
        ...sessions.map(
          (s) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: BayCard(
              session: s,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => SessionPlayerView(session: s))),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text('POSE BAYS', style: VisualTheme.micro(9, color: VisualTheme.fuchsia)),
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
        tileColor: VisualTheme.bayOf(context),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
        title: Text(pose.name, style: VisualTheme.heading(16, color: VisualTheme.inkOf(context))),
        subtitle: Text(pose.aka, style: VisualTheme.body(12, color: VisualTheme.mutedOf(context))),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PoseView(pose: pose))),
      ),
    );
  }
}
