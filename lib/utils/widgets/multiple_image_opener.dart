import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/config/app_assets.dart';
import 'image_view.dart';

class MultipleImageOpener extends StatefulWidget {
  const MultipleImageOpener(
      {Key? key, this.assetImages, this.networkImages, this.files, this.initialIndex = 0, this.isAvatar})
      : super(key: key);

  final List<String?>? assetImages;
  final List<String?>? networkImages;
  final List<File?>? files;
  final int? initialIndex;
  final bool? isAvatar;

  @override
  State<MultipleImageOpener> createState() => _MultipleImageOpenerState();
}

class _MultipleImageOpenerState extends State<MultipleImageOpener> {
  late bool? isAvatar = widget.isAvatar;
  late List<String?>? assetImages;
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    assetImages = widget.assetImages;
    _currentPage = widget.initialIndex ?? 0;
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: _getImageCount(),
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          return InteractiveViewer(
            child: _buildImageAtIndex(index),
          );
        },
      ),
    );
  }

  int _getImageCount() {
    if (widget.assetImages != null) {
      return widget.assetImages!.length;
    } else if (widget.networkImages != null) {
      return widget.networkImages!.length;
    } else if (widget.files != null) {
      return widget.files!.length;
    }
    return 1; // Default to one image (AppImages.noImage) if no images provided.
  }

  Widget _buildImageAtIndex(int index) {
    if (widget.networkImages != null && widget.networkImages?.isNotEmpty == true) {
      return ImageView(
        networkImage: widget.networkImages![index] ?? '',
        margin: EdgeInsets.zero,
        isAvatar: isAvatar,
      );
    } else if (assetImages != null && assetImages?.isNotEmpty == true) {
      return ImageView(
        assetImage: assetImages![index] ?? AppAssets.noImage,
        isAvatar: isAvatar,
        margin: EdgeInsets.zero,
      );
    } else if (widget.files != null && widget.files?.isNotEmpty == true) {
      return ImageView(
        file: widget.files![index],
        isAvatar: isAvatar,
        margin: EdgeInsets.zero,
      );
    } else {
      return const ImageView(
        assetImage: AppAssets.noImage,
        margin: EdgeInsets.zero,
      );
    }
  }
}
