import 'package:flutter/material.dart';

import '../../app.dart';
import '../../config/res_manager.dart';
import 'animated_ellipsis_text.dart';
import 'crt_background.dart';
import 'pinball_loading_indicator.dart';

class AssetsLoadingPage extends StatefulWidget {
  const AssetsLoadingPage({Key? key}) : super(key: key);

  @override
  State<AssetsLoadingPage> createState() => _AssetsLoadingPageState();
}

class _AssetsLoadingPageState extends State<AssetsLoadingPage> {
  bool get isLoading => _progress != 1;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    ResManager.instance.load();
    ResManager.instance.loadStream.listen(_onLoading);
  }

  void _onLoading(double progress) {
    if (progress == 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const PlatformAdapterApp(),
        ),
      );
    }
    _progress = progress;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // final l10n = context.l10n;
    final headline1 = Theme.of(context).textTheme.displayMedium;
    return Container(
      decoration: const CrtBackground(),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                      'assets/images/break_bricks/Colored_Blue-64x32.png'),
                  Image.asset(
                      'assets/images/break_bricks/Colored_Orange-64x32.png'),
                  Image.asset(
                      'assets/images/break_bricks/Colored_Red-64x32.png'),
                ],
              ),
            ),
            const SizedBox(height: 60),
            AnimatedEllipsisText(
              'Loading',
              style: headline1?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 60),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: PinballLoadingIndicator(value: _progress),
            ),
          ],
        ),
      ),
    );
  }
}
