import 'package:flutter/material.dart';
import '../models/practice_models.dart';
import '../utils/visual_theme.dart';
import '../widgets/gesso_chrome.dart';

class PoseView extends StatelessWidget {
  final PoseCard pose;
  const PoseView({super.key, required this.pose});

  @override
  Widget build(BuildContext context) {
    final ink = VisualTheme.inkOf(context);
    final muted = VisualTheme.mutedOf(context);
    return Scaffold(
      appBar: AppBar(title: Text(pose.name)),
      body: GessoWash(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            Text(pose.aka.toUpperCase(), style: VisualTheme.micro(9, color: VisualTheme.rose)),
            const SizedBox(height: 8),
            Text(pose.name, style: VisualTheme.display(32, color: ink)),
            const SizedBox(height: 18),
            _Pane(title: 'Setup', body: pose.setup, ink: ink, muted: muted),
            _Pane(title: 'Breath', body: pose.breath, ink: ink, muted: muted),
            _Pane(title: 'If this', body: pose.ifThis, ink: ink, muted: muted),
          ],
        ),
      ),
    );
  }
}

class _Pane extends StatelessWidget {
  final String title;
  final String body;
  final Color ink;
  final Color muted;
  const _Pane({required this.title, required this.body, required this.ink, required this.muted});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: double.infinity,
        color: VisualTheme.canvasOf(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 3, color: VisualTheme.prussian),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title.toUpperCase(), style: VisualTheme.micro(8, color: muted)),
                  const SizedBox(height: 6),
                  Text(body, style: VisualTheme.body(15, color: ink)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
