import 'package:flutter/material.dart';
import '../utils/visual_theme.dart';
import '../widgets/stoa_chrome.dart';
import 'plinth_view.dart';
import 'range_view.dart';
import 'shade_view.dart';
import 'tablet_view.dart';
import 'walk_view.dart';

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
      body: MistWash(
        child: Column(
          children: [
            SafeArea(
              bottom: false,
              child: StoaTitle(
                trailing: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => PlinthView(onPrefsChanged: widget.onPrefsChanged)),
                    );
                  },
                  icon: Icon(Icons.view_column_outlined, color: VisualTheme.mutedOf(context)),
                ),
              ),
            ),
            StoaColon(index: _index, onSelect: (i) => setState(() => _index = i)),
            Expanded(
              child: IndexedStack(
                index: _index,
                children: const [
                  WalkView(),
                  RangeView(),
                  ShadeView(),
                  TabletView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
