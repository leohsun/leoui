import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leoui/leoui.dart';
import 'package:leoui/utils/index.dart';

class SliderPage extends StatefulWidget {
  const SliderPage({Key? key}) : super(key: key);

  @override
  _SliderPageState createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios_new_rounded)),
          title: Text('Slider-滑动层'),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              width: double.infinity,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ListTile(
                      title: Text('关闭可调用hideSlider()'),
                    ),
                    Button('中', full: true, onTap: () {
                      showSlider(
                          child: Container(
                            height: SizeTool.deviceWidth / 2,
                            width: SizeTool.deviceWidth - 20,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          direction: SliderDirection.center,
                          closeOnClickMask: true);
                    }),
                    SizedBox(
                      height: 20,
                    ),
                    Button('左', full: true, onTap: () {
                      showSlider(
                          child: Stack(
                            children: [
                              Positioned(
                                child: Container(
                                  color: Colors.white,
                                  height: SizeTool.deviceHeight,
                                  width: SizeTool.deviceWidth / 2,
                                  child: Center(
                                    child: Text(
                                      'from left',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          closeOnClickMask: true,
                          direction: SliderDirection.left);
                    }),
                    SizedBox(
                      height: 20,
                    ),
                    Button('上', full: true, onTap: () {
                      showSlider(
                          child: Stack(
                            children: [
                              Positioned(
                                child: Container(
                                  color: Colors.white,
                                  height: SizeTool.deviceHeight / 5,
                                  child: Center(
                                    child: Text(
                                      'from top',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          closeOnClickMask: true,
                          direction: SliderDirection.top);
                    }),
                    SizedBox(
                      height: 20,
                    ),
                    Button('右', full: true, onTap: () {
                      showSlider(
                          child: Stack(
                            children: [
                              Positioned(
                                right: 0,
                                child: Container(
                                  color: Colors.white,
                                  width: SizeTool.deviceWidth / 2,
                                  height: SizeTool.deviceHeight,
                                  child: Center(
                                    child: Text(
                                      'from right',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          closeOnClickMask: true,
                          direction: SliderDirection.right);
                    }),
                    SizedBox(
                      height: 20,
                    ),
                    Button('下', full: true, onTap: () {
                      showSlider(
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  color: Colors.white,
                                  width: SizeTool.deviceWidth,
                                  height: SizeTool.deviceHeight / 5,
                                  child: Center(
                                    child: Text(
                                      'from bottom',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          closeOnClickMask: true,
                          direction: SliderDirection.bottom);
                    }),
                    SizedBox(
                      height: 20,
                    ),
                  ]),
            ),
          ),
        ));
  }
}
