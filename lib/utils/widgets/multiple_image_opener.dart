import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gaas/utils/widgets/image_view.dart';

import '../../core/config/app_images.dart';

class MultipleImageOpener extends StatefulWidget {
  const MultipleImageOpener({Key? key, this.imageUrls, this.networkImages, this.files, this.initialIndex = 0})
      : super(key: key);

  final List<String?>? imageUrls;
  final List<String?>? networkImages;
  final List<File?>? files;
  final int? initialIndex;

  @override
  State<MultipleImageOpener> createState() => _MultipleImageOpenerState();
}

class _MultipleImageOpenerState extends State<MultipleImageOpener> {
  late List<String?>? assetImages;
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    assetImages = widget.imageUrls;
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
    if (widget.imageUrls != null) {
      return widget.imageUrls!.length;
    } else if (widget.networkImages != null) {
      return widget.networkImages!.length;
    } else if (widget.files != null) {
      return widget.files!.length;
    }
    return 1; // Default to one image (AppImages.noImage) if no images provided.
  }

  Widget _buildImageAtIndex(int index) {
    if (widget.networkImages != null && widget.networkImages!.isNotEmpty) {
      return ImageView(
        networkImage: widget.networkImages![index] ?? "",
        margin: EdgeInsets.zero,
      );
    } else if (assetImages != null && assetImages!.isNotEmpty) {
      return ImageView(
        assetImage: assetImages![index] ?? AppImages.noImage,
        margin: EdgeInsets.zero,
      );
    } else if (widget.files != null && widget.files!.isNotEmpty) {
      return ImageView(
        file: widget.files![index],
        margin: EdgeInsets.zero,
      );
    } else {
      return const ImageView(
        assetImage: AppImages.noImage,
        margin: EdgeInsets.zero,
      );
    }
  }
}
