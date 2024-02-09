import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class RatingBarLine extends StatelessWidget {
  const RatingBarLine({
    super.key,
    required this.totalStars,
    required this.percentage,
  });

  final int totalStars;
  final double percentage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 18,
              width: 80,
              child: ListView.builder(
                itemCount: totalStars,
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return const Padding(
                    padding: EdgeInsets.only(right: 2),
                    child: Icon(Icons.star, color: Colors.amber, size: 14),
                  );
                },
              ),
            )
          ],
        ),
        Expanded(
          child: LinearPercentIndicator(
            lineHeight: 4,
            percent: percentage,
            barRadius: const Radius.circular(24),
            backgroundColor: Colors.grey.shade200,
            progressColor: Colors.amber,
          ),
        )
      ],
    );
  }
}
