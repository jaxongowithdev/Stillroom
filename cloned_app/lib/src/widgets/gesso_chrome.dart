import 'package:flutter/material.dart';
import '../models/practice_models.dart';
import '../utils/visual_theme.dart';

class GessoWash extends StatelessWidget {
  final Widget child;
  const GessoWash({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(color: VisualTheme.gessoOf(context), child: child);
  }
}

/// Full-width underline rooms — not chips, not a dock, not a side rail.
class AtticTabs extends StatelessWidget {
  final int index;
  final ValueChanged<int> onSelect;
  const AtticTabs({super.key, required this.index, required this.onSelect});

  static const items = ['Easel', 'Canvas', 'Wash', 'Sketch'];

  @override
  Widget build(BuildContext context) {
    final muted = VisualTheme.mutedOf(context);
    final ink = VisualTheme.inkOf(context);
    return Container(
      decoration: BoxDecoration(
        color: VisualTheme.canvasOf(context),
        border: Border(
          top: BorderSide(color: VisualTheme.prussian.withValues(alpha: 0.18), width: 1),
          bottom: BorderSide(color: VisualTheme.rule, width: 1),
        ),
      ),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++)
            Expanded(
              child: InkWell(
                onTap: () => onSelect(i),
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Column(
                    children: [
                      Text(
                        items[i],
                        style: VisualTheme.heading(14, color: i == index ? ink : muted),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 2,
                        color: i == index ? VisualTheme.prussian : Colors.transparent,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CanvasCard extends StatelessWidget {
  final PracticeSession session;
  final VoidCallback onTap;
  const CanvasCard({super.key, required this.session, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final ink = VisualTheme.inkOf(context);
    final muted = VisualTheme.mutedOf(context);
    return Material(
      color: VisualTheme.canvasOf(context),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 3, color: VisualTheme.kindTint(session.kind)),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${session.kind.toUpperCase()}   ${session.minutes} MIN', style: VisualTheme.micro(8, color: muted)),
                  const SizedBox(height: 8),
                  Text(session.title, style: VisualTheme.display(24, color: ink)),
                  const SizedBox(height: 6),
                  Text(session.subtitle, style: VisualTheme.body(14, color: muted)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AtticTitle extends StatelessWidget {
  final String kicker;
  final Widget? trailing;
  const AtticTitle({super.key, required this.kicker, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 4),
      child: Row(
        children: [
          Expanded(
            child: Text(kicker.toUpperCase(), style: VisualTheme.micro(10, color: VisualTheme.rose)),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class FramePainter extends CustomPainter {
  final Color color;
  final double stroke;
  FramePainter(this.color, {this.stroke = 8});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(stroke / 2, stroke / 2, size.width - stroke, size.height - stroke);
    canvas.drawRect(
      rect,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke,
    );
  }

  @override
  bool shouldRepaint(FramePainter old) => old.color != color || old.stroke != stroke;
}
