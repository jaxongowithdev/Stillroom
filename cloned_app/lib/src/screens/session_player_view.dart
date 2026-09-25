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
  int _step = 0;
  int _left = 0;
  bool _running = false;
  bool _done = false;
  Timer? _timer;

  PracticeSession get _session => widget.session;
  PracticeStep get _current => _session.steps[_step];

  @override
  void initState() {
    super.initState();
    _left = _current.seconds;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _tick() {
    if (_left <= 1) {
      if (_step >= _session.steps.length - 1) {
        _timer?.cancel();
        setState(() {
          _running = false;
          _done = true;
          _left = 0;
        });
        return;
      }
      setState(() {
        _step += 1;
        _left = _session.steps[_step].seconds;
      });
      return;
    }
    setState(() => _left -= 1);
  }

  void _toggle() {
    if (_done) return;
    if (_running) {
      _timer?.cancel();
      setState(() => _running = false);
      return;
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    setState(() => _running = true);
  }

  Future<void> _log(String mood) async {
    await StorageManager.instance.insertLog(
      PracticeLog(
        sessionId: _session.id,
        title: '${_session.title} · $mood',
        minutes: _session.minutes,
        completedAt: DateTime.now().toIso8601String(),
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  String _clock(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.dim ? VisualTheme.ink : VisualTheme.mistOf(context);
    final ink = widget.dim ? VisualTheme.mist : VisualTheme.inkOf(context);
    final muted = widget.dim ? const Color(0xFFB4B9BE) : VisualTheme.mutedOf(context);
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        foregroundColor: ink,
        title: Text(_session.title.toUpperCase(), style: VisualTheme.micro(10, color: VisualTheme.fuchsia)),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(22, 8, 22, 28),
        child: _done
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Walk complete.', style: VisualTheme.display(32, color: ink)),
                  const SizedBox(height: 10),
                  Text('How does the grain sit now?', style: VisualTheme.body(16, color: muted)),
                  const Spacer(),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final m in ['pewter', 'fuchsia', 'shade', 'heavy', 'clear'])
                        FilledButton(onPressed: () => _log(m), child: Text(m)),
                    ],
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value: (_step + 1) / _session.steps.length,
                    minHeight: 4,
                    backgroundColor: VisualTheme.pewter.withValues(alpha: 0.25),
                    color: VisualTheme.fuchsia,
                  ),
                  const SizedBox(height: 18),
                  Text('COLUMN ${_step + 1}  /  ${_session.steps.length}', style: VisualTheme.micro(9, color: VisualTheme.fuchsia)),
                  const SizedBox(height: 10),
                  Text(_current.title, style: VisualTheme.display(28, color: ink)),
                  const SizedBox(height: 12),
                  Text(_current.cue, style: VisualTheme.body(16, color: muted)),
                  const Spacer(),
                  Text(_clock(_left), style: VisualTheme.display(48, color: ink)),
                  const SizedBox(height: 18),
                  FilledButton(
                    onPressed: _toggle,
                    child: Text(_running ? 'Hold the walk' : 'Raise the column'),
                  ),
                ],
              ),
      ),
    );
  }
}
