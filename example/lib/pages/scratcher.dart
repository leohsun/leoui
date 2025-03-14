import 'package:flutter/material.dart';
import 'package:leoui/leoui.dart';

class ScratcherPage extends StatelessWidget {
  const ScratcherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('scratcher - 刮板')),
        body: Center(
          child: Scratcher(
            mask: Image.asset('assets/scratcher_02.png', fit: BoxFit.cover),
            child: Image.asset('assets/scratcher_01.png',
                width: 265.4, height: 128, fit: BoxFit.cover),
          ),
        ));
  }
}
