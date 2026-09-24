import 'package:flutter/material.dart';
import '../models/practice_models.dart';
import '../utils/visual_theme.dart';
import '../widgets/brume_chrome.dart';

class PoseView extends StatelessWidget {
  final PoseCard pose;
  const PoseView({super.key, required this.pose});

  @override
  Widget build(BuildContext context) {
    final ink = VisualTheme.inkOf(context);
    final muted = VisualTheme.mutedOf(context);
    return Scaffold(
      appBar: AppBar(title: Text(pose.name)),
      body: NightWash(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 36),
          children: [
            Text(pose.aka.toUpperCase(), style: VisualTheme.micro(10, color: VisualTheme.lamp)),
            const SizedBox(height: 8),
            Text(pose.name, style: VisualTheme.display(34, color: ink)),
            const SizedBox(height: 24),
            _Block(title: 'Setup', body: pose.setup, ink: ink, muted: muted),
            _Block(title: 'Breath', body: pose.breath, ink: ink, muted: muted),
            _Block(title: 'If this', body: pose.ifThis, ink: ink, muted: muted),
          ],
        ),
      ),
    );
  }
}

class _Block extends StatelessWidget {
  final String title;
  final String body;
  final Color ink;
  final Color muted;
  const _Block({required this.title, required this.body, required this.ink, required this.muted});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: VisualTheme.panelOf(context),
          borderRadius: BorderRadius.circular(VisualTheme.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title.toUpperCase(), style: VisualTheme.micro(10, color: muted)),
            const SizedBox(height: 8),
            Text(body, style: VisualTheme.body(16, color: ink)),
          ],
        ),
      ),
    );
  }
}
