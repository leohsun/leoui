import 'package:flutter/material.dart';
import 'package:leoui/ui/packages/stickyColumn/stickyColumn.dart';
import 'package:leoui/ui/packages/stickyColumn/stickyContainer.dart';

class StickyContainerPage extends StatelessWidget {
  const StickyContainerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('StickyContainer - 粘性定位')),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 800,
              ),
              StickyColumn(
                children: [
                  StickyContainer(
                    top: 20,
                    child: Container(
                      color: Colors.yellowAccent,
                      width: double.infinity,
                      alignment: Alignment.center,
                      height: 120,
                      child: Text("top:20"),
                    ),
                  ),
                  Container(
                    color: Colors.greenAccent,
                    height: 100,
                  ),
                  StickyContainer(
                    bottom: 200,
                    child: Container(
                      color: Colors.amber,
                      width: double.infinity,
                      alignment: Alignment.center,
                      height: 120,
                      child: Text("bottom:200"),
                    ),
                  ),
                  Container(
                    color: Colors.grey,
                    height: 300,
                  )
                ],
              ),
              SizedBox(
                height: 2000,
              )
            ],
          ),
        ));
  }
}
