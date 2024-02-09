import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gaas/utils/widgets/image_view.dart';

import '../../core/config/app_images.dart';

class ImageOpener extends StatefulWidget {
  const ImageOpener({Key? key, this.imageUrl, this.networkImage, this.file}) : super(key: key);
  final String? imageUrl;
  final String? networkImage;
  final File? file;

  @override
  State<ImageOpener> createState() => _ImageOpenerState();
}

class _ImageOpenerState extends State<ImageOpener> {
  late String? assetImage = widget.imageUrl;
  late String? networkImage = widget.networkImage;
  late File? file = widget.file;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: InteractiveViewer(
        scaleEnabled: true,
        panEnabled: true,
        minScale: 0.5,
        maxScale: 3.0,
        trackpadScrollCausesScale: true,
        child: networkImage != null
            ? ImageView(
                networkImage: "$networkImage",
                margin: EdgeInsets.zero,
              )
            : (assetImage != null)
                ? ImageView(
                    assetImage: assetImage,
                    margin: EdgeInsets.zero,
                  )
                : (file != null)
                    ? ImageView(
                        file: file,
                        margin: EdgeInsets.zero,
                      )
                    : const ImageView(
                        assetImage: AppImages.noImage,
                        margin: EdgeInsets.zero,
                      ),
      ),
    );
  }
}
