import 'package:flutter/material.dart';

import '../database/storage_manager.dart';
import '../models/practice_models.dart';
import '../utils/visual_theme.dart';

class TabletView extends StatefulWidget {
  const TabletView({super.key});

  @override
  State<TabletView> createState() => _TabletViewState();
}

class _TabletViewState extends State<TabletView> {
  final _controller = TextEditingController();
  List<JournalEntry> _rows = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final rows = await StorageManager.instance.allJournal();
    if (!mounted) return;
    setState(() => _rows = rows);
  }

  Future<void> _save() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    await StorageManager.instance.insertJournal(
      JournalEntry(
        mood: 'clear',
        prompt: 'stillroom-note',
        body: text,
        createdAt: DateTime.now().toIso8601String(),
      ),
    );
    _controller.clear();
    await _load();
  }

  String _stamp(String raw) {
    final at = DateTime.tryParse(raw);
    if (at == null) return raw;
    return '${at.year}-${at.month.toString().padLeft(2, '0')}-${at.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final ink = VisualTheme.inkOf(context);
    final muted = VisualTheme.mutedOf(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      children: [
        Text(
          'Your private journal. Every note stays only on this device — no account, no cloud.',
          style: VisualTheme.body(15, color: muted),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _controller,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'What do you want to remember from this moment?',
          ),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton(onPressed: _save, child: const Text('Save note')),
        ),
        const SizedBox(height: 18),
        Text(
          'YOUR NOTES',
          style: VisualTheme.micro(9, color: VisualTheme.fuchsia),
        ),
        const SizedBox(height: 8),
        if (_rows.isEmpty)
          Text(
            'Nothing saved yet. This is a good place to begin.',
            style: VisualTheme.body(14, color: muted),
          ),
        ..._rows.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              color: VisualTheme.bayOf(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _stamp(e.createdAt),
                    style: VisualTheme.micro(8, color: VisualTheme.fuchsia),
                  ),
                  const SizedBox(height: 6),
                  Text(e.body, style: VisualTheme.body(15, color: ink)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
