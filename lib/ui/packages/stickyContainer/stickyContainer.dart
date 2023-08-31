import 'package:flutter/material.dart';

class StickyContainer extends StatefulWidget {
  final Widget child;
  final ScrollController scrollController;

  const StickyContainer(
      {super.key, required this.child, required this.scrollController});

  @override
  State<StickyContainer> createState() => _StickyContainerState();
}

class _StickyContainerState extends State<StickyContainer> {
  GlobalKey childKey = GlobalKey();

  double scrollParentDy = 0;
  double childDy = 0;

  void scrollHandler() {
    double offset = widget.scrollController.offset;

    print(offset);

    if (offset > scrollParentDy) {
      OverlayEntry overlayEntry = OverlayEntry(
        builder: (context) => Column(children: [
          Container(
            height: 115,
            color: Colors.green,
          )
        ]),
      );

      Overlay.of(context).insert(overlayEntry);
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      double max = widget.scrollController.position.maxScrollExtent;
      print('max: $max');
      RenderBox childRenderBox =
          childKey.currentContext?.findRenderObject() as RenderBox;
      Offset childOffset = childRenderBox.localToGlobal(Offset.zero);
      childDy = childOffset.dy;
      print('offset: $childDy');

      ScrollableState? parentScrollableState =
          childKey.currentContext?.findAncestorStateOfType<ScrollableState>();
      RenderBox? scrollParentRenderBox =
          parentScrollableState?.context.findRenderObject() as RenderBox?;
      Offset? scrollableParentOffset =
          scrollParentRenderBox?.localToGlobal(Offset.zero);
      scrollParentDy = scrollableParentOffset?.dy ?? 0;

      print('scrollParentDy: $scrollParentDy');
    });
    widget.scrollController.addListener(scrollHandler);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: childKey, child: widget.child);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(scrollHandler);
    super.dispose();
  }
}
