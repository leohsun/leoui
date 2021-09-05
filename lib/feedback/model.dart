part of leoui.feedback;

enum FeedbackBrightness { dark, light }
enum AlertType { normal, confirm }
enum SliderDirection { top, bottom, right, left, center }
enum MessageType { success, warning, info, error }
enum ToastType { success, error, warning }
typedef FutureCallBack = Future<void> Function();
