import 'dart:async';
import 'package:flutter/material.dart';
import '../database/storage_manager.dart';
import '../models/practice_models.dart';
import '../utils/visual_theme.dart';

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
    final bg = VisualTheme.night;
    const ink = VisualTheme.mist;
    final muted = ink.withValues(alpha: 0.65);
    final t = _step.seconds == 0 ? 0.0 : 1 - (_left / _step.seconds);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        foregroundColor: ink,
        title: Text(widget.session.title.toUpperCase(), style: VisualTheme.micro(11, color: VisualTheme.lamp)),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(28, 8, 28, 28),
        child: _done
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Text('The lamp is dim.', style: VisualTheme.display(36, color: ink)),
                  const SizedBox(height: 12),
                  Text(
                    '${widget.session.title} is filed in your private log. Nothing left this phone.',
                    style: VisualTheme.body(16, color: muted),
                  ),
                  const Spacer(),
                  FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Back to the room')),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WICK ${_index + 1}  OF  ${widget.session.steps.length}',
                    style: VisualTheme.micro(10, color: muted),
                  ),
                  const SizedBox(height: 16),
                  Text(_step.title, style: VisualTheme.display(34, color: ink)),
                  const SizedBox(height: 16),
                  Text(_step.cue, style: VisualTheme.body(17, color: muted)),
                  const Spacer(),
                  Center(
                    child: SizedBox(
                      width: 168,
                      height: 168,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: t,
                            strokeWidth: 3,
                            backgroundColor: ink.withValues(alpha: 0.12),
                            color: VisualTheme.lamp,
                          ),
                          Text(_clock(_left), style: VisualTheme.heading(28, color: ink)),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: _toggle,
                          child: Text(_running ? 'Hold' : 'Light'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: () {
                          _timer?.cancel();
                          setState(() => _running = false);
                          _advance();
                        },
                        child: const Text('Skip'),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
