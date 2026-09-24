import 'package:flutter/material.dart';
import '../models/practice_models.dart';
import '../utils/visual_theme.dart';

class SandWash extends StatelessWidget {
  final Widget child;
  const SandWash({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(color: VisualTheme.sandOf(context), child: child);
  }
}

/// Pots sit on a shelf — nearly square on top, round at the base.
const potRadius = BorderRadius.only(
  topLeft: Radius.circular(4),
  topRight: Radius.circular(4),
  bottomLeft: Radius.circular(28),
  bottomRight: Radius.circular(28),
);

class KilnRail extends StatelessWidget {
  final int index;
  final ValueChanged<int> onSelect;
  const KilnRail({super.key, required this.index, required this.onSelect});

  static const items = [
    (Icons.fireplace_outlined, 'Hearth'),
    (Icons.inventory_2_outlined, 'Batch'),
    (Icons.nights_stay_outlined, 'Ash'),
    (Icons.auto_stories_outlined, 'Folio'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: false,
      child: Container(
        width: 64,
        color: VisualTheme.umber,
        child: Column(
          children: [
            const SizedBox(height: 10),
            for (var i = 0; i < items.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: GestureDetector(
                  onTap: () => onSelect(i),
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: i == index ? VisualTheme.lichen : Colors.transparent,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Icon(
                          items[i].$1,
                          color: i == index ? Colors.white : const Color(0xFFB8A894),
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        items[i].$2.toUpperCase(),
                        style: VisualTheme.micro(
                          6,
                          color: i == index ? Colors.white : const Color(0xFFB8A894),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class KilnCard extends StatelessWidget {
  final PracticeSession session;
  final VoidCallback onTap;
  const KilnCard({super.key, required this.session, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final ink = VisualTheme.inkOf(context);
    final muted = VisualTheme.mutedOf(context);
    return Material(
      color: VisualTheme.bisqueOf(context),
      borderRadius: potRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: potRadius,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(width: 18, height: 6, color: VisualTheme.kindTint(session.kind)),
                  const SizedBox(width: 8),
                  Text('${session.kind.toUpperCase()}  ·  ${session.minutes} MIN', style: VisualTheme.micro(8, color: muted)),
                ],
              ),
              const SizedBox(height: 10),
              Text(session.title, style: VisualTheme.display(24, color: ink)),
              const SizedBox(height: 6),
              Text(session.subtitle, style: VisualTheme.body(14, color: muted)),
            ],
          ),
        ),
      ),
    );
  }
}

class KilnTitle extends StatelessWidget {
  final String kicker;
  final String title;
  final Widget? trailing;
  const KilnTitle({super.key, required this.kicker, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 8, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(kicker.toUpperCase(), style: VisualTheme.micro(9, color: VisualTheme.lichen)),
                const SizedBox(height: 4),
                Text(title, style: VisualTheme.display(28, color: VisualTheme.inkOf(context))),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class VentPair extends StatelessWidget {
  final double t;
  final Color color;
  const VentPair({super.key, required this.t, required this.color});

  @override
  Widget build(BuildContext context) {
    final h = 48 + t * 72;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: 22,
          height: h,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(11)),
        ),
        const SizedBox(width: 14),
        Container(
          width: 22,
          height: h * 0.82,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(11)),
        ),
      ],
    );
  }
}
