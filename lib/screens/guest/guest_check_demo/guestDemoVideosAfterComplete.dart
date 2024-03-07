import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mrwebbeast/screens/guest/guestProfile/guest_faq.dart';
import 'package:mrwebbeast/utils/widgets/custom_back_button.dart';
import 'package:mrwebbeast/utils/widgets/loading_screen.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../controllers/check_demo_controller/check_demo_controller.dart';
import '../../member/feeds/video_player.dart';
import '../../member/feeds/youtube_video_player.dart';

class GuestCheckDemoVideos extends StatefulWidget {
  const GuestCheckDemoVideos({super.key});

  @override
  State<GuestCheckDemoVideos> createState() => _GuestCheckDemoVideosState();
}

class _GuestCheckDemoVideosState extends State<GuestCheckDemoVideos> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<CheckDemoController>().fetchDemoVideos(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Consumer<CheckDemoController>(
        builder: (context, controller, child) {
          return controller.demoVideosLoader == false
              ? const LoadingScreen()
              : Stack(
                  fit: StackFit.expand,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: PageView.builder(
                            itemCount: controller.fetchDemoVideosAfter?.data?.length ?? 0,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              print('check lilk ${controller.fetchDemoVideosAfter?.data?[index].youtubeLink}');
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if(controller.fetchDemoVideosAfter?.data?[index].type!='Youtube')
                                  VideoPlayerCard(
                                    type: true,
                                    demoId: '${controller.fetchDemoVideosAfter?.data?[index].id}',
                                    url: '${controller.fetchDemoVideosAfter?.data?[index].videoLink}',
                                    aspectRatio: 1/2,
                                    borderRadius: 1,
                                  )
                                 else
                                 YoutubeVideoPlayerCard(
                                   aspectRatio: 1/1,
                                 url: '${controller.fetchDemoVideosAfter?.data?[index].youtubeLink}',
                              borderRadius: 18,
                              backGroundColor: true,
                              ),


                                ],
                              );
                            },
                          ),
                        ),
                        // YoutubeVideoPlayerCard(
                        //   url: '${data?.file}',
                        //   borderRadius: 18,
                        //   backGroundColor: true,
                        // ),
                        // Expanded(
                        //   child: ListView.builder(
                        //     shrinkWrap: true,
                        //     itemCount: controller.fetchDemoVideosAfter?.data?.length??0,
                        //     itemBuilder: (context, index) {
                        //     // return VideoPlay(video: controller.fetchDemoVideosAfter?.data?[index].videoLink??'',);
                        //     return VideoPlayerCard(
                        //      type: true,
                        //       demoId:'${controller.fetchDemoVideosAfter?.data?[index].id}' ,
                        //       url:'${controller.fetchDemoVideosAfter?.data?[index].videoLink}',
                        //       aspectRatio: 2.2/4.5,
                        //       borderRadius: 1,
                        //     );
                        //   },),
                        // ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomeText(
                          text: 'Best water purifier: 10 picks to ensure\nclean drinking water',
                        ),
                      ),
                    ),
                    Positioned(
                      top: size.height * 0.05,
                      child: Row(
                        children: [
                          const CustomBackButton(
                            padding: EdgeInsets.all(8),
                          ),
                          SizedBox(
                            width: size.width * 0.2,
                          ),
                          CustomeText(
                            text: 'Demo Videos',
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
        },
      ),
      // bottomNavigationBar: Column(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     Align(
      //       alignment: Alignment.bottomLeft,
      //       child: Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: CustomeText(
      //           text: 'Best water purifier: 10 picks to ensure\nclean drinking water',
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}

class VideoPlay extends StatefulWidget {
  final String video;

  const VideoPlay({super.key, required this.video});

  @override
  State<VideoPlay> createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {
  ValueNotifier<VideoPlayerValue?> currentPosition = ValueNotifier(null);
  VideoPlayerController? controller;
  late Future<void> futureController;

  initVideo() {
    controller = VideoPlayerController.networkUrl(Uri.parse(widget.video ?? ''));
    futureController = controller!.initialize();
    controller?.play();
    setState(() {});
  }

  void initState() {
    initVideo();
    // controller!.addListener(() {
    //   if (controller!.value.isInitialized) {
    //     currentPosition.value = controller?.value;
    //     if (controller!.value.position >= controller!.value.duration) {
    //       controller?.pause();
    //       if(widget.jumpType=='3'){
    //         context.read<CheckDemoController>()?.nextPage(3);
    //       }else if(widget.jumpType=='4'){
    //         context.read<CheckDemoController>()?.nextPage(5);
    //         context.read<CheckDemoController>()?.addIndex(5);
    //       }
    //       else{
    //         context.read<CheckDemoController>()?.nextPage(1);
    //       }
    //
    //     }
    //   }
    //   setState(() {
    //   });
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
          future: futureController,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else {
              return InkWell(
                onTap: () {
                  // Get.to(ShowVideoAndPhotos(
                  //   image: null,
                  //   video: widget.pathh,
                  // ));
                },
                child: AspectRatio(
                    // aspectRatio: controller!.value.aspectRatio,
                    aspectRatio: 2 / 4,
                    child: Stack(children: [
                      Positioned.fill(
                          child: Container(
                              foregroundDecoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [Colors.black.withOpacity(.7), Colors.transparent],
                                    stops: const [0, .3],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter),
                              ),
                              child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: SizedBox(
                                      width: controller!.value.size.width,
                                      height: controller!.value.size.height,
                                      child: VideoPlayer(controller!))))),
                    ])),
              );
            }
          },
        ),
      ],
    );
  }
}
