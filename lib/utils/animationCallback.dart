import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

Future<void> animationCallback({
  required double start,
  required double end,
  required ValueChanged<double> callback,
  Curve curve = Curves.easeIn,
  Duration? duration = const Duration(seconds: 1),
}) async {
  int? scheduleId;
  double distance = end - start;

  Completer completer = Completer();
  Duration? tickStartTime;

  Duration calcDurantion = duration!;

  double current = start;

  late ValueChanged<Duration> tick;
  late ValueChanged<bool?> updateScheduler;
  late VoidCallback cancelScheduler;

  tick = (Duration passtime) {
    if (tickStartTime == null) {
      tickStartTime = passtime;
    }
    double factor = ((passtime - tickStartTime!).inMicroseconds /
            calcDurantion.inMicroseconds)
        .clamp(0, 1);

    current = start + distance * curve.transform(factor);

    callback.call(current);

    if (current != end) {
      updateScheduler(true);
    } else {
      cancelScheduler();
      completer.complete();
    }
  };

  updateScheduler = (bool? rescheduling) {
    scheduleId = SchedulerBinding.instance
        .scheduleFrameCallback(tick, rescheduling: rescheduling ?? false);
  };

  cancelScheduler = () {
    if (scheduleId == null) return;
    SchedulerBinding.instance.cancelFrameCallbackWithId(scheduleId!);
  };

  updateScheduler(false);

  return completer.future;
}
