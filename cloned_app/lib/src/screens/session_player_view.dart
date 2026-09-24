import 'dart:async';
import 'package:flutter/material.dart';
import '../database/storage_manager.dart';
import '../models/practice_models.dart';
import '../utils/visual_theme.dart';
import '../widgets/kiln_chrome.dart';

/// Cue in the middle, timer top-right, horizontal kiln-shelf of step tiles at the bottom.
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
    final bg = widget.dim ? VisualTheme.night : VisualTheme.sandOf(context);
    final ink = widget.dim ? VisualTheme.nightInk : VisualTheme.inkOf(context);
    final muted = ink.withValues(alpha: 0.62);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        foregroundColor: ink,
        title: Text(widget.session.title.toUpperCase(), style: VisualTheme.micro(10, color: VisualTheme.lichen)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 14),
            child: Text(_done ? '' : _clock(_left), style: VisualTheme.heading(18, color: VisualTheme.lichen)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: _done
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Text('The kiln is still.', style: VisualTheme.display(32, color: ink)),
                  const SizedBox(height: 12),
                  Text('${widget.session.title} is filed in your private log. Nothing left this phone.', style: VisualTheme.body(16, color: muted)),
                  const Spacer(),
                  FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Back to the hearth')),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('VENT ${_index + 1}  —  ${widget.session.steps.length}', style: VisualTheme.micro(10, color: muted)),
                  const Spacer(),
                  Text(_step.title, style: VisualTheme.display(34, color: ink)),
                  const SizedBox(height: 12),
                  Text(_step.cue, style: VisualTheme.body(17, color: muted)),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(onPressed: _toggle, child: Text(_running ? 'Hold' : 'Fire')),
                      ),
                      const SizedBox(width: 8),
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
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 56,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.session.steps.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 6),
                      itemBuilder: (context, i) {
                        final on = i == _index;
                        return Container(
                          width: 44,
                          decoration: BoxDecoration(
                            color: on
                                ? VisualTheme.lichen
                                : ink.withValues(alpha: i < _index ? 0.28 : 0.08),
                            borderRadius: potRadius,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${i + 1}',
                            style: VisualTheme.heading(14, color: on ? Colors.white : ink),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
