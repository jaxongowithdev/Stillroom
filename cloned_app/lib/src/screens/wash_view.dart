import 'package:flutter/material.dart';
import '../data/library.dart';
import '../utils/visual_theme.dart';
import '../widgets/gesso_chrome.dart';
import 'session_player_view.dart';

class WashView extends StatelessWidget {
  const WashView({super.key});

  @override
  Widget build(BuildContext context) {
    final muted = VisualTheme.mutedOf(context);
    final rest = PracticeLibrary.sessions.where((s) => s.kind == 'sleep' || s.aims.contains('sleep')).toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      children: [
        Text(
          'Wind-downs for the bed or a dark room. If you sleep during a body wash, that is the practice.',
          style: VisualTheme.body(16, color: muted),
        ),
        const SizedBox(height: 14),
        ...rest.map(
          (s) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: CanvasCard(
              session: s,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => SessionPlayerView(session: s, dim: true)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
