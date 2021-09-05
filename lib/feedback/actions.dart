part of leoui.feedback;

void showToast(String? msg,
    {Duration? duration,
    LeouiBrightness brightness = LeouiBrightness.dark,
    ToastType? type}) {
  final GlobalKey<_FadeZoomBoxState> _fadeZoomBox =
      GlobalKey(debugLabel: 'toast key');

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
      ? '操作成功'
      : type == ToastType.error
          ? '操作失败'
          : 'toast';

  List<Widget> _children = [
    Flexible(
      child: Text(
        msg ?? _msg,
        style: TextStyle(
            color: textColor, fontSize: sz(LeoSize.fontSize.secondary)),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
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

  Widget toastWidget = FadeZoomBox(
    key: _fadeZoomBox,
    child: Container(
        constraints: BoxConstraints(
          minWidth: sz(100),
          maxWidth: SizeTool.deviceWidth - 40,
        ),
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(sz(LeoSize.cardBorderRadius)),
            boxShadow: LeoTheme.of(Feedback.currentContext!).boxShadow),
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
  );

  OverlayEntry _overlayEntry = Feedback.show(toastWidget, cover: false);

  Duration _duration = duration ?? Duration(seconds: 3);

  Future.delayed(_duration, () async {
    // await _fadeZoomBox.currentState!.reverseAnimation();
    Feedback.dismiss(_overlayEntry);
  });
}

void showLoading({
  String title = 'none',
  Duration? duration,
  bool cover = true,
  LeouiBrightness brightness = LeouiBrightness.dark,
}) {
  if (Feedback.uniqueGlobalStateKey == Feedback.loadingGlobalKey) return;
  Feedback.uniqueGlobalStateKey = Feedback.loadingGlobalKey;
  bool showTitle = title != 'none';

  bool isDark = brightness == LeouiBrightness.dark;
  LeoThemeData theme = LeoThemeData(brightness: brightness);

  Widget loadingWidget = FadeZoomBox(
    key: Feedback.uniqueGlobalStateKey,
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
//          boxShadow: LeoTheme.of(Feedback.currentContext!).boxShadow,
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
                    : SizedBox()
              ],
            ),
          ))
        ],
      ),
    ),
  );
  Feedback.show(loadingWidget, unique: true, cover: cover);

  if (duration != null) {
    Future.delayed(duration).then((value) => hideLoading());
  }
}

void hideLoading() async {
  if (Feedback.uniqueGlobalStateKey != Feedback.loadingGlobalKey) return;
  //  do it after loading widget was created;
  if (!Feedback.loadingWidgetCreated) {
    Feedback.shouldCallAfterFadeZoomBoxWidgetCreatedFunctions.add(() async {
      bool isLoadingOpened =
          Feedback.uniqueGlobalStateKey == Feedback.loadingGlobalKey;
      if (!isLoadingOpened) return;
      // await (Feedback.uniqueGlobalStateKey?.currentState as _FadeZoomBoxState)
      //     .reverseAnimation();

      Feedback.dismissUnique();
    });
  } else {
    // await (Feedback.uniqueGlobalStateKey?.currentState as _FadeZoomBoxState)
    //     .reverseAnimation();

    Feedback.dismissUnique();
  }
}

void noop() {}

