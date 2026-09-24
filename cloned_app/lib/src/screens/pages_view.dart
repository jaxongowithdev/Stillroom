import 'package:flutter/material.dart';
import '../data/library.dart';
import '../database/storage_manager.dart';
import '../models/practice_models.dart';
import '../utils/visual_theme.dart';
import '../widgets/brume_chrome.dart';

class PagesView extends StatefulWidget {
  const PagesView({super.key});

  @override
  State<PagesView> createState() => _PagesViewState();
}

class _PagesViewState extends State<PagesView> {
  List<JournalEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final rows = await StorageManager.instance.allJournal();
    if (mounted) setState(() => _entries = rows);
  }

  Future<void> _compose() async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const _ComposePage()));
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final muted = VisualTheme.mutedOf(context);
    final ink = VisualTheme.inkOf(context);
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlowHeader(
            kicker: 'Private paper',
            title: 'Pages',
            trailing: TextButton(onPressed: _compose, child: const Text('WRITE')),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
            child: Text(
              'A private journal — fully offline. Notes stay in this app’s storage. They are never uploaded.',
              style: VisualTheme.body(14, color: muted),
            ),
          ),
          Expanded(
            child: _entries.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(36),
                      child: Text(
                        'The page is blank. Write one honest sentence after a sit — or before sleep.',
                        textAlign: TextAlign.center,
                        style: VisualTheme.body(16, color: muted),
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                    itemCount: _entries.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final e = _entries[i];
                      final when = DateTime.tryParse(e.createdAt);
                      final stamp = when == null ? e.mood : '${when.day}.${when.month}  ·  ${e.mood}';
                      return Dismissible(
                        key: ValueKey(e.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) async {
                          if (e.id != null) await StorageManager.instance.deleteJournal(e.id!);
                          _load();
                        },
                        background: Container(
                          decoration: BoxDecoration(
                            color: VisualTheme.ember.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                          decoration: BoxDecoration(
                            color: VisualTheme.panelOf(context),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e.body, maxLines: 4, overflow: TextOverflow.ellipsis, style: VisualTheme.body(15, color: ink)),
                              const SizedBox(height: 8),
                              Text(stamp.toUpperCase(), style: VisualTheme.micro(9, color: muted)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ComposePage extends StatefulWidget {
  const _ComposePage();

  @override
  State<_ComposePage> createState() => _ComposePageState();
}

class _ComposePageState extends State<_ComposePage> {
  final _body = TextEditingController();
  late String _prompt;
  String _mood = 'ember';

  @override
  void initState() {
    super.initState();
    _prompt = PracticeLibrary.prompts[DateTime.now().day % PracticeLibrary.prompts.length];
  }

  @override
  void dispose() {
    _body.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final text = _body.text.trim();
    if (text.isEmpty) return;
    await StorageManager.instance.insertJournal(
      JournalEntry(
        mood: _mood,
        prompt: _prompt,
        body: text,
        createdAt: DateTime.now().toIso8601String(),
      ),
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final muted = VisualTheme.mutedOf(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Write')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        children: [
          Text(_prompt, style: VisualTheme.display(26, color: VisualTheme.inkOf(context))),
          const SizedBox(height: 18),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final m in PracticeLibrary.moods)
                GestureDetector(
                  onTap: () => setState(() => _mood = m),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _mood == m ? VisualTheme.lamp.withValues(alpha: 0.2) : VisualTheme.panelOf(context),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(m.toUpperCase(), style: VisualTheme.micro(9, color: VisualTheme.inkOf(context))),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _body,
            maxLines: 10,
            decoration: const InputDecoration(hintText: 'One honest sentence is enough.'),
          ),
          const SizedBox(height: 8),
          Text('Swipe a page later to delete it. Nothing is backed up off this phone.', style: VisualTheme.body(13, color: muted)),
          const SizedBox(height: 20),
          FilledButton(onPressed: _save, child: const Text('Keep on this phone')),
        ],
      ),
    );
  }
}
