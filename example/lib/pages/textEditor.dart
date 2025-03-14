import 'package:flutter/material.dart';
import 'package:leoui/ui/packages/textEditor/textEditor.dart';

class TextEditorPage extends StatefulWidget {
  const TextEditorPage({super.key});

  @override
  State<TextEditorPage> createState() => _TextEditorPagetate();
}

class _TextEditorPagetate extends State<TextEditorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TextEditor - 图文混排编辑器')),
      body: SingleChildScrollView(
        child: TextEdtor(),
      ),
    );
  }
}
