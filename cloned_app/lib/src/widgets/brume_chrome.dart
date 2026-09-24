import 'package:flutter/material.dart';
import '../models/practice_models.dart';
import '../utils/visual_theme.dart';

class NightWash extends StatelessWidget {
  final Widget child;
  const NightWash({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: dark
              ? const [Color(0xFF1A2430), VisualTheme.night]
              : const [Color(0xFFF4F7FA), VisualTheme.day],
        ),
      ),
      child: child,
    );
  }
}

class WickBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onSelect;
  const WickBar({super.key, required this.index, required this.onSelect});

  static const _items = [
    (Icons.light_mode_outlined, 'Lamp'),
    (Icons.auto_stories_outlined, 'Lessons'),
    (Icons.menu_book_outlined, 'Pages'),
  ];

  @override
  Widget build(BuildContext context) {
    final ink = VisualTheme.inkOf(context);
    final muted = VisualTheme.mutedOf(context);
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 0, 28, 12),
        child: Material(
          color: VisualTheme.panelOf(context),
          borderRadius: BorderRadius.circular(40),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                for (var i = 0; i < _items.length; i++)
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onSelect(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: i == index ? VisualTheme.lamp.withValues(alpha: 0.18) : Colors.transparent,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_items[i].$1, size: 20, color: i == index ? VisualTheme.lamp : muted),
                            const SizedBox(height: 4),
                            Text(
                              _items[i].$2.toUpperCase(),
                              style: VisualTheme.micro(8, color: i == index ? ink : muted),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LampCard extends StatelessWidget {
  final PracticeSession session;
  final VoidCallback onTap;
  const LampCard({super.key, required this.session, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final ink = VisualTheme.inkOf(context);
    final muted = VisualTheme.mutedOf(context);
    return Material(
      color: VisualTheme.panelOf(context),
      borderRadius: BorderRadius.circular(VisualTheme.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(VisualTheme.r),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: VisualTheme.kindTint(session.kind),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${session.kind.toUpperCase()}  ·  ${session.minutes} MIN',
                style: VisualTheme.micro(10, color: muted),
              ),
              const SizedBox(height: 8),
              Text(session.title, style: VisualTheme.display(26, color: ink)),
              const SizedBox(height: 6),
              Text(session.subtitle, style: VisualTheme.body(14, color: muted)),
            ],
          ),
        ),
      ),
    );
  }
}

class GlowHeader extends StatelessWidget {
  final String kicker;
  final String title;
  final Widget? trailing;
  const GlowHeader({super.key, required this.kicker, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    final ink = VisualTheme.inkOf(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(kicker.toUpperCase(), style: VisualTheme.micro(10, color: VisualTheme.lamp)),
                const SizedBox(height: 8),
                Text(title, style: VisualTheme.display(34, color: ink)),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
