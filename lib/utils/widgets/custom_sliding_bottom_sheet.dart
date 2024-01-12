import 'dart:math';

import 'package:flutter/material.dart';

class CustomSlidingBottomSheet extends StatefulWidget {
  final double? minHeight;
  final double? maxHeight;
  final Widget? appBar;
  final Widget body;

  const CustomSlidingBottomSheet({
    Key? key,
    this.minHeight,
    this.maxHeight,
    this.appBar,
    required this.body,
  }) : super(key: key);

  @override
  CustomSlidingBottomSheetState createState() => CustomSlidingBottomSheetState();
}

class CustomSlidingBottomSheetState extends State<CustomSlidingBottomSheet> {
  double _currentHeight = 300;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  void _afterLayout(_) {
    setState(() {
      _currentHeight = context.size!.height;
      if (widget.minHeight != null) {
        _currentHeight = max(widget.minHeight!, _currentHeight);
      }
      if (widget.maxHeight != null) {
        _currentHeight = min(widget.maxHeight!, _currentHeight);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: _handleDragUpdate,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: _currentHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.appBar != null
                  ? Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: widget.appBar,
              )
                  : Container(
                height: 2,
                color: Colors.grey,
                margin: const EdgeInsets.symmetric(vertical: 4),
              ),
              Expanded(
                child: widget.body,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _currentHeight -= details.delta.dy;
      if (widget.minHeight != null) {
        _currentHeight = max(widget.minHeight!, _currentHeight);
      }
      if (widget.maxHeight != null) {
        _currentHeight = min(widget.maxHeight!, _currentHeight);
        // Check if user is scrolling down and the bottom sheet is at its maximum height
        if (details.delta.dy > 0 && _currentHeight == widget.maxHeight) {
          // Pop the bottom sheet
          Navigator.pop(context);
        }
      }
    });
  }
}
