import 'dart:io';

import 'package:flutter/material.dart';

import 'image_view.dart';

class ImageOpener extends StatefulWidget {
  const ImageOpener({Key? key, this.assetImage, this.networkImage, this.file, this.isAvatar})
      : super(key: key);
  final String? assetImage;
  final String? networkImage;
  final File? file;
  final bool? isAvatar;

  @override
  State<ImageOpener> createState() => _ImageOpenerState();
}

class _ImageOpenerState extends State<ImageOpener> {
  late String? assetImage = widget.assetImage;
  late String? networkImage = widget.networkImage;
  late File? file = widget.file;
  late bool? isAvatar = widget.isAvatar;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
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
                networkImage: networkImage,
                margin: EdgeInsets.zero,
                isAvatar: isAvatar,
              )
            : (assetImage != null)
                ? ImageView(
                    assetImage: assetImage,
                    margin: EdgeInsets.zero,
                    isAvatar: isAvatar,
                  )
                : (file != null)
                    ? ImageView(
                        file: file,
                        isAvatar: isAvatar,
                        margin: EdgeInsets.zero,
                      )
                    : ImageView(
                        networkImage: networkImage,
                        isAvatar: isAvatar,
                        margin: EdgeInsets.zero,
                      ),
      ),
    );
  }
}
