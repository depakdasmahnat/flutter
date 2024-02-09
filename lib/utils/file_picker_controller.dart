import 'dart:io';

import 'package:carousel_slider/carousel_options.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../core/config/app_config.dart';
import '../core/constant/colors.dart';
import '../route/route_paths.dart';
import 'widgets/widgets.dart';

List<CropAspectRatioPreset>? thumbnailAspectRatioPresets = [
  CropAspectRatioPreset.ratio16x9,
];

List<CropAspectRatioPreset> profilePictureAspectRatioPresets = [
  CropAspectRatioPreset.square,
];

CarouselOptions coverPictureCarouselOptions({required Size size}) {
  return CarouselOptions(
    height: size.height * 0.35,
    aspectRatio: 16 / 9,
    viewportFraction: 1,
    initialPage: 0,
    enableInfiniteScroll: false,
    reverse: false,
    autoPlay: true,
    autoPlayInterval: const Duration(seconds: 3),
    autoPlayAnimationDuration: const Duration(milliseconds: 800),
    autoPlayCurve: Curves.fastOutSlowIn,
    enlargeCenterPage: false,
    enlargeFactor: 0.3,
    scrollDirection: Axis.horizontal,
  );
}

class FilePickerController {
  Future<File?> selectCroppedImage({
    required ImageSource source,
    required BuildContext context,
    required CropStyle? cropStyle,
    required List<CropAspectRatioPreset>? aspectRatioPresets,
  }) async {
    XFile? pickedImg;
    if (source == ImageSource.camera) {
      pickedImg = await context.pushNamed(Routs.captureImage);
    } else {
      pickedImg = await ImagePicker().pickImage(source: source);
    }
    File? file;

    if (pickedImg != null) {
      await cropImage(
        context: context,
        image: File(pickedImg.path),
        aspectRatioPresets: aspectRatioPresets,
        cropStyle: cropStyle,
      ).then((value) {
        if (value != null) {
          file = File(value.path);
        }
      });
    }
    return file;
  }

  Future<List<File?>?> selectMultipleCroppedImage({
    required ImageSource source,
    required List<CropAspectRatioPreset>? aspectRatioPresets,
    int? limit,
    required BuildContext context,
    required CropStyle? cropStyle,
  }) async {
    List<XFile> pickedImg = await ImagePicker().pickMultiImage();
    List<File?>? files;

    if (pickedImg.isNotEmpty) {
      // int toLength = pickedImg.length > limit ? limit : pickedImg.length;
      // List<XFile> limitedList = pickedImg.getRange(0, toLength).toList();
      // for (var image in limitedList) {
      for (var image in pickedImg) {
        await cropImage(
          context: context,
          image: File(image.path),
          aspectRatioPresets: aspectRatioPresets,
          cropStyle: cropStyle,
        ).then((value) {
          if (value != null) {
            File? newFile = File(value.path);
            if (files == null) {
              files = [newFile];
            } else {
              files?.add(newFile);
            }
          }
        });
      }

      // debugPrint("Images.length  ${limitedList.length} limit$limit");
      //
      // if (limitedList.length > limit) {
      //   showSnackBar(context: context, text: "due to limit selected only first $limit Cover Images", color: Colors.red);
      // }
    }
    return files;
  }

  Future<File?> selectImage({required ImageSource source}) async {
    final pickedImg = await ImagePicker().pickImage(source: source);

    File? file;

    if (pickedImg != null) {
      file = File(pickedImg.path);
    }

    return file;
  }

  Future<File?> cropImage({
    required BuildContext context,
    required List<CropAspectRatioPreset>? aspectRatioPresets,
    required File? image,
    required CropStyle? cropStyle,
  }) async {
    File? file;
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image!.path,
      cropStyle: cropStyle ?? CropStyle.rectangle,
      aspectRatioPresets: aspectRatioPresets ??
          [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: AppConfig.apkName,
            toolbarColor: primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: AppConfig.apkName,
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );

    if (croppedFile != null) {
      file = File(croppedFile.path);
    }
    return file;
  }

  Future<List<File?>?> pickMultipleImage({
    required BuildContext context,
    required String title,
    int? limit,
    bool? coverPhoto,
    CropStyle? cropStyle,
  }) async {
    List<File?>? files;

    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          color: const Color(0xff757575),
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(18),
                  topLeft: Radius.circular(18),
                )),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 12),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () async {
                        await selectCroppedImage(
                          source: ImageSource.camera,
                          context: context,
                          aspectRatioPresets: thumbnailAspectRatioPresets,
                          cropStyle: cropStyle,
                        ).then((value) {
                          files = [value];
                          if (value != null) {
                            Navigator.pop(context);
                          }
                        });
                      },
                      child: pickImageButton(
                        text: "Camera",
                        icon: Icons.camera,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await selectMultipleCroppedImage(
                                source: ImageSource.gallery,
                                context: context,
                                limit: limit,
                                cropStyle: cropStyle,
                                aspectRatioPresets: thumbnailAspectRatioPresets)
                            .then((value) {
                          files = value;

                          if (value != null) {
                            Navigator.pop(context);
                          }
                        });
                      },
                      child: pickImageButton(
                        text: "Gallery",
                        icon: Icons.photo,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) {
      return files;
    });
  }

  Future<File?> pickImage({
    required BuildContext context,
    required String title,
    bool? coverPhoto,
    CropStyle? cropStyle,
    required List<CropAspectRatioPreset> aspectRatioPresets,
  }) async {
    File? file;
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          color: const Color(0xff757575),
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(18),
                  topLeft: Radius.circular(18),
                )),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 12),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () async {
                        await selectCroppedImage(
                          source: ImageSource.camera,
                          context: context,
                          cropStyle: cropStyle,
                          aspectRatioPresets: aspectRatioPresets,
                        ).then((value) {
                          file = value;
                          if (value != null) {
                            Navigator.pop(context);
                          }
                        });
                      },
                      child: pickImageButton(
                        text: "Camera",
                        icon: Icons.camera,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await selectCroppedImage(
                          source: ImageSource.gallery,
                          context: context,
                          aspectRatioPresets: aspectRatioPresets,
                          cropStyle: cropStyle,
                        ).then((value) {
                          file = value;

                          if (value != null) {
                            Navigator.pop(context);
                          }
                        });
                      },
                      child: pickImageButton(
                        text: "Gallery",
                        icon: Icons.photo,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) {
      return file;
    });
  }

  Future<File?> pickCroppedImage({
    required BuildContext context,
    required String title,
  }) async {
    File? file;
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          color: const Color(0xff757575),
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(18),
                  topLeft: Radius.circular(18),
                )),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 12),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () async {
                        await selectImage(source: ImageSource.camera).then((value) {
                          file = value;
                          if (value != null) {
                            Navigator.pop(context);
                          }
                        });
                      },
                      child: pickImageButton(
                        text: "Camera",
                        icon: Icons.camera,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await selectImage(source: ImageSource.gallery).then((value) {
                          file = value;

                          if (value != null) {
                            Navigator.pop(context);
                          }
                        });
                      },
                      child: pickImageButton(
                        text: "Gallery",
                        icon: Icons.photo,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) {
      return file;
    });
  }

  pickImageButton({required String text, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 4, 16),
      child: Container(
        height: 45,
        constraints: const BoxConstraints(
          minWidth: 150.0,
        ),
        decoration: BoxDecoration(
          color: primaryColor,
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
