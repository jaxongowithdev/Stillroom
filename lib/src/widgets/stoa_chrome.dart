import 'package:flutter/material.dart';

import '../models/practice_models.dart';
import '../utils/visual_theme.dart';

class MistWash extends StatelessWidget {
  final Widget child;
  const MistWash({super.key, required this.child});

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              VisualTheme.mistOf(context),
              VisualTheme.sky.withValues(alpha: .28),
            ],
          ),
        ),
        child: child,
      );
}

/// Public chrome API retained; now a rounded room switcher rather than columns.
class StoaColon extends StatelessWidget {
  final int index;
  final ValueChanged<int> onSelect;
  const StoaColon({super.key, required this.index, required this.onSelect});

  static const items = [
    ('Walk', Icons.wb_sunny_outlined),
    ('Range', Icons.grid_view_rounded),
    ('Rest', Icons.nightlight_round),
    ('Tablet', Icons.edit_note_rounded),
  ];

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
        child: Container(
          decoration: BoxDecoration(
            color: VisualTheme.bayOf(context),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: VisualTheme.ink.withValues(alpha: .06),
                blurRadius: 18,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: Semantics(
                    button: true,
                    selected: i == index,
                    label: items[i].$1,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () => onSelect(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        decoration: BoxDecoration(
                          color: i == index
                              ? VisualTheme.inkOf(context)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(17),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              items[i].$2,
                              size: 19,
                              color: i == index
                                  ? Colors.white
                                  : VisualTheme.mutedOf(context),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              items[i].$1,
                              style: VisualTheme.micro(
                                8,
                                color: i == index
                                    ? Colors.white
                                    : VisualTheme.mutedOf(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
}

class BayCard extends StatelessWidget {
  final PracticeSession session;
  final VoidCallback onTap;
  const BayCard({super.key, required this.session, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final ink = VisualTheme.inkOf(context);
    final muted = VisualTheme.mutedOf(context);
    final tint = VisualTheme.kindTint(session.kind);
    return Material(
      color: VisualTheme.bayOf(context),
      borderRadius: BorderRadius.circular(26),
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: tint.withValues(alpha: .16),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  session.kind == 'breath'
                      ? Icons.air_rounded
                      : Icons.self_improvement_rounded,
                  color: tint,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${session.kind.toUpperCase()}  ·  ${session.minutes} MIN',
                      style: VisualTheme.micro(8, color: muted),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      session.title,
                      style: VisualTheme.heading(21, color: ink),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      session.subtitle,
                      style: VisualTheme.body(13, color: muted),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_rounded, color: tint),
            ],
          ),
        ),
      ),
    );
  }
}

class StoaTitle extends StatelessWidget {
  final Widget? trailing;
  const StoaTitle({super.key, this.trailing});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(22, 12, 12, 0),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: VisualTheme.apricot,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.door_front_door_outlined,
                size: 18,
                color: VisualTheme.ink,
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                'STILLROOM',
                style: VisualTheme.micro(11, color: VisualTheme.inkOf(context)),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      );
}

class ColumnWalk extends StatelessWidget {
  final double t;
  final Color color;
  const ColumnWalk({super.key, required this.t, required this.color});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 160,
        height: 150,
        child: Stack(
          alignment: Alignment.center,
          children: [
            for (var i = 0; i < 4; i++)
              Positioned(
                left: 18 + i * 32.0,
                bottom: 12,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 450),
                  width: 22,
                  height: 42 + (i.isEven ? t : 1 - t) * 88,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .34 + .14 * i),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
          ],
        ),
      );
}
