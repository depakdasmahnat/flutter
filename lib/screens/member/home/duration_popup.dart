import 'package:flutter/material.dart';
import 'package:mrwebbeast/utils/widgets/widgets.dart';

import '../../../core/constant/gradients.dart';

enum DurationFilterMenu {
  monthly('Monthly'),
  weekly('Weekly'),
  days('Days');

  const DurationFilterMenu(this.label);

  final String label;
}

class GraphDurationFilter extends StatefulWidget {
  const GraphDurationFilter({super.key, this.value, required this.onChange});

  final String? value;
  final Function(String?) onChange;

  @override
  State<GraphDurationFilter> createState() => _GraphDurationFilterState();
}

class _GraphDurationFilterState extends State<GraphDurationFilter> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: Colors.white,
      itemBuilder: (context) => List.generate(
        DurationFilterMenu.values.length,
        (index) {
          var menu = DurationFilterMenu.values.elementAt(index);
          var lastIndex = index == (DurationFilterMenu.values.length - 1);

          return PopupMenuItem(
            value: menu.name,
            height: 24,
            onTap: () {
              _onTap(menu);

              widget.onChange(menu.label);
            },
            padding: EdgeInsets.zero,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  menu.label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: inActiveGradient,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Text(
                widget.value ?? 'Monthly',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded, size: 18)
          ],
        ),
      ), // Adds margin around the menu content
    );
  }

  void _onTap(DurationFilterMenu selection) {
    String label = selection.label;
    switch (selection) {
      case DurationFilterMenu.days:
        break;
      case DurationFilterMenu.weekly:
        break;
      case DurationFilterMenu.monthly:
    }
  }
}
