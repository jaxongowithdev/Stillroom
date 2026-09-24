import 'package:flutter/material.dart';
import '../utils/visual_theme.dart';
import '../widgets/kiln_chrome.dart';
import 'ash_view.dart';
import 'batch_view.dart';
import 'flue_view.dart';
import 'folio_view.dart';
import 'hearth_view.dart';

class DashboardView extends StatefulWidget {
  final VoidCallback onPrefsChanged;
  const DashboardView({super.key, required this.onPrefsChanged});

  @override
  State<DashboardView> createState() => DashboardViewState();
}

class DashboardViewState extends State<DashboardView> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SandWash(
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  SafeArea(
                    bottom: false,
                    right: false,
                    child: KilnTitle(
                      kicker: 'Lichen Kiln',
                      title: KilnRail.items[_index].$2,
                      trailing: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => FlueView(onPrefsChanged: widget.onPrefsChanged)),
                          );
                        },
                        icon: Icon(Icons.tune, color: VisualTheme.mutedOf(context)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: IndexedStack(
                      index: _index,
                      children: const [
                        HearthView(),
                        BatchView(),
                        AshView(),
                        FolioView(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            KilnRail(index: _index, onSelect: (i) => setState(() => _index = i)),
          ],
        ),
      ),
    );
  }
}
