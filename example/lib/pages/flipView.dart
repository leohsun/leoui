import 'package:flutter/material.dart';
import 'package:leoui/ui/packages/flipView/flipView.dart';

class FlipViewPage extends StatelessWidget {
  const FlipViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Container(
            height: 100,
            color: Colors.red,
          ),
          Flexible(
            child: Transform.scale(
              scale: 1.1,
              child: FlipView(
                children: [
                  Text('a' * 300),
                  Text("b" * 300),
                  Text("c" * 300),
                  Text("d" * 300),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
