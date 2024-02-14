import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/constant/colors.dart';

class CustomPopupMenuEntry {
  final String? value;
  final String label;
  final IconData? icon;
  final Color? color;
  final Function()? onPressed;

  CustomPopupMenuEntry({
    this.value,
    required this.label,
    this.icon,
    this.color,
    required this.onPressed,
  });
}

class CustomPopupMenu extends StatefulWidget {
  const CustomPopupMenu({
    super.key,
    this.items,
    this.value,
    required this.onChange,
    required this.child,
  });

  final List<CustomPopupMenuEntry>? items;
  final String? value;
  final Function(String?) onChange;
  final Widget child;

  @override
  State<CustomPopupMenu> createState() => _CustomPopupMenuState();
}

class _CustomPopupMenuState extends State<CustomPopupMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: Colors.white,
      itemBuilder: (context) => List.generate(
        widget.items?.length ?? 0,
        (index) {
          var menuEntry = widget.items![index];
          bool isSelected = menuEntry.label == widget.value;

          return PopupMenuItem(
            value: menuEntry.label,
            height: 30,
            onTap: () {
              _onTap(menuEntry);
              widget.onChange(menuEntry.value ?? menuEntry.label);
            },
            padding: EdgeInsets.zero,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  menuEntry.label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? primaryColor : (menuEntry.color ?? Colors.black),
                    letterSpacing: 0.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      onSelected: (value) {
        // Handle selection
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      elevation: 5.0,
      // Adds additional shadow effect
      padding: EdgeInsets.zero,
      child: widget.child, // Adds margin around the menu content
    );
  }

  void _onTap(CustomPopupMenuEntry entry) {
    entry.onPressed?.call();
  }
}
