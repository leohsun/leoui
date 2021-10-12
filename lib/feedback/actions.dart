part of leoui.feedback;

Future showLoading({
  String title = 'none',
  Duration? duration,
  bool cover = true,
  bool closable = true,
  LeouiBrightness brightness = LeouiBrightness.dark,
}) {
  if (LeoFeedback.loadingModal != null) {
    print('LEOUI:loading is active,plz hideloading before loading show');
    return Future.value();
  }

  bool showTitle = title != 'none';
  bool isDark = brightness == LeouiBrightness.dark;
  LeoThemeData theme = LeoThemeData(brightness: brightness);
  Modal? modal;
  Timer? counter;

  modal = Modal(
      child: ClipRRect(
    borderRadius: BorderRadius.circular(sz(LeoSize.cardBorderRadius)),
    child: Container(
      width: sz(100),
      height: sz(100),
      child: Stack(
        children: <Widget>[
          buildBlurWidget(
              child: Container(
            decoration: BoxDecoration(
              color: theme.dialogBackgroundColor,
              borderRadius: BorderRadius.circular(sz(LeoSize.cardBorderRadius)),
              //          boxShadow: LeoTheme.of(LeoFeedback.currentContext!).boxShadow,
            ),
          )),
          Positioned.fill(
              child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: sz(LeoSize.fontSize.title / 2),
                vertical: sz(LeoSize.fontSize.title / 3)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: sz(LeoSize.fontSize.title) * 2,
                  height: sz(LeoSize.fontSize.title) * 2,
                  child: CircularProgressIndicator(
                    color: isDark ? Colors.white : Colors.black,
                    strokeWidth: sz(LeoSize.fontSize.tertiary) / 5,
                  ),
                ),
                SizedBox(
                  height: showTitle ? sz(LeoSize.fontSize.title) : 0,
                ),
                showTitle
                    ? Text(
                        title,
                        style: TextStyle(
                            fontSize: sz(LeoSize.fontSize.tertiary),
                            color: isDark ? Colors.white : Colors.black),
                      )
                    : SizedBox.shrink()
              ],
            ),
          )),
          closable
              ? Positioned(
                  right: 0,
                  child: buildButtonWidget(
                    borderRadius:
                        BorderRadius.circular(sz(LeoSize.cardBorderRadius)),
                    onPress: () {
                      modal?.close();
                      counter?.cancel();
                      LeoFeedback.loadingModal = null;
                    },
                    child: Icon(Icons.clear_rounded,
                        color: theme.labelSecondaryColor),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    ),
  ));

  LeoFeedback.loadingModal = modal;
  if (duration != null) {
    counter = Timer(duration, hideLoading);
  }
  return showModal(modal: modal);
}

void hideLoading() {
  if (LeoFeedback.loadingModal == null) return;
  LeoFeedback.loadingModal?.close();
  LeoFeedback.loadingModal = null;
}

void noop() {}

Future showLeoDialog(
    {LeouiBrightness? brightness,
    String? title, //窗口标题
    required String content, //正文内容
    IconData? icon, //Icon组件图标名称
    dialogLayout layout = dialogLayout.column, //底部按钮组布局方式, row, column
    List<DialogButton>? buttons, //底部操作按钮组
    Curve? curve, // carve 动画进行方式
    Widget? slot, // 插槽内容
    bool closeOnClickMask = false //点击遮罩关闭
    }) {
  return showModal(
      modal: Modal(
          curve: curve,
          child: Dialog(
            title: title,
            content: content,
            slot: slot,
            icon: icon,
            brightness: brightness,
            layout: layout,
            buttons: buttons,
          )));
}

Future showModal({required Modal modal}) {
  assert(LeoFeedback.currentContext != null,
      'buildContext must be provided,\n LeoFeedback.init(context)');

  // LeoFeedback.modalOverlayEntrySet.add(modal);

  Overlay.of(LeoFeedback.currentContext!)?.insert(modal.entry);
  return modal.dissmissed;
}

