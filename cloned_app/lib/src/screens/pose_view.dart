import 'package:flutter/material.dart';
import '../models/practice_models.dart';
import '../utils/visual_theme.dart';
import '../widgets/kiln_chrome.dart';

class PoseView extends StatelessWidget {
  final PoseCard pose;
  const PoseView({super.key, required this.pose});

  @override
  Widget build(BuildContext context) {
    final ink = VisualTheme.inkOf(context);
    final muted = VisualTheme.mutedOf(context);
    return Scaffold(
      appBar: AppBar(title: Text(pose.name)),
      body: SandWash(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            Text(pose.aka.toUpperCase(), style: VisualTheme.micro(9, color: VisualTheme.lichen)),
            const SizedBox(height: 8),
            Text(pose.name, style: VisualTheme.display(32, color: ink)),
            const SizedBox(height: 18),
            _Pot(title: 'Setup', body: pose.setup, ink: ink, muted: muted),
            _Pot(title: 'Breath', body: pose.breath, ink: ink, muted: muted),
            _Pot(title: 'If this', body: pose.ifThis, ink: ink, muted: muted),
          ],
        ),
      ),
    );
  }
}

class _Pot extends StatelessWidget {
  final String title;
  final String body;
  final Color ink;
  final Color muted;
  const _Pot({required this.title, required this.body, required this.ink, required this.muted});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: VisualTheme.bisqueOf(context), borderRadius: potRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title.toUpperCase(), style: VisualTheme.micro(8, color: muted)),
            const SizedBox(height: 6),
            Text(body, style: VisualTheme.body(15, color: ink)),
          ],
        ),
      ),
    );
  }
}
