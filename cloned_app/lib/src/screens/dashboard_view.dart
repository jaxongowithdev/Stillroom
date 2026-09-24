import 'package:flutter/material.dart';
import '../utils/visual_theme.dart';
import '../widgets/gesso_chrome.dart';
import 'canvas_view.dart';
import 'easel_view.dart';
import 'primer_view.dart';
import 'sketch_view.dart';
import 'wash_view.dart';

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
      body: GessoWash(
        child: Column(
          children: [
            SafeArea(
              bottom: false,
              child: AtticTitle(
                kicker: 'Gesso Attic',
                trailing: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => PrimerView(onPrefsChanged: widget.onPrefsChanged)),
                    );
                  },
                  icon: Icon(Icons.border_color_outlined, color: VisualTheme.mutedOf(context)),
                ),
              ),
            ),
            AtticTabs(index: _index, onSelect: (i) => setState(() => _index = i)),
            Expanded(
              child: IndexedStack(
                index: _index,
                children: const [
                  EaselView(),
                  CanvasView(),
                  WashView(),
                  SketchView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
