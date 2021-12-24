import 'package:flutter/material.dart';
import 'package:leoui/leoui.dart';

class PopoverPage extends StatefulWidget {
  const PopoverPage({Key? key}) : super(key: key);

  @override
  _PopoverPageState createState() => _PopoverPageState();
}

class _PopoverPageState extends State<PopoverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   leading: IconButton(
        //       onPressed: () {
        //         Navigator.of(context).pop();
        //       },
        //       icon: Icon(Icons.arrow_back_ios_new_rounded)),
        //   title: Text('popover-弹出框'),
        // ),
        body: SafeArea(
      child: SingleChildScrollView(
        child: Container(
          height: SizeTool.deviceHeight * 2,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Popover(
                    placement: PopoverPlacement.top,
                    child: Button('left-top'),
                    brightness: LeouiBrightness.dark,
                    content: 'hellow world',
                  ),
                  Popover(
                    placement: PopoverPlacement.top,
                    child: Button('center-top'),
                    brightness: LeouiBrightness.dark,
                    content: 'hellow world',
                  ),
                  Popover(
                    placement: PopoverPlacement.top,
                    child: Button('right-top'),
                    brightness: LeouiBrightness.dark,
                    content: 'hellow world',
                  ),
                ],
              ),
              Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('1,基本'),
                  ),
                  Row(
                    children: [
                      Popover(
                        placement: PopoverPlacement.top,
                        child: Button('hello word'),
                        content: 'hellow world',
                      ),
                      Popover(
                        placement: PopoverPlacement.right,
                        child: Button(
                          '黑暗模式',
                          color: Colors.black,
                        ),
                        brightness: LeouiBrightness.dark,
                        content: 'hellow world',
                      ),
                    ],
                  )
                ],
              ),
              Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('2,top'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Popover(
                        placement: PopoverPlacement.top,
                        child: Button('left-top'),
                        content: 'hellow world',
                      ),
                      Popover(
                        placement: PopoverPlacement.top,
                        child: Button('center-top'),
                        content: 'hellow world',
                      ),
                      Popover(
                        placement: PopoverPlacement.top,
                        child: Button('right-top'),
                        content: 'hellow world',
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 500,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('3,设定为Bottom'),
                    subtitle: Text('当bottom余量空间不足时，自动显示top'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Popover(
                        placement: PopoverPlacement.bottom,
                        child: Button(
                          'left-bottom',
                          size: ButtonSize.small,
                        ),
                        content: 'hellow world',
                      ),
                      Popover(
                        placement: PopoverPlacement.bottom,
                        child: Button(
                          'center-bottom',
                          size: ButtonSize.small,
                        ),
                        content: 'hellow world',
                      ),
                      Popover(
                        placement: PopoverPlacement.bottom,
                        child: Button(
                          'right-bottom',
                          size: ButtonSize.small,
                        ),
                        content: 'hellow world',
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
