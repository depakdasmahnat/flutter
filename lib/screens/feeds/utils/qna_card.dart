import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/core/constant/colors.dart';
import 'package:gaas/core/functions.dart';

class QNACard extends StatefulWidget {
  const QNACard({Key? key, required this.question, required this.answer, this.showAnswer}) : super(key: key);
  final String? question;

  final String? answer;
  final bool? showAnswer;

  @override
  State<QNACard> createState() => _QNACardState();
}

class _QNACardState extends State<QNACard> {
  late bool showAnswer = widget.showAnswer ?? false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: GestureDetector(
        onTap: () {
          setState(() {
            showAnswer = !showAnswer;
          });
        },
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Icon(
                      showAnswer ? CupertinoIcons.minus : Icons.add,
                      color: showAnswer ? Colors.grey : primaryColor,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                AutoSizeText(
                  minFontSize: 12,
                  maxFontSize: 14,
                  "${widget.question}",
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w600,

                  ),
                  textScaleFactor: TextScaleFactor.autoScale(context),
                )
              ],
            ),
            if (showAnswer == true)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: AutoSizeText(
                  "${widget.answer}",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                  textScaleFactor: TextScaleFactor.autoScale(context),
                ),
              )
          ],
        ),
      ),
    );
  }
}
