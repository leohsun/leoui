library leoui;

import 'package:flutter/material.dart';
import 'package:leoui/leoui_state.dart';

export './feedback/index.dart';
export './model/index.dart';
export './utils/index.dart';
export './ui/index.dart';
export './config/index.dart';

class Leoui extends StatelessWidget {
  final MaterialApp child;
  final LeouiConfig? config;

  /// executing when setup is completed,
  /// at this time [LeoFeedback.currentContext] was initialized
  /// can call feedback functions like: [showModal]
  final VoidCallback? initState;
  final VoidCallback? dispose;
  final Future Function()? setup;
  final Widget? setupPlaceholder;
  const Leoui(
      {Key? key,
      required this.child,
      this.setup,
      this.config,
      this.initState,
      this.dispose,
      this.setupPlaceholder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth == 0) {
        return setupPlaceholder ?? Container(color: Colors.white);
      }
      return LeouiState(
        child: child,
        config: config,
        setup: setup,
        initState: initState,
        dispose: dispose,
        setupPlaceholder: setupPlaceholder,
      );
    });
  }
}
