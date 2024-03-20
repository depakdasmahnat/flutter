import 'dart:async';

import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import 'package:provider/provider.dart';
import '../../../controllers/guest_controller/guest_controller.dart';
import '../../../core/constant/gradients.dart';

class GuestProfiles extends StatefulWidget {
  const GuestProfiles({super.key});

  @override
  State<GuestProfiles> createState() => _GuestProfilesState();
}

class _GuestProfilesState extends State<GuestProfiles> {
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
   FlipCardController? _controller;
  int _currentIndex = 0;
  List<Widget> _widgets = [];
  bool _isPageActive = true;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _controller = FlipCardController();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<GuestControllers>().fetchNewJoiners(
        context: context,
      );
      _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
        if (_isPageActive) {
          if (_currentIndex < _widgets.length - 1) {
            _currentIndex++;
          } else {
            _currentIndex = 0;
          }
          if (_controller != null && mounted) {
            await _controller?.toggleCard();
            setState(() {});
          }
        } else {
          timer.cancel();
        }
      });
    });
  }
  @override
  void dispose() {
    _isPageActive = false;
    _timer?.cancel();
    _controller?.controller?.isDismissed;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<GuestControllers>(
      builder: (context, controller, child) {
        List<Widget> widgets = [
          Column(
            children: [
              FlipCard(
               key: cardKey,
                controller: _controller,
                speed: 1500,
                flipOnTouch: false,
                fill: Fill.fillBack,
                autoFlipDuration: const Duration(seconds: 2),
                direction: FlipDirection.HORIZONTAL,
                side: CardSide.FRONT,
                front: Container(
                  height: 45,
                  width: 45,
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, gradient: primaryGradient),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '07 Days',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 8,
                            fontFamily: GoogleFonts.urbanist().fontFamily,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          '${controller.fetchnewjoiners?.data?.counts}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: GoogleFonts.urbanist().fontFamily,
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ),
                back: Container(
                  height: 45,
                  width: 45,
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, gradient: primaryGradient),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '07 Days',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 8,
                            fontFamily: GoogleFonts.urbanist().fontFamily,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          '${controller.fetchnewjoiners?.data?.counts}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: GoogleFonts.urbanist().fontFamily,
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Text(
                'New\nMembers Join',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontFamily: GoogleFonts.urbanist().fontFamily,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ];

        controller.fetchnewjoiners?.data?.members?.forEach((element) {
          widgets.add(
            NewJoiner(
              image: element.profilePhoto ?? '',
              firstName: element.firstName ?? '',
              cityName: element.cityName ?? '',
            ),
          );
        });
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPadding),
          child: SizedBox(
            height: size.height * 0.10,
            width: size.width * 0.5,
            child: controller.isLoading == false
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: CupertinoActivityIndicator(
                            radius: 15, color: CupertinoColors.white),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: widgets.length > 2 ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
                    children: widgets,
                  ),
          ),
        );
      },
    );
  }
}

class NewJoiner extends StatelessWidget {
  String? image;
  String? firstName;
  String? cityName;
  NewJoiner({
    this.image,
    this.firstName,
    this.cityName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        // image?.isEmpty == true
        //     ? const CircleAvatar(
        //         // maxRadius: size.height * 0.03,
        //         // minRadius: size.height * 0.03,
        //         backgroundImage: AssetImage(AppAssets.getsprofile),
        //       )
        //     : CircleAvatar(
        //         // maxRadius: size.height * 0.03,
        //         // minRadius: size.height * 0.03,
        //         backgroundImage: NetworkImage(
        //           image ?? '',
        //         ),
        //       ),
        ImageView(
          height: 45,
          width: 45,
          backgroundColor: Colors.grey.shade200,
          borderRadiusValue: 30,
          isAvatar: true,
          margin: const EdgeInsets.only(bottom: 4),
          networkImage: image ?? '',
        ),
        SizedBox(
          width: 48,
          child: Text(
            firstName ?? 'Deepak',
            maxLines: 1,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: GoogleFonts.urbanist().fontFamily,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.ellipsis,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Text(
          cityName?.isEmpty == true ? 'Raipur' : cityName ?? '',
          style: TextStyle(
            color: Colors.white,
            fontSize: 8,
            fontFamily: GoogleFonts.urbanist().fontFamily,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
