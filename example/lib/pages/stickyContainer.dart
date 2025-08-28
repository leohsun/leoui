import 'package:flutter/material.dart';
import 'package:leoui/leoui.dart';

class StickyContainerPage extends StatefulWidget {
  const StickyContainerPage({super.key});

  @override
  State<StickyContainerPage> createState() => _StickyContainerPageState();
}

class _StickyContainerPageState extends State<StickyContainerPage> {
  double top = 50;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('StickyContainer - 粘性定位')),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 200,
              ),
              ColoredBox(
                color: Colors.red,
                child: StickyColumn(
                  children: [
                    Container(
                      height: 100,
                      color: Colors.green,
                    ),
                    StickyContainer(
                      top: top,
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black54,
                        ),
                        child: Center(
                          child: TextButton.icon(
                            label: Text("Tap"),
                            icon: Icon(Icons.ads_click),
                            onPressed: () {
                              showToast("clicked");
                            },
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 100,
                      color: Colors.amberAccent,
                    ),
                    // StickyContainer(
                    //   bottom: 20,
                    //   child: Column(
                    //     children: [
                    //       Container(
                    //         color: Colors.yellowAccent,
                    //         width: double.infinity,
                    //         alignment: Alignment.center,
                    //         height: 120,
                    //         child: Text("bottom:20"),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 200,
                    // )
                  ],
                ),
              ),
              SizedBox(
                height: 4000,
              )
            ],
          ),
        ));
  }
}