Future showTabPicker(
    {required List<List> dataList,
    String? columnKey,
    String? childrenKey,
    LeouiBrightness? brightness,
    bool? linkage,
    double? selectorHeight}) {
  return showModal(
      modal: Modal(
          direction: ModalDirection.bottom,
          reverseAnimationWhenClose: true,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: TabPicker(
              dataList: dataList,
              columnKey: columnKey,
              childrenKey: childrenKey,
              brightness: brightness,
              linkage: linkage,
              selectorHeight: selectorHeight,
            ),
          )));
}

Future showSelector(
    {bool? linkage,
    required List<List> dataList,
    int? count,
    String? title,
    String? cancleText,
    String? confirmText,
    Color? cancleTextColor,
    Color? confirmTextTextColor,
    VoidCallback? onCancel,
    ValueChanged? onComfrim,
    String? columnKey,
    String? childrenKey,
    double? selectorHeight,
    LeouiBrightness? brightness,
    bool? hideHeader}) {
  assert(linkage != true || count != null,
      "when 'linkage' is ture then 'count' must be provided");
  return showModal(
      modal: Modal(
    reverseAnimationWhenClose: true,
    direction: ModalDirection.bottom,
    child: Align(
        alignment: Alignment.bottomCenter,
        child: Selector(
            dataList: dataList,
            count: count,
            title: title,
            cancleText: cancleText,
            cancleTextColor: cancleTextColor,
            confirmText: confirmText,
            confirmTextTextColor: confirmTextTextColor,
            columnKey: columnKey,
            brightness: brightness,
            selectorHeight: selectorHeight,
            hideHeader: hideHeader = false)),
  ));
}

