import 'package:flutter/material.dart';

import '../../core/constant/constant.dart';
import 'gradient_progress_bar.dart';

class TrainingProgress extends StatelessWidget {
  const TrainingProgress({super.key, required this.trainingProgress, this.title, this.onTap, this.margin});

  final double? trainingProgress;
  final String? title;
  final GestureTapCallback? onTap;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin ?? const EdgeInsets.only(top: kPadding, left: kPadding, right: kPadding),
        padding: const EdgeInsets.only(left: kPadding, right: kPadding, top: 8, bottom: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title ?? 'Basic Training Progress',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            GradientProgressBar(
              value: (trainingProgress ?? 0) > 0 ? ((trainingProgress ?? 0) / 100) : 0,
              backgroundColor: Colors.grey.shade300,
              margin: const EdgeInsets.only(top: 8, bottom: 8),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Steps 35/60',
                  style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500),
                ),
                const Text(
                  'Compete your training',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                  ),
                ),
                Text(
                  '${(trainingProgress ?? 0).toStringAsFixed(0)}%',
                  style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