void showMessage(String message,
    {MessageType type = MessageType.info,
    Duration duration = const Duration(seconds: 3),
    VoidCallback onPress = noop}) {
  GlobalKey<_SliderState> _slider = GlobalKey<_SliderState>();
  IconData _icon;
  Color _bgColor;
  final String _msg = message;
  switch (type) {
    case MessageType.success:
      _icon = Icons.check_circle_outline;
      _bgColor = LeoTheme.of(Feedback.currentContext!).baseGreenColor;
      break;
    case MessageType.error:
      _icon = Icons.highlight_off;
      _bgColor = LeoTheme.of(Feedback.currentContext!).baseRedColor;
      HapticFeedback.lightImpact();
      break;
    case MessageType.warning:
      _icon = Icons.remove_circle;
      _bgColor = LeoTheme.of(Feedback.currentContext!).baseOrangeColor;
      HapticFeedback.lightImpact();
      break;
    case MessageType.info:
      _icon = Icons.info_outline;
      _bgColor = LeoTheme.of(Feedback.currentContext!).baseTealColor;
      break;
  }
  Widget messageWidget = Slider(
    key: _slider,
    noMask: true,
    direction: SliderDirection.top,
    child: Padding(
      padding:
          EdgeInsets.only(left: 8, right: 8, top: SizeTool.devicePadding.top),
      child: Stack(
        children: <Widget>[
          buildBlurWidget(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(sz(LeoSize.cardBorderRadius)),
              child: buildButtonWidget(
                color: _bgColor,
                borderRadius:
                    BorderRadius.circular(sz(LeoSize.cardBorderRadius)),
                onPress: onPress,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: sz(LeoSize.fontSize.title),
                      vertical: sz(sz(LeoSize.fontSize.title) / 2)),
                  child: Container(
                    constraints:
                        BoxConstraints(minHeight: sz(LeoSize.itemExtent)),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              right: sz(LeoSize.fontSize.title) / 2),
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
        ],
      ),
    ),
  );

  OverlayEntry messageOverlayEntry = Feedback.show(messageWidget, cover: false);

  Future.delayed(duration, () async {
    await _slider.currentState?.reverseAnimation();
    Feedback.dismiss(messageOverlayEntry);
  });
}

void showSlider(
    {required Widget child,
    Duration? duration,
    required SliderDirection direction,
    bool? closeOnClickMask,
    bool? autoClose}) async {
  assert(autoClose != true || closeOnClickMask != true,
      'cannot provide both \'autoClose\' and \'closeOnClickMask\' are true value');
  GlobalKey<_SliderState> _sliderKey = GlobalKey<_SliderState>();

  bool _autoClose = autoClose ?? false;
  bool _closeOnClickMask = closeOnClickMask ?? false;

  Duration _duration = duration ?? Duration(milliseconds: 3000);

  Widget _slider = Slider(
    key: _sliderKey,
    child: child,
    closeOnClickMask: _closeOnClickMask,
    direction: direction,
  );

  OverlayEntry sliderEntry;

  if (_autoClose) {
    sliderEntry = Feedback.show(_slider);
    Future.delayed(_duration, () async {
      await _sliderKey.currentState!.reverseAnimation();
      Feedback.dismiss(sliderEntry);
    });
  } else {
    Feedback.sliderKeysSet.add(_sliderKey);
    sliderEntry = Feedback.show(_slider, isSlider: true);
  }
}

void hideSlider() async {
  bool isSliderOpened = Feedback.sliderKeysSet.length > 0 &&
      Feedback.sliderKeysSet.last.runtimeType != Null;
  if (!isSliderOpened) {
    Feedback.shouldCallAfterSliderWidgetCreatedFunctions.add(() async {
      await (Feedback.sliderKeysSet.last.currentState as _SliderState)
          .reverseAnimation();
      Feedback.sliderOverlayEntrySet.last.remove();
      Feedback.sliderOverlayEntrySet
          .remove(Feedback.sliderOverlayEntrySet.last);
      Feedback.sliderKeysSet.remove(Feedback.sliderKeysSet.last);
    });
  } else {
    await (Feedback.sliderKeysSet.last.currentState as _SliderState)
        .reverseAnimation();
    Feedback.sliderOverlayEntrySet.last.remove();
    Feedback.sliderOverlayEntrySet.remove(Feedback.sliderOverlayEntrySet.last);
    Feedback.sliderKeysSet.remove(Feedback.sliderKeysSet.last);
  }
}

void hideSliderAll() {
  bool isSliderOpened = Feedback.sliderKeysSet.length > 0;
  if (!isSliderOpened) return;
  Feedback.sliderOverlayEntrySet.forEach((OverlayEntry slider) {
    slider.remove();
  });
  Feedback.sliderOverlayEntrySet.clear();
  Feedback.sliderKeysSet.clear();
}

void showSelector(
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

  void _onCancel() {
    hideSlider();
  }

  void _onComfrim(data) {
    hideSlider();
    if (onComfrim != null) {
      onComfrim(data);
    }
  }

  Widget selector = Selector(
      dataList: dataList,
      count: count,
      title: title,
      cancleText: cancleText,
      cancleTextColor: cancleTextColor,
      confirmText: confirmText,
      confirmTextTextColor: confirmTextTextColor,
      onCancel: _onCancel,
      onComfrim: _onComfrim,
      columnKey: columnKey,
      brightness: brightness,
      selectorHeight: selectorHeight,
      hideHeader: hideHeader = false);

  Widget child = Align(
    alignment: Alignment.bottomCenter,
    child: selector,
  );

  showSlider(
    child: child,
    closeOnClickMask: true,
    direction: SliderDirection.bottom,
  );
}

void showLeoDialog(
    //IMPORTANT: 关闭请调用 hideSlider()
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
  showSlider(
      closeOnClickMask: closeOnClickMask,
      child: Dialog(
        title: title,
        content: content,
        slot: slot,
        icon: icon,
        brightness: brightness,
        layout: layout,
        buttons: buttons,
      ),
      direction: SliderDirection.center);
}

void showAlert(
    {LeouiBrightness? brightness, //主题
    String title = '警告', //窗口标题
    required String content, //正文内容
    VoidCallback? onConfirm // 点击确定后回调函数
    }) {
  List<DialogButton> buttons = [
    DialogButton(
        handler: () {
          hideSlider();
          if (onConfirm != null) onConfirm();
        },
        color: LeoThemeData(brightness: brightness).userAccentColor,
        bold: true,
        text: '确定')
  ];

  showSlider(
      child: Dialog(
        title: title,
        content: content,
        brightness: brightness,
        buttons: buttons,
      ),
      direction: SliderDirection.center,
      closeOnClickMask: true);
}

void showConfirm(
    {LeouiBrightness? brightness, //主题
    String title = '确认', //窗口标题
    String content = '请确认是否进行操作', //正文内容
    String confirmText = '确定', // 确定按钮文本
    String cancelText = '取消', // 取消按钮文本
    VoidCallback? onConfirm, // 点击确定后回调函数
    VoidCallback? onCancel // 点击取消后回调函数
    }) {
  List<DialogButton> buttons = [
    DialogButton(
        handler: () {
          hideSlider();

          if (onCancel != null) onCancel();
        },
        color: LeoThemeData(brightness: brightness).labelPrimaryColor,
        text: '取消'),
    DialogButton(
        handler: () {
          hideSlider();
          if (onConfirm != null) onConfirm();
        },
        bold: true,
        color: LeoThemeData(brightness: brightness).userAccentColor,
        text: '确定')
  ];

  showSlider(
      child: Dialog(
        title: title,
        content: content,
        brightness: brightness,
        buttons: buttons,
      ),
      direction: SliderDirection.center,
      closeOnClickMask: true);
}