Future showMessage(String message,
    {MessageType type = MessageType.info,
    Duration duration = const Duration(seconds: 2),
    VoidCallback onPress = noop}) {
  IconData _icon;
  Color _bgColor;

  final String _msg = message;

  switch (type) {
    case MessageType.success:
      _icon = Icons.check_circle_outline;
      _bgColor = LeoTheme.of(LeoFeedback.currentContext!).baseGreenColor;
      break;
    case MessageType.error:
      _icon = Icons.error;
      _bgColor = LeoTheme.of(LeoFeedback.currentContext!).baseRedColor;
      HapticFeedback.lightImpact();
      break;
    case MessageType.warning:
      _icon = Icons.remove_circle;
      _bgColor = LeoTheme.of(LeoFeedback.currentContext!).baseOrangeColor;
      HapticFeedback.lightImpact();
      break;
    case MessageType.info:
      _icon = Icons.info_outline;
      _bgColor = LeoTheme.of(LeoFeedback.currentContext!).baseTealColor;
      break;
  }
  return showModal(
      modal: Modal(
    direction: ModalDirection.top,
    reverseAnimationWhenClose: true,
    dragToClose: true,
    dragToCloseGap: 15,
    noMask: true,
    autoClose: true,
    duration: duration,
    child: Padding(
      padding:
          EdgeInsets.only(left: 8, right: 8, top: SizeTool.devicePadding.top),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(sz(LeoSize.cardBorderRadius)),
        child: buildButtonWidget(
          color: _bgColor,
          borderRadius: BorderRadius.circular(sz(LeoSize.cardBorderRadius)),
          onPress: onPress,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: sz(LeoSize.fontSize.title),
                vertical: sz(LeoSize.fontSize.title / 2)),
            child: Container(
              constraints: BoxConstraints(minHeight: sz(LeoSize.itemExtent)),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.only(right: sz(LeoSize.fontSize.title) / 2),
                    child: Icon(
                      _icon,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _msg,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: sz(LeoSize.fontSize.secondary),
                          fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
//                              softWrap: false,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  ));
}

Future showToast(String? msg,
    {Duration? duration,
    LeouiBrightness brightness = LeouiBrightness.dark,
    ToastType? type}) {
  LeoThemeData theme = LeoThemeData(brightness: brightness);

  bool isDark = brightness == LeouiBrightness.dark;

  Color textColor = isDark ? Colors.white : Colors.black;

  Color bgColor = theme.dialogBackgroundColor;

  if (type == ToastType.success) {
    bgColor = theme.baseGreenColor;
    textColor = Colors.white;
  } else if (type == ToastType.error) {
    bgColor = theme.baseRedColor;
    textColor = Colors.white;
  } else if (type == ToastType.warning) {
    bgColor = theme.baseOrangeColor;
    textColor = Colors.white;
  }

  String _msg = type == ToastType.success
      ? LeouiLocalization.of(LeoFeedback.currentContext!)
          .toastDefaultSuccessMessage
      : type == ToastType.error
          ? LeouiLocalization.of(LeoFeedback.currentContext!)
              .toastDefaultFailMessage
          : 'toast';

  List<Widget> _children = [
    Flexible(
      child: Text(
        msg ?? _msg,
        style: TextStyle(
            color: textColor, fontSize: sz(LeoSize.fontSize.secondary)),
        textAlign: TextAlign.center,
        // overflow: TextOverflow.ellipsis,
      ),
    )
  ];

  if (type != null) {
    _children.insert(
      0,
      Padding(
        padding: EdgeInsets.only(right: sz(LeoSize.fontSize.secondary / 3)),
        child: Icon(
          type == ToastType.success
              ? Icons.check_circle_outline
              : Icons.error_outline,
          color: textColor,
          size: sz(LeoSize.fontSize.secondary),
        ),
      ),
    );
  }

  return showModal(
      modal: Modal(
    autoClose: true,
    noMask: true,
    child: Container(
        constraints: BoxConstraints(
          minWidth: sz(100),
          maxWidth: SizeTool.deviceWidth - 40,
        ),
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(sz(LeoSize.cardBorderRadius)),
            boxShadow: LeoTheme.of(LeoFeedback.currentContext!).boxShadow),
        child: buildBlurWidget(
          borderRadius: BorderRadius.circular(sz(LeoSize.cardBorderRadius)),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: sz(LeoSize.fontSize.tertiary),
                vertical: sz(LeoSize.fontSize.tertiary / 2)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: _children,
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
        )),
  ));
}

Future showAlert(
    {LeouiBrightness? brightness, //主题
    String? title, //窗口标题
    required String content, //正文内容
    VoidCallback? onConfirm // 点击确定后回调函数
    }) {
  Modal? modal;
  modal = Modal(
      child: Dialog(
    title: title ?? LeouiLocalization.of(LeoFeedback.currentContext!).warning,
    content: content,
    brightness: brightness,
    buttons: [
      DialogButton(
          handler: (ctx) {
            modal?.close();
            if (onConfirm != null) onConfirm();
          },
          color: LeoThemeData(brightness: brightness).userAccentColor,
          bold: true,
          text: LeouiLocalization.of(LeoFeedback.currentContext!).confirm)
    ],
  ));

  return showModal(modal: modal);
}

Future showConfirm(
    {LeouiBrightness? brightness, //主题
    String? title, //窗口标题
    String content = '...', //正文内容
    String? confirmText, // 确定按钮文本
    String? cancelText, // 取消按钮文本
    VoidCallback? onConfirm, // 点击确定后回调函数
    VoidCallback? onCancel // 点击取消后回调函数
    }) {
  Modal? modal;

  List<DialogButton> buttons = [
    DialogButton(
        handler: (ctx) {
          modal?.close('cancel');
          if (onCancel != null) onCancel();
        },
        color: LeoThemeData(brightness: brightness).labelPrimaryColor,
        text: LeouiLocalization.of(LeoFeedback.currentContext!).cancel),
    DialogButton(
        handler: (ctx) {
          modal?.close('confirm');
          if (onConfirm != null) onConfirm();
        },
        bold: true,
        color: LeoThemeData(brightness: brightness).userAccentColor,
        text: LeouiLocalization.of(LeoFeedback.currentContext!).confirm)
  ];

  modal = Modal(
      child: Dialog(
    title: title ?? LeouiLocalization.of(LeoFeedback.currentContext!).confirm,
    content: content,
    brightness: brightness,
    buttons: buttons,
  ));

  return showModal(modal: modal);
}
