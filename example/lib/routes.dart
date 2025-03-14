import 'package:flutter/material.dart';
import 'package:leoui_example/pages/button.dart';
import 'package:leoui_example/pages/colorPicker.dart';
import 'package:leoui_example/pages/dialog.dart';
import 'package:leoui_example/pages/drawingBoard.dart';
import 'package:leoui_example/pages/field.dart';
import 'package:leoui_example/pages/flipView.dart';
import 'package:leoui_example/pages/indexes.dart';
import 'package:leoui_example/pages/inputItem.dart';
import 'package:leoui_example/pages/loading.dart';
import 'package:leoui_example/pages/message.dart';
import 'package:leoui_example/pages/noticeBar.dart';
import 'package:leoui_example/pages/popover.dart';
import 'package:leoui_example/pages/prompt.dart';
import 'package:leoui_example/pages/scalable.dart';
import 'package:leoui_example/pages/scratcher.dart';
import 'package:leoui_example/pages/searchBar.dart';
import 'package:leoui_example/pages/selector.dart';
import 'package:leoui_example/pages/skeleton.dart';
import 'package:leoui_example/pages/modal.dart';
import 'package:leoui_example/pages/stickyContainer.dart';
import 'package:leoui_example/pages/tabPikcer.dart';
import 'package:leoui_example/pages/textEditor.dart';
import 'package:leoui_example/pages/toast.dart';
import 'package:leoui_example/pages/utils.dart';
import 'package:leoui_example/pages/home.dart';
import 'package:leoui_example/pages/swipeActions.dart';

Map<String, WidgetBuilder> routes = {
  'home': (BuildContext context) => MyHomePage(),
  'button': (BuildContext context) => ButtonPage(),
  'selector': (BuildContext context) => SelectorPage(),
  'message': (BuildContext context) => MessagePage(),
  'toast': (BuildContext context) => ToastPage(),
  'modal': (BuildContext context) => ModalPage(),
  'loading': (BuildContext context) => LoadingPage(),
  'dialog': (BuildContext context) => DialogPage(),
  'prompt': (BuildContext context) => PromptPage(),
  'popover': (BuildContext context) => PopoverPage(),
  'skeleton': (BuildContext context) => SkeletonPage(),
  'field': (BuildContext context) => FieldPage(),
  'noticeBar': (BuildContext context) => NoticeBarPage(),
  'inputItem': (BuildContext context) => InputItemPage(),
  'tabPicker': (BuildContext context) => TabPickerPage(),
  'scalableText': (BuildContext context) => ScalableTextPage(),
  'utils': (BuildContext context) => UtilsPage(),
  'searchBar': (BuildContext context) => SearchBarPage(),
  'indexes': (BuildContext context) => IndexesPage(),
  'drawingBoard': (BuildContext context) => DrawingBoardPage(),
  'colorPicker': (BuildContext context) => ColorPickerPage(),
  'swipeActions': (BuildContext context) => SwipeActionsPage(),
  'stickyContianer': (BuildContext context) => StickyContainerPage(),
  'textEditor': (BuildContext context) => TextEditorPage(),
  'scratcher': (BuildContext context) => ScratcherPage(),
  'flipView': (BuildContext context) => FlipViewPage(),
};
