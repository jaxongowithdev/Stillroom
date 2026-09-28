import 'package:flutter/material.dart';
import '../models/practice_models.dart';
import '../utils/visual_theme.dart';

class PoseView extends StatelessWidget {
  final PoseCard pose;
  const PoseView({super.key, required this.pose});

  @override
  Widget build(BuildContext context) {
    final ink = VisualTheme.inkOf(context);
    final muted = VisualTheme.mutedOf(context);
    return Scaffold(
      appBar: AppBar(title: Text(pose.name.toUpperCase(), style: VisualTheme.micro(10, color: VisualTheme.fuchsia))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(22, 16, 22, 32),
        children: [
          Text(pose.aka, style: VisualTheme.body(15, color: muted)),
          const SizedBox(height: 18),
          Text('SETUP', style: VisualTheme.micro(9, color: VisualTheme.fuchsia)),
          const SizedBox(height: 8),
          Text(pose.setup, style: VisualTheme.body(16, color: ink)),
          const SizedBox(height: 18),
          Text('BREATH', style: VisualTheme.micro(9, color: VisualTheme.fuchsia)),
          const SizedBox(height: 8),
          Text(pose.breath, style: VisualTheme.body(16, color: ink)),
          const SizedBox(height: 18),
          Text('IF A JOINT OBJECTS', style: VisualTheme.micro(9, color: VisualTheme.fuchsia)),
          const SizedBox(height: 8),
          Text(pose.ifThis, style: VisualTheme.body(16, color: ink)),
        ],
      ),
    );
  }
}
