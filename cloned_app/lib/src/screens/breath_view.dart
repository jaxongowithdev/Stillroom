import 'package:flutter/material.dart';
import '../models/practice_models.dart';
import '../utils/visual_theme.dart';
import '../widgets/gesso_chrome.dart';

/// A picture frame that grows on prime and shrinks on lift — not a circle, bar, diamond, hexagon, vents, or stones.
class BreathView extends StatefulWidget {
  final BreathPattern pattern;
  const BreathView({super.key, required this.pattern});

  @override
  State<BreathView> createState() => _BreathViewState();
}

class _BreathViewState extends State<BreathView> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  int _phase = 0;
  int _round = 1;
  bool _running = false;

  BreathPhase get _current => widget.pattern.phases[_phase];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: Duration(seconds: _current.seconds));
    _ctrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) _next();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _arm() {
    _ctrl.duration = Duration(seconds: _current.seconds);
    _ctrl.forward(from: 0);
  }

  void _toggle() {
    if (_running) {
      _ctrl.stop();
      setState(() => _running = false);
      return;
    }
    setState(() => _running = true);
    _arm();
  }

  void _next() {
    final lastPhase = _phase >= widget.pattern.phases.length - 1;
    if (lastPhase && _round >= widget.pattern.rounds) {
      setState(() => _running = false);
      return;
    }
    setState(() {
      if (lastPhase) {
        _phase = 0;
        _round += 1;
      } else {
        _phase += 1;
      }
    });
    if (_running) _arm();
  }

  @override
  Widget build(BuildContext context) {
    final ink = VisualTheme.inkOf(context);
    final muted = VisualTheme.mutedOf(context);
    final prime = _current.label.toLowerCase() == 'prime';
    final lift = _current.label.toLowerCase() == 'lift';

    return Scaffold(
      appBar: AppBar(title: Text(widget.pattern.name.toUpperCase(), style: VisualTheme.micro(10, color: VisualTheme.rose))),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(28, 12, 28, 24),
        child: Column(
          children: [
            Text(widget.pattern.teaching, style: VisualTheme.body(15, color: muted)),
            const Spacer(),
            AnimatedBuilder(
              animation: _ctrl,
              builder: (context, _) {
                double t;
                if (prime) {
                  t = _ctrl.value;
                } else if (lift) {
                  t = 1 - _ctrl.value;
                } else {
                  t = _current.label.toLowerCase() == 'rest' ? 0.22 : 0.88;
                }
                final w = 70 + t * 110;
                final h = 88 + t * 90;
                return SizedBox(
                  width: w,
                  height: h,
                  child: CustomPaint(
                    painter: FramePainter(VisualTheme.prussian.withValues(alpha: 0.35 + t * 0.55), stroke: 7),
                  ),
                );
              },
            ),
            const SizedBox(height: 28),
            Text(_current.label.toUpperCase(), style: VisualTheme.micro(13, color: ink)),
            const SizedBox(height: 8),
            Text('Round $_round of ${widget.pattern.rounds}', style: VisualTheme.body(14, color: muted)),
            const Spacer(),
            FilledButton(onPressed: _toggle, child: Text(_running ? 'Hold' : 'Prime the frame')),
          ],
        ),
      ),
    );
  }
}
