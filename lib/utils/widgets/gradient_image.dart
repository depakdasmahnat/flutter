import 'package:flutter/material.dart';

class GradientImage extends StatelessWidget {
  const GradientImage({
    Key? key,
    this.height,
    this.width,
    required this.imageUrl,
    this.gradient,
    this.gradient2,
  }) : super(key: key);
  final double? height;
  final double? width;
  final String imageUrl;
  final Gradient? gradient;
  final Gradient? gradient2;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image(
          fit: BoxFit.cover,
          image: AssetImage(imageUrl),
          height: height,
          width: width ?? MediaQuery.of(context).size.width,
        ),
        Container(
          height: height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: gradient ??
                LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    Colors.black,
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.1),
                  ],
                ),
          ),
        ),
        Container(
          height: height,
          width: width ?? MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: gradient2 ??
                LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [
                    Colors.black,
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.1),
                  ],
                ),
          ),
        ),
      ],
    );
  }
}
