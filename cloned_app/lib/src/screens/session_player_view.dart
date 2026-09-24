import 'dart:async';
import 'package:flutter/material.dart';
import '../database/storage_manager.dart';
import '../models/practice_models.dart';
import '../utils/visual_theme.dart';

/// Huge step index, cue in the middle, a filling gesso bar for remaining time.
class SessionPlayerView extends StatefulWidget {
  final PracticeSession session;
  final bool dim;
  const SessionPlayerView({super.key, required this.session, this.dim = false});

  @override
  State<SessionPlayerView> createState() => _SessionPlayerViewState();
}

class _SessionPlayerViewState extends State<SessionPlayerView> {
  int _index = 0;
  int _left = 0;
  Timer? _timer;
  bool _running = false;
  bool _done = false;

  PracticeStep get _step => widget.session.steps[_index];

  @override
  void initState() {
    super.initState();
    _left = widget.session.steps.first.seconds;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggle() {
    if (_done) return;
    if (_running) {
      _timer?.cancel();
      setState(() => _running = false);
      return;
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_left <= 1) {
        _advance();
      } else {
        setState(() => _left -= 1);
      }
    });
    setState(() => _running = true);
  }

  void _advance() {
    if (_index >= widget.session.steps.length - 1) {
      _timer?.cancel();
      setState(() {
        _running = false;
        _done = true;
        _left = 0;
      });
      _log();
      return;
    }
    setState(() {
      _index += 1;
      _left = widget.session.steps[_index].seconds;
    });
  }

  Future<void> _log() async {
    await StorageManager.instance.insertLog(
      PracticeLog(
        sessionId: widget.session.id,
        title: widget.session.title,
        minutes: widget.session.minutes,
        completedAt: DateTime.now().toIso8601String(),
      ),
    );
  }

  String _clock(int s) {
    final m = (s ~/ 60).toString().padLeft(2, '0');
    final r = (s % 60).toString().padLeft(2, '0');
    return '$m:$r';
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.dim ? VisualTheme.night : VisualTheme.gessoOf(context);
    final ink = widget.dim ? VisualTheme.nightInk : VisualTheme.inkOf(context);
    final muted = ink.withValues(alpha: 0.62);
    final total = _step.seconds;
    final t = total == 0 ? 0.0 : (1 - (_left / total)).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        foregroundColor: ink,
        title: Text(widget.session.title.toUpperCase(), style: VisualTheme.micro(10, color: VisualTheme.rose)),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(22, 8, 22, 24),
        child: _done
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Text('The attic is still.', style: VisualTheme.display(32, color: ink)),
                  const SizedBox(height: 12),
                  Text('${widget.session.title} is filed in your private log. Nothing left this phone.', style: VisualTheme.body(16, color: muted)),
                  const Spacer(),
                  FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Back to the easel')),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${(_index + 1).toString().padLeft(2, '0')}  /  ${widget.session.steps.length.toString().padLeft(2, '0')}',
                    style: VisualTheme.display(48, color: VisualTheme.rose, w: FontWeight.w400),
                  ),
                  const SizedBox(height: 12),
                  Text(_step.title, style: VisualTheme.heading(22, color: ink)),
                  const SizedBox(height: 10),
                  Text(_step.cue, style: VisualTheme.body(16, color: muted)),
                  const Spacer(),
                  Text(_clock(_left), style: VisualTheme.micro(12, color: muted)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 8,
                    child: Stack(
                      children: [
                        Container(color: ink.withValues(alpha: 0.1)),
                        FractionallySizedBox(
                          widthFactor: t,
                          child: Container(color: VisualTheme.prussian),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(onPressed: _toggle, child: Text(_running ? 'Hold' : 'Prime')),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () {
                          _timer?.cancel();
                          setState(() => _running = false);
                          _advance();
                        },
                        child: const Text('SKIP'),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
