import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaas/utils/widgets/custom_button.dart';
import 'package:gaas/utils/widgets/loading_screen.dart';
import 'package:gaas/utils/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:permission_handler/permission_handler.dart';

class CaptureImage extends StatefulWidget {
  const CaptureImage({super.key});

  @override
  _CaptureImageState createState() => _CaptureImageState();
}

class _CaptureImageState extends State<CaptureImage> with WidgetsBindingObserver {
  CameraController? controller;
  List<CameraDescription>? cameras;
  CameraDescription? camera;

  bool enableAudio = true;

  ResolutionPreset resolutionPreset = ResolutionPreset.medium;
  XFile? imageFile;

  // Initial values
  bool _isCameraInitialized = false;
  bool _isCameraPermissionGranted = false;
  bool _isRearCameraSelected = true;

  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;

  // Current values
  double _currentZoomLevel = 1.0;
  double _currentExposureOffset = 0.0;
  FlashMode? _currentFlashMode;

  final resolutionPresets = ResolutionPreset.values;

  ResolutionPreset currentResolutionPreset = ResolutionPreset.high;
  String? cameraError;

  getPermissionStatus({bool? initialMode}) async {
    await Permission.camera.request();
    var status = await Permission.camera.status;

    if (status.isGranted) {
      log('Camera Permission: GRANTED');
      setState(() {
        _isCameraPermissionGranted = true;
      });

      // Set and initialize the new camera
      switchCamera(initialMode: initialMode);
    } else {
      cameraError = "Camera Permission ${status.name}";
      openAppSettings();

      log('$cameraError');
    }
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;

    if (cameraController?.value.isTakingPicture == true) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      XFile? file = await cameraController?.takePicture();
      return file;
    } on CameraException catch (e) {
      debugPrint('Error occurred while taking picture: $e');
      return null;
    }
  }

  void resetCameraValues() async {
    _currentZoomLevel = 1.0;
    _currentExposureOffset = 0.0;
  }

  CameraLensDirection cameraLensDirection = CameraLensDirection.front;

  void switchCamera({bool? initialMode}) async {
    CameraLensDirection newLensDirection;

    if (initialMode == true) {
      newLensDirection = cameraLensDirection;
    } else {
      newLensDirection = cameraLensDirection == CameraLensDirection.front
          ? CameraLensDirection.back
          : CameraLensDirection.front;
    }

    cameras?.forEach((description) {
      if (description.lensDirection == newLensDirection) {
        camera = description;
        controller = CameraController(
          description,
          currentResolutionPreset,
          imageFormatGroup: ImageFormatGroup.jpeg,
        );
      }
    });

    setState(() {});
    resetCameraValues();

    controller?.addListener(() {
      if (mounted) setState(() {});
    });

    try {
      await controller?.initialize();
      await Future.wait([
        controller!.getMinExposureOffset().then((value) => _minAvailableExposureOffset = value),
        controller!.getMaxExposureOffset().then((value) => _maxAvailableExposureOffset = value),
        controller!.getMaxZoomLevel().then((value) => _maxAvailableZoom = value),
        controller!.getMinZoomLevel().then((value) => _minAvailableZoom = value),
      ]);

      _currentFlashMode = controller!.value.flashMode;
    } on CameraException catch (e) {
      debugPrint('Error initializing camera: $e');
    }

    if (mounted) {
      setState(() {
        _isCameraInitialized = controller!.value.isInitialized;
      });
    }
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }

    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    controller!.setExposurePoint(offset);
    controller!.setFocusPoint(offset);
  }

  @override
  void initState() {
    loadCameras();

    // Hide the status bar in Android
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    getPermissionStatus(initialMode: true);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  loadCameras() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      cameras = await availableCameras();
    } on CameraException catch (e) {
      debugPrint('Error in fetching the cameras permission: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      switchCamera();
      getPermissionStatus();
    }
  }

  @override
  void dispose() {
    controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              backButton(context: context),
            ],
          ),
          leadingWidth: 50,
          title: imageFile == null
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            _currentFlashMode = FlashMode.off;
                          });
                          await controller!.setFlashMode(
                            FlashMode.off,
                          );
                        },
                        child: Icon(
                          Icons.flash_off,
                          color: _currentFlashMode == FlashMode.off ? Colors.amber : Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            _currentFlashMode = FlashMode.auto;
                          });
                          await controller!.setFlashMode(
                            FlashMode.auto,
                          );
                        },
                        child: Icon(
                          Icons.flash_auto,
                          color: _currentFlashMode == FlashMode.auto ? Colors.amber : Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            _currentFlashMode = FlashMode.always;
                          });
                          await controller!.setFlashMode(
                            FlashMode.always,
                          );
                        },
                        child: Icon(
                          Icons.flash_on,
                          color: _currentFlashMode == FlashMode.always ? Colors.amber : Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            _currentFlashMode = FlashMode.torch;
                          });
                          await controller!.setFlashMode(
                            FlashMode.torch,
                          );
                        },
                        child: Icon(
                          Icons.highlight,
                          color: _currentFlashMode == FlashMode.torch ? Colors.amber : Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              : null,
        ),
        backgroundColor: Colors.black,
        body: _isCameraPermissionGranted
            ? _isCameraInitialized
                ? imageFile != null
                    ? Image.file(
                        File('${imageFile?.path}'),
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: AspectRatio(
                              aspectRatio: 2,
                              child: Stack(
                                children: [
                                  CameraPreview(
                                    controller!,
                                    child: LayoutBuilder(
                                        builder: (BuildContext context, BoxConstraints constraints) {
                                      return GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTapDown: (details) => onViewFinderTap(details, constraints),
                                      );
                                    }),
                                  ),
                                  // TODO: Uncomment to preview the overlay
                                  // Center(
                                  //   child: Image.asset(
                                  //     'assets/camera_aim.png',
                                  //     color: Colors.greenAccent,
                                  //     width: 150,
                                  //     height: 150,
                                  //   ),
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      16.0,
                                      8.0,
                                      16.0,
                                      8.0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        // Align(
                                        //   alignment: Alignment.topRight,
                                        //   child: Container(
                                        //     decoration: BoxDecoration(
                                        //       color: Colors.black87,
                                        //       borderRadius: BorderRadius.circular(10.0),
                                        //     ),
                                        //     child: Padding(
                                        //       padding: const EdgeInsets.only(
                                        //         left: 8.0,
                                        //         right: 8.0,
                                        //       ),
                                        //       child: DropdownButton<ResolutionPreset>(
                                        //         dropdownColor: Colors.black87,
                                        //         underline: Container(),
                                        //         value: currentResolutionPreset,
                                        //         items: [
                                        //           for (ResolutionPreset preset in resolutionPresets)
                                        //             DropdownMenuItem(
                                        //               value: preset,
                                        //               child: Text(
                                        //                 preset.toString().split('.')[1].toUpperCase(),
                                        //                 style: const TextStyle(color: Colors.white),
                                        //               ),
                                        //             )
                                        //         ],
                                        //         onChanged: (value) {
                                        //           setState(() {
                                        //             currentResolutionPreset = value!;
                                        //             _isCameraInitialized = false;
                                        //           });
                                        //           onNewCameraSelected(controller!.description);
                                        //         },
                                        //         hint: const Text("Select item"),
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                        // Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 8.0, top: 16.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                '${_currentExposureOffset.toStringAsFixed(1)}x',
                                                style: const TextStyle(color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: RotatedBox(
                                            quarterTurns: 3,
                                            child: SizedBox(
                                              height: 30,
                                              child: Slider(
                                                value: _currentExposureOffset,
                                                min: _minAvailableExposureOffset,
                                                max: _maxAvailableExposureOffset,
                                                activeColor: Colors.white,
                                                inactiveColor: Colors.white30,
                                                onChanged: (value) async {
                                                  setState(() {
                                                    _currentExposureOffset = value;
                                                  });
                                                  await controller!.setExposureOffset(value);
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: 8.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black87,
                                                  borderRadius: BorderRadius.circular(10.0),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '${_currentZoomLevel.toStringAsFixed(1)}x',
                                                    style: const TextStyle(color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Slider(
                                                value: _currentZoomLevel,
                                                min: _minAvailableZoom,
                                                max: _maxAvailableZoom,
                                                activeColor: Colors.white,
                                                inactiveColor: Colors.white30,
                                                onChanged: (value) async {
                                                  setState(() {
                                                    _currentZoomLevel = value;
                                                  });
                                                  await controller!.setZoomLevel(value);
                                                },
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _isCameraInitialized = false;
                                                });

                                                switchCamera();
                                                setState(() {
                                                  _isRearCameraSelected = !_isRearCameraSelected;
                                                });
                                              },
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.circle,
                                                    color: Colors.black38,
                                                    size: 60,
                                                  ),
                                                  Icon(
                                                    _isRearCameraSelected
                                                        ? Icons.camera_front
                                                        : Icons.camera_rear,
                                                    color: Colors.white,
                                                    size: 30,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    XFile? rawImage =
                                        await loadingDialog(context: context, future: takePicture());
                                    if (rawImage != null && context.mounted) {
                                      imageFile = rawImage;
                                      setState(() {});
                                      //
                                      // int currentUnix = DateTime.now().millisecondsSinceEpoch;
                                      //
                                      // final directory = await getApplicationDocumentsDirectory();
                                      //
                                      // String fileFormat = imageFile.path.split('.').last;
                                      //
                                      // debugPrint(fileFormat);
                                      //
                                      // await imageFile.copy('${directory.path}/image.$fileFormat');
                                    }
                                  },
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      const Icon(
                                        Icons.circle,
                                        color: Colors.white38,
                                        size: 80,
                                      ),
                                      const Icon(
                                        Icons.circle,
                                        color: Colors.white,
                                        size: 65,
                                      ),
                                      Container(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                : const LoadingScreen(
                    message: 'Loading Camera',
                  )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Row(),
                  Text(
                    cameraError ?? 'Permission Denied',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    onPressed: () {
                      getPermissionStatus();
                    },
                    text: 'Give permission',
                  ),
                ],
              ),
        bottomNavigationBar: (imageFile != null)
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        imageFile = null;
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.red.withOpacity(0.2), width: 5),
                          borderRadius: BorderRadius.circular(36),
                        ),
                        child: const Icon(
                          CupertinoIcons.multiply,
                          size: 36,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.pop(imageFile);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.green.withOpacity(0.2), width: 5),
                          borderRadius: BorderRadius.circular(36),
                        ),
                        child: const Icon(
                          CupertinoIcons.checkmark_alt,
                          size: 36,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : null,
      ),
    );
  }
}
