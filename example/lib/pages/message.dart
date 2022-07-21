import 'package:flutter/material.dart';
import 'package:leoui/leoui.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios_new_rounded)),
          title: Text('Message-消息'),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Column(
                  children: [
                    Button(
                      'success',
                      color: LeoColors.success,
                      full: true,
                      onTap: () {
                        showMessage(
                            '最多三行文字:外交部副部长马朝旭指出，中方对全球溯源问题的立场是一贯的、明确的。第一，新冠病毒溯源是科学问题。',
                            type: MessageType.success);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Button(
                      'info',
                      full: true,
                      color: LeoColors.primary,
                      onTap: () {
                        showMessage('info');
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Button(
                      'warning',
                      full: true,
                      color: LeoColors.warn,
                      onTap: () {
                        showMessage('warning', type: MessageType.warning);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Button(
                      'error',
                      full: true,
                      color: LeoColors.danger,
                      onTap: () {
                        showMessage('error', type: MessageType.error);
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
