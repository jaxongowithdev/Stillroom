import 'package:flutter/material.dart';
import '../widgets/brume_chrome.dart';
import 'lamp_view.dart';
import 'lessons_view.dart';
import 'nook_view.dart';
import 'pages_view.dart';

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
      body: NightWash(
        child: Column(
          children: [
            Expanded(
              child: IndexedStack(
                index: _index,
                children: [
                  LampView(
                    onOpenNook: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => NookView(onPrefsChanged: widget.onPrefsChanged),
                        ),
                      );
                    },
                  ),
                  const LessonsView(),
                  const PagesView(),
                ],
              ),
            ),
            WickBar(index: _index, onSelect: (i) => setState(() => _index = i)),
          ],
        ),
      ),
    );
  }
}
