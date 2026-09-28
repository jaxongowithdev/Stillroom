import 'package:flutter/material.dart';
import '../models/practice_models.dart';
import '../utils/visual_theme.dart';

class MistWash extends StatelessWidget {
  final Widget child;
  const MistWash({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(color: VisualTheme.mistOf(context), child: child);
  }
}

/// Four stoa columns as a header — tall selected bay, roman index, not underline chips.
class StoaColon extends StatelessWidget {
  final int index;
  final ValueChanged<int> onSelect;
  const StoaColon({super.key, required this.index, required this.onSelect});

  static const items = [
    ('I', 'Walk'),
    ('II', 'Range'),
    ('III', 'Shade'),
    ('IV', 'Tablet'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      child: SizedBox(
        height: 72,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () => onSelect(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    height: i == index ? 72 : 52,
                    color: i == index ? VisualTheme.fuchsia : VisualTheme.pewter,
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          items[i].$1,
                          style: VisualTheme.micro(9, color: Colors.white.withValues(alpha: i == index ? 1 : 0.7)),
                        ),
                        const Spacer(),
                        Text(
                          items[i].$2,
                          style: VisualTheme.heading(13, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class BayCard extends StatelessWidget {
  final PracticeSession session;
  final VoidCallback onTap;
  const BayCard({super.key, required this.session, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final ink = VisualTheme.inkOf(context);
    final muted = VisualTheme.mutedOf(context);
    return Material(
      color: VisualTheme.bayOf(context),
      borderRadius: const BorderRadius.all(Radius.circular(2)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 10, color: VisualTheme.pewter),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 6, height: 64, color: VisualTheme.kindTint(session.kind)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${session.kind.toUpperCase()}  ·  ${session.minutes} MIN', style: VisualTheme.micro(8, color: muted)),
                        const SizedBox(height: 6),
                        Text(session.title, style: VisualTheme.display(24, color: ink)),
                        const SizedBox(height: 4),
                        Text(session.subtitle, style: VisualTheme.body(14, color: muted)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StoaTitle extends StatelessWidget {
  final Widget? trailing;
  const StoaTitle({super.key, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 4),
      child: Row(
        children: [
          Expanded(
            child: Text('PEWTER STOA', style: VisualTheme.micro(10, color: VisualTheme.fuchsia)),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class ColumnWalk extends StatelessWidget {
  final double t;
  final Color color;
  const ColumnWalk({super.key, required this.t, required this.color});

  @override
  Widget build(BuildContext context) {
    final heights = [0.62, 1.0, 0.78, 0.5];
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var i = 0; i < 4; i++) ...[
          if (i > 0) const SizedBox(width: 10),
          Container(
            width: 14,
            height: 36 + t * 90 * heights[i],
            color: color.withValues(alpha: 0.35 + t * 0.5),
          ),
        ],
      ],
    );
  }
}
