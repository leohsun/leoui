part of leoui.feedback;

Future showLoading({
  String title = 'none',
  Duration? duration,
  bool cover = true,
  bool closable = true,
  BuildContext? context,
  LeouiBrightness brightness = LeouiBrightness.dark,
}) {
  if (LeoFeedback.loadingModal != null) {
    print('LEOUI:loading is active,plz hideloading before loading show');
    return Future.value();
  }

  bool showTitle = title != 'none';
  bool isDark = brightness == LeouiBrightness.dark;
  LeouiThemeData theme =
      LeouiTheme.of(LeoFeedback.currentContext!)!.theme(brightness: brightness);
  Modal? modal;
  Timer? counter;

  modal = Modal(
      noMask: !cover,
      animateWhenOpen: false,
      maskAlpha: 0,
      childBuilder: (context) => ClipRRect(
            borderRadius: BorderRadius.circular(theme.size!().cardBorderRadius),
            child: Container(
              width: theme.size!().title * 6,
              height: theme.size!().title * 6,
              child: Stack(
                children: <Widget>[
                  buildBlurWidget(
                      child: Container(
                    decoration: BoxDecoration(
                      color: theme.dialogBackgroundColor,
                      borderRadius:
                          BorderRadius.circular(theme.size!().cardBorderRadius),
                      //          boxShadow: LeouiTheme.of(LeoFeedback.currentContext!).boxShadow,
                    ),
                  )),
                  Positioned.fill(
                      child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: theme.size!().title / 2,
                        vertical: theme.size!().title / 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: theme.size!().title * 2,
                          height: theme.size!().title * 2,
                          child: CircularProgressIndicator(
                            color: isDark ? Colors.white : Colors.black,
                            strokeWidth: theme.size!().tertiary / 5,
                          ),
                        ),
                        SizedBox(
                          height: showTitle ? theme.size!().title : 0,
                        ),
                        showTitle
                            ? Text(
                                title,
                                style: TextStyle(
                                    fontSize: theme.size!().tertiary,
                                    color:
                                        isDark ? Colors.white : Colors.black),
                              )
                            : SizedBox.shrink()
                      ],
                    ),
                  )),
                  closable
                      ? Positioned(
                          top: theme.size!().cardBorderRadius / 3,
                          right: theme.size!().cardBorderRadius / 3,
                          child: buildButtonWidget(
                            borderRadius: BorderRadius.circular(
                                theme.size!().cardBorderRadius),
                            onTap: () {
                              modal?.close();
                              counter?.cancel();
                              LeoFeedback.loadingModal = null;
                            },
                            child: Icon(Icons.clear_rounded,
                                size: theme.size!().title,
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
  return showModal(modal: modal, context: context);
}

void hideLoading() {
  if (LeoFeedback.loadingModal == null) return;
  LeoFeedback.loadingModal?.close();
  LeoFeedback.loadingModal = null;
}

void noop() {}

Future showLeoDialog(
    {LeouiBrightness? brightness,
    BuildContext? context,
    String? title, //窗口标题
    String? content, //正文内容
    IconData? icon, //Icon组件图标名称
    DialogLayout layout = DialogLayout.column, //底部按钮组布局方式, row, column
    List<DialogButton>? buttons, //底部操作按钮组
    Curve? curve, // carve 动画进行方式
    Widget? slot, // 插槽内容
    bool closeOnClickMask = false, //点击遮罩关闭
    double? width}) {
  return showModal(
      context: context,
      modal: Modal(
          curve: curve,
          closeOnClickMask: closeOnClickMask,
          childBuilder: (ctx) => Dialog(
                title: title,
                content: content,
                slot: slot,
                icon: icon,
                brightness: brightness,
                layout: layout,
                width: width,
                buttons: buttons,
              )));
}

Future showModal({required Modal modal, BuildContext? context}) async {
  assert(LeoFeedback.currentContext != null || context != null,
      'buildContext must be provided,\n LeoFeedback.init(context) or provide a "context"');

  // LeoFeedback.modalOverlayEntrySet.add(modal);

  if (context != null && Navigator.maybeOf(context) != null) {
    Navigator.of(context).push(modal.route);
  } else {
    Overlay.of(LeoFeedback.currentContext!).insert(modal.entry);
  }
  // Navigator.of(LeoFeedback.currentContext!).push(modal.route);

  return modal.dissmissed;
}

Future showTabPicker(
    {required List<List> dataList,
    String? columnKey,
    String? childrenKey,
    String? selectHintText,
    LeouiBrightness? brightness,
    bool? linkage,
    double? selectorHeight}) {
  return showModal(
      modal: Modal(
          direction: ModalDirection.bottom,
          reverseAnimationWhenClose: true,
          closeOnClickMask: true,
          childBuilder: (ctx) => TabPicker(
                dataList: dataList,
                columnKey: columnKey,
                childrenKey: childrenKey,
                selectHintText: selectHintText,
                brightness: brightness,
                linkage: linkage,
                selectorHeight: selectorHeight,
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
    Color? confirmTextColor,
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
    childBuilder: (ctx) => Selector(
        dataList: dataList,
        count: count,
        title: title,
        linkage: linkage,
        cancleText: cancleText,
        cancleTextColor: cancleTextColor,
        confirmText: confirmText,
        confirmTextColor: confirmTextColor,
        columnKey: columnKey,
        brightness: brightness,
        selectorHeight: selectorHeight,
        hideHeader: hideHeader = false),
  ));
}

Future showMessage(String message,
    {MessageType type = MessageType.info,
    Duration duration = const Duration(seconds: 2),
    VoidCallback onPress = noop}) {
  IconData _icon;
  Color _bgColor;

  final String _msg = message;
  LeouiThemeData theme = LeouiTheme.of(LeoFeedback.currentContext!)!.theme();

  switch (type) {
    case MessageType.success:
      _icon = Icons.check_circle_outline;
      _bgColor = theme.baseGreenColor;
      break;
    case MessageType.error:
      _icon = Icons.error;
      _bgColor = theme.baseRedColor;
      HapticFeedback.lightImpact();
      break;
    case MessageType.warning:
      _icon = Icons.remove_circle;
      _bgColor = theme.baseOrangeColor;
      HapticFeedback.lightImpact();
      break;
    case MessageType.info:
      _icon = Icons.info_outline;
      _bgColor = theme.baseTealColor;
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
    childBuilder: (ctx) => Padding(
      padding:
          EdgeInsets.only(left: 8, right: 8, top: SizeTool.devicePadding.top),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(theme.size!().cardBorderRadius),
        child: buildButtonWidget(
          color: _bgColor,
          borderRadius: BorderRadius.circular(theme.size!().cardBorderRadius),
          onTap: onPress,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: theme.size!().title,
                vertical: theme.size!().title / 2),
            child: Container(
              constraints: BoxConstraints(minHeight: theme.size!().itemExtend),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: theme.size!().title / 2),
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
                          fontSize: theme.size!().title,
                          fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                      // softWrap: false,
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
    ToastType? type}) async {
  LeouiThemeData theme =
      LeouiTheme.of(LeoFeedback.currentContext!)!.theme(brightness: brightness);

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
        style: TextStyle(color: textColor, fontSize: theme.size!().secondary),
        textAlign: TextAlign.center,
        // overflow: TextOverflow.ellipsis,
      ),
    )
  ];

  if (type != null) {
    _children.insert(
      0,
      Padding(
        padding: EdgeInsets.only(right: theme.size!().secondary / 3),
        child: Icon(
          type == ToastType.success
              ? Icons.check_circle_outline
              : Icons.error_outline,
          color: textColor,
          size: theme.size!().secondary,
        ),
      ),
    );
  }

  if (LeoFeedback.toastModal != null) {
    await LeoFeedback.toastModal!.close();
  }

  Modal modal = Modal(
      autoClose: true,
      noMask: true,
      duration: duration,
      animateWhenOpen: LeoFeedback.toastModal == null,
      reverseAnimationWhenClose: true,
      onClose: (auto) {
        if (LeoFeedback.toastModal != null && auto) {
          LeoFeedback.toastModal = null;
        }
      },
      childBuilder: (ctx) => Container(
          constraints: BoxConstraints(
            minWidth: 100,
            maxWidth: SizeTool.deviceWidth - 40,
          ),
          decoration: BoxDecoration(
              color: bgColor,
              borderRadius:
                  BorderRadius.circular(theme.size!().cardBorderRadius),
              boxShadow: LeouiTheme.of(LeoFeedback.currentContext!)!
                  .theme()
                  .boxShadow),
          child: buildBlurWidget(
            borderRadius: BorderRadius.circular(theme.size!().cardBorderRadius),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: theme.size!().tertiary,
                  vertical: theme.size!().tertiary / 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: _children,
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
          )));

  LeoFeedback.toastModal = modal;
  return showModal(modal: modal);
}

Future showAlert(
    {LeouiBrightness? brightness, //主题
    String? title, //窗口标题
    required String content, //正文内容
    VoidCallback? onConfirm // 点击确定后回调函数
    }) {
  Modal? modal;

  LeouiThemeData theme =
      LeouiTheme.of(LeoFeedback.currentContext!)!.theme(brightness: brightness);

  modal = Modal(
      childBuilder: (ctx) => Dialog(
            title: title ??
                LeouiLocalization.of(LeoFeedback.currentContext!).warning,
            content: content,
            brightness: brightness,
            buttons: [
              DialogButton(
                  handler: (ctx) {
                    modal?.close();
                    if (onConfirm != null) onConfirm();
                  },
                  color: theme.userAccentColor,
                  bold: true,
                  text:
                      LeouiLocalization.of(LeoFeedback.currentContext!).confirm)
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

  LeouiThemeData theme =
      LeouiTheme.of(LeoFeedback.currentContext!)!.theme(brightness: brightness);
  List<DialogButton> buttons = [
    DialogButton(
        handler: (ctx) {
          modal?.close(false);
          if (onCancel != null) onCancel();
        },
        color: theme.labelPrimaryColor,
        text: cancelText ??
            LeouiLocalization.of(LeoFeedback.currentContext!).cancel),
    DialogButton(
        handler: (ctx) {
          modal?.close(true);
          if (onConfirm != null) onConfirm();
        },
        bold: true,
        color: theme.userAccentColor,
        text: confirmText ??
            LeouiLocalization.of(LeoFeedback.currentContext!).confirm)
  ];

  modal = Modal(
      childBuilder: (context) => Dialog(
            title: title ??
                LeouiLocalization.of(LeoFeedback.currentContext!).confirm,
            content: content,
            brightness: brightness,
            buttons: buttons,
          ));

  return showModal(modal: modal);
}

Future showPrompt(
    {LeouiBrightness? brightness, //主题
    String? title, //窗口标题
    String? content, //正文内容
    String? confirmText, // 确定按钮文本
    String? cancelText, // 取消按钮文本
    RegExp? validatePattern, //检验正则
    String? patternDescript,
    String? fieldKey, // 用于Field导出数据的key --> {'username':'kim'}
    String? fieldLabel, // 用于校验输入提示 -->'(用户名)不能为空'
    TextInputType? fieldInputType,
    String? fieldInputDefaultValue}) {
  assert(validatePattern == null || (fieldKey != null && fieldLabel != null),
      'when validatePattern is not null then fieldKey and fieldLable must be provided');
  Modal? modal;
  GlobalKey<InputItemState> inputKey = GlobalKey(debugLabel: 'promopt__input');

  LeouiThemeData theme =
      LeouiTheme.of(LeoFeedback.currentContext!)!.theme(brightness: brightness);

  List<DialogButton> buttons = [
    DialogButton(
        handler: (ctx) {
          modal?.close(null);
        },
        color: theme.labelPrimaryColor,
        text: cancelText ??
            LeouiLocalization.of(LeoFeedback.currentContext!).cancel),
    DialogButton(
        handler: (ctx) {
          String hintText = inputKey.currentState!.validate();
          if (hintText.isNotEmpty) {
            showToast(hintText, type: ToastType.warning);
          } else {
            Map? data = inputKey.currentState!.obtainData();
            modal?.close(data);
          }
        },
        bold: true,
        color:
            LeouiTheme.of(LeoFeedback.currentContext!)!.theme().userAccentColor,
        text: confirmText ??
            LeouiLocalization.of(LeoFeedback.currentContext!).confirm)
  ];

  modal = Modal(
      childBuilder: (context) => Dialog(
            title: title,
            content: content,
            brightness: brightness,
            promopt: true,
            buttons: buttons,
            promoptItemKey: inputKey,
            validatePattern: validatePattern,
            patternDescript: patternDescript,
            fieldKey: fieldKey,
            fieldLabel: fieldLabel,
            fieldInputType: fieldInputType,
            fieldInputDefaultValue: fieldInputDefaultValue,
          ));

  return showModal(modal: modal);
}

Future showActionSheet(
  List<ActionSheetAction> actions, {
  String? title,

  /// 支持多选
  bool? multi = false,
  LeouiBrightness? brightness,
  BuildContext? context,
  final String? cancelText,
  String? confirmText,
  Color? cancelTextColor,
  Color? confirmTextColor,
  double? height,
}) {
  Modal modal = Modal(
      direction: ModalDirection.bottom,
      reverseAnimationWhenClose: true,
      childBuilder: (ctx) => ActionSheet(
            actions: actions,
            title: title,
            brightness: brightness,
            multi: multi,
            height: height,
            cancelText: cancelText,
            cancelTextColor: cancelTextColor,
            confirmText: confirmText,
            confirmTextColor: confirmTextColor,
            onCancel: () {
              ModalScope.of(ctx)?.closeModal();
            },
          ));

  return showModal(modal: modal, context: context);
}
