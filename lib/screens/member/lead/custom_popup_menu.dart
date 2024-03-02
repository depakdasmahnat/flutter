import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../guest/guestProfile/guest_faq.dart';

class CustomPopUpMenu extends StatefulWidget {
  final bool? showText;
  String? priority;
  void Function(dynamic)? onSelected;
  final List<PopupMenuEntry<dynamic>> Function(BuildContext) itemBuilder;

  CustomPopUpMenu({super.key, this.onSelected, required this.itemBuilder, this.showText, this.priority});

  @override
  State<CustomPopUpMenu> createState() => _CustomPopUpMenuState();
}

class _CustomPopUpMenuState extends State<CustomPopUpMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: CupertinoColors.white,
      // color: const Color(0xFF1C1C1C),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
      onSelected: widget.onSelected,

      itemBuilder: widget.itemBuilder,
      child: widget.showText == true
          ? CustomeText(
              text: widget.priority,
            )
          : const Icon(Icons.more_vert),
    );
  }
}
