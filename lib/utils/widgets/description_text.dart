import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DescriptionText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextStyle? buttonStyle;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;

  const DescriptionText({
    Key? key,
    required this.text,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.buttonStyle,
  }) : super(key: key);

  @override
  DescriptionTextState createState() => DescriptionTextState();
}

class DescriptionTextState extends State<DescriptionText> {
  bool _showFullText = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(text: widget.text, style: widget.style);
        final textPainter = TextPainter(
          text: textSpan,
          maxLines: widget.maxLines ?? 3,
          textDirection: widget.textDirection ?? TextDirection.ltr,
          textAlign: widget.textAlign ?? TextAlign.start,
          textScaleFactor: widget.textScaleFactor ?? 1.0,
          locale: widget.locale,
          strutStyle: widget.strutStyle,
          textWidthBasis: widget.textWidthBasis ?? TextWidthBasis.parent,
        );
        textPainter.layout(maxWidth: constraints.maxWidth);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              style: widget.style,
              strutStyle: widget.strutStyle,
              textAlign: widget.textAlign,
              textDirection: widget.textDirection,
              locale: widget.locale,
              softWrap: widget.softWrap ?? true,
              overflow: _showFullText ? null : widget.overflow ?? TextOverflow.ellipsis,
              textScaleFactor: widget.textScaleFactor,
              maxLines: _showFullText ? null : widget.maxLines,
              semanticsLabel: widget.semanticsLabel,
              textWidthBasis: widget.textWidthBasis,
            ),
            if (!_showFullText && textPainter.didExceedMaxLines)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => setState(() => _showFullText = true),
                    child: Text(
                      'Show more',
                      style: widget.buttonStyle ??
                          const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            if (_showFullText && textPainter.didExceedMaxLines)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => setState(() => _showFullText = false),
                    child: Text(
                      'Show less',
                      style: widget.buttonStyle ??
                          const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}
