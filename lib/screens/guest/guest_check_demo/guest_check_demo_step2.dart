

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/screens/guest/guestProfile/guest_faq.dart';
import 'package:mrwebbeast/utils/widgets/loading_screen.dart';
import 'package:provider/provider.dart';

import '../../../controllers/check_demo_controller/check_demo_controller.dart';
import '../../../core/constant/gradients.dart';
import '../../../models/default/default_model.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../../../utils/widgets/widgets.dart';

class GuestCheckDemoStep2 extends StatefulWidget {
  final PageController? pageController;
  const GuestCheckDemoStep2({super.key, this.pageController});

  @override
  State<GuestCheckDemoStep2> createState() => _GuestCheckDemoStep2State();
}

class _GuestCheckDemoStep2State extends State<GuestCheckDemoStep2> {
  final PageController _pageController = PageController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context
          .read<CheckDemoController>()
          .getDemoQuestions(context: context);
      context.read<CheckDemoController>().ansQues.clear();
    });
    super.initState();
  }

  List item = [];
  bool checkBox = false;
  // bool showItem =false;
  String showItem = 'No';

  int? page = 0;
  Map<int, int> selectedIndices = {};
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Consumer<CheckDemoController>(
          builder: (context, controller, child) {
            return controller.guestDemoLoader == false
                ? const LoadingScreen()
                : PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ListView(
                        shrinkWrap: true,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: CustomText1(
                              text:
                                  'Unlock your financial potential',
                              fontWeight: FontWeight.w400,
                              fontSize: 38,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: CustomeText(
                              text: 'Choose as many as you like',
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: controller.guestDemoQuestions?.data?[0]
                                      .questionType2?.length ??
                                  0,
                              physics: const NeverScrollableScrollPhysics(),
                              padding:
                                  EdgeInsets.only(bottom: size.height * 0.1),
                              itemBuilder: (context, index) {
                                return index == 0
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              gradient: inActiveGradient,
                                              borderRadius:
                                                  BorderRadius.circular(13)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                CustomText1(
                                                  text: controller
                                                      .guestDemoQuestions
                                                      ?.data?[0]
                                                      .questionType2?[index]
                                                      .question,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                ListView.builder(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount: controller
                                                          .guestDemoQuestions
                                                          ?.data?[0]
                                                          .questionType2?[index]
                                                          .answer
                                                          ?.length ??
                                                      0,
                                                  shrinkWrap: true,
                                                  itemBuilder: (context, i) {
                                                    return InkWell(
                                                      onTap: () {
                                                        selectedIndices[index] =
                                                            i;
                                                        showItem = controller
                                                                .guestDemoQuestions
                                                                ?.data?[0]
                                                                .questionType2?[
                                                                    index]
                                                                .answer?[i] ??
                                                            '';
                                                        print('Check snas $showItem');
                                                        print('Check snas ${selectedIndices[index]}');

                                                        controller.ansQues.add(Questions(
                                                            ans: controller.guestDemoQuestions?.data?[0].questionType2?[index].answer?[i],
                                                            id: controller
                                                                .guestDemoQuestions
                                                                ?.data?[0]
                                                                .questionType2?[
                                                                    index]
                                                                .id
                                                                .toString()));
                                                        setState(() {});
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 8,
                                                                right: 8,
                                                                bottom: 12,
                                                                top: 8),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                selectedIndices[
                                                                            index] ==
                                                                        i
                                                                    ? Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          shape:
                                                                              BoxShape.circle,
                                                                          gradient:
                                                                              primaryGradient,
                                                                        ),
                                                                        height: size.height *
                                                                            0.02,
                                                                        width: size.height *
                                                                            0.02,
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              1),
                                                                          child:
                                                                              Container(
                                                                            decoration: BoxDecoration(
                                                                                shape: BoxShape.circle,
                                                                                gradient: primaryGradient,
                                                                                border: Border.all()),
                                                                            height:
                                                                                size.height * 0.02,
                                                                            width:
                                                                                size.height * 0.02,
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Container(
                                                                        decoration: const BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            color: Colors.white),
                                                                        height: size.height *
                                                                            0.02,
                                                                        width: size.height *
                                                                            0.02,
                                                                      ),
                                                                SizedBox(
                                                                  width:
                                                                      size.width *
                                                                          0.02,
                                                                ),
                                                                CustomeText(
                                                                  text: controller
                                                                      .guestDemoQuestions
                                                                      ?.data?[0]
                                                                      .questionType2?[
                                                                          index]
                                                                      .answer?[i],
                                                                )
                                                              ],
                                                            ),
                                                            if (selectedIndices[
                                                                    index] ==
                                                                i)
                                                              ShaderMask(
                                                                blendMode:
                                                                    BlendMode
                                                                        .srcIn,
                                                                shaderCallback: (Rect
                                                                        bounds) =>
                                                                    primaryGradient
                                                                        .createShader(
                                                                            bounds),
                                                                child:
                                                                    const Icon(
                                                                  Icons.check,
                                                                  size: 25,
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : const Offstage();
                              },
                            ),
                          ),
                        ],
                      ),
                      ListView(
                        shrinkWrap: true,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: CustomText1(
                              text:
                                  'Choose your interests for your future goal',
                              fontWeight: FontWeight.w400,
                              fontSize: 38,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: CustomeText(
                              text: 'Choose as many as you like',
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: controller.guestDemoQuestions?.data?[0]
                                      .questionType2?.length ??
                                  0,
                              physics: const NeverScrollableScrollPhysics(),
                              padding:
                                  EdgeInsets.only(bottom: size.height * 0.1),
                              itemBuilder: (context, index) {
                                return index != 0
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              gradient: inActiveGradient,
                                              borderRadius:
                                                  BorderRadius.circular(13)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                CustomText1(
                                                  text: controller.guestDemoQuestions?.data?[0].questionType2?[index].question,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                ListView.builder(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount: controller
                                                          .guestDemoQuestions
                                                          ?.data?[0]
                                                          .questionType2?[index]
                                                          .answer
                                                          ?.length ??
                                                      0,
                                                  shrinkWrap: true,
                                                  itemBuilder: (context, i) {
                                                    return InkWell(
                                                      onTap: () {
                                                        selectedIndices[index] = i;
                                                        // showItem = controller.guestDemoQuestions?.data?[0].questionType2?[index].answer?[i] ??
                                                        //     '';
                                                        // print('Check snas $showItem');
                                                        // print('Check snas ${selectedIndices[index]}');
                                                        controller.ansQues.add(Questions(
                                                            ans: controller
                                                                .guestDemoQuestions
                                                                ?.data?[0]
                                                                .questionType2?[
                                                                    index]
                                                                .answer?[i],
                                                            id: controller
                                                                .guestDemoQuestions
                                                                ?.data?[0]
                                                                .questionType2?[
                                                                    index]
                                                                .id
                                                                .toString()));
                                                        setState(() {});
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 8,
                                                                right: 8,
                                                                bottom: 12,
                                                                top: 8),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                selectedIndices[
                                                                            index] ==
                                                                        i
                                                                    ? Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          shape:
                                                                              BoxShape.circle,
                                                                          gradient:
                                                                              primaryGradient,
                                                                        ),
                                                                        height: size.height *
                                                                            0.02,
                                                                        width: size.height *
                                                                            0.02,
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              1),
                                                                          child:
                                                                              Container(
                                                                            decoration: BoxDecoration(
                                                                                shape: BoxShape.circle,
                                                                                gradient: primaryGradient,
                                                                                border: Border.all()),
                                                                            height:
                                                                                size.height * 0.02,
                                                                            width:
                                                                                size.height * 0.02,
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Container(
                                                                        decoration: const BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            color: Colors.white),
                                                                        height: size.height *
                                                                            0.02,
                                                                        width: size.height *
                                                                            0.02,
                                                                      ),
                                                                SizedBox(
                                                                  width:
                                                                      size.width *
                                                                          0.02,
                                                                ),
                                                                CustomeText(
                                                                  text: controller
                                                                      .guestDemoQuestions
                                                                      ?.data?[0]
                                                                      .questionType2?[
                                                                          index]
                                                                      .answer?[i],
                                                                )
                                                              ],
                                                            ),
                                                            if (selectedIndices[
                                                                    index] ==
                                                                i)
                                                              ShaderMask(
                                                                blendMode:
                                                                    BlendMode
                                                                        .srcIn,
                                                                shaderCallback: (Rect
                                                                        bounds) =>
                                                                    primaryGradient
                                                                        .createShader(
                                                                            bounds),
                                                                child:
                                                                    const Icon(
                                                                  Icons.check,
                                                                  size: 25,
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : const Offstage();
                              },
                            ),
                          ),
                        ],
                      ),
                      ListView(
                        shrinkWrap: true,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: CustomeText(
                              text: 'Top 3 success drivers',
                              fontWeight: FontWeight.w400,
                              fontSize: 38,
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: CustomText1(
                              text:
                                  'Choose any three options according to your interest.',
                              fontWeight: FontWeight.w400,
                              textAlign: TextAlign.center,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: controller.guestDemoQuestions!.data?[0].questionType1?.length ?? 0,
                              physics: const NeverScrollableScrollPhysics(),
                              padding:
                                  EdgeInsets.only(bottom: size.height * 0.1),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: CustomText1(
                                          text: controller
                                              .guestDemoQuestions!
                                              .data?[0]
                                              .questionType1?[index]
                                              .question,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Transform.scale(
                                        scale: 1.3,
                                        child: Checkbox(
                                          value: controller
                                              .guestDemoQuestions
                                              ?.data?[0]
                                              .questionType1?[index]
                                              .answer,
                                          onChanged: (value) {
                                            if (item.length >= 3) {
                                              if (controller
                                                      .guestDemoQuestions
                                                      ?.data?[0]
                                                      .questionType1?[index]
                                                      .answer ==
                                                  true) {
                                                controller
                                                    .guestDemoQuestions
                                                    ?.data?[0]
                                                    .questionType1?[index]
                                                    .answer = value;

                                                controller.ansQues
                                                    .removeAt(index);
                                                item.removeAt(index);
                                              } else {
                                                showError(
                                                    context: context,
                                                    message:
                                                        "You can't select more then 3 questions");
                                              }
                                            } else {
                                              controller
                                                  .guestDemoQuestions
                                                  ?.data?[0]
                                                  .questionType1?[index]
                                                  .answer = value;
                                              item.add(controller
                                                  .guestDemoQuestions
                                                  ?.data?[0]
                                                  .questionType1?[index]
                                                  .answer);
                                              controller.ansQues.add(Questions(
                                                  id: controller
                                                          .guestDemoQuestions
                                                          ?.data?[0]
                                                          .questionType1?[index]
                                                          .id
                                                          .toString() ??
                                                      '',
                                                  ans: controller
                                                      .guestDemoQuestions
                                                      ?.data?[0]
                                                      .questionType1?[index]
                                                      .answer
                                                      .toString()));
                                            }
                                            print("check lenth1 $item");
                                            setState(() {});
                                            print("check lenth ${item.length}");
                                          },
                                          fillColor:
                                              MaterialStateProperty.resolveWith(
                                                  (states) {
                                            if (!states.contains(
                                                MaterialState.selected)) {
                                              return Colors.white;
                                            }
                                            return null;
                                          }),
                                          checkColor: Colors.black,
                                          activeColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  );
          },
        ),
      ),
      bottomSheet: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          GradientButton(
            height: 60,
            borderRadius: 18,
            blur: 10,
            backgroundGradient: primaryGradient,
            backgroundColor: Colors.transparent,
            boxShadow: const [],
            margin: const EdgeInsets.only(left: 16, right: 24),
            onTap: () async {

              if (page == 0) {
                if (showItem == 'Yes') {
                  _pageController.jumpToPage(1);
                  page =1;
                  setState(() {});
                  print("check page13456 $page");
                }
                else {
                  page = 1;
                  print("check page13 $page");
                  DefaultModel? responseData = await context.read<CheckDemoController>().submitAns(context: context, ans: context.read<CheckDemoController>().ansQues);
                  if (responseData?.status == true) {
                    context.read<CheckDemoController>().addIndex(2,'No');
                    // await context.read<CheckDemoController>().guestCheckDemoStep1(context: context);
                    context.read<CheckDemoController>().nextPage(2);
                  }
                  setState(() {});
                }
              } else if(page==1){
                if (showItem == 'Yes') {
                  _pageController.jumpToPage(2);
                  page =2;
                  setState(() {});
                  print("check  $page");
                }

            } else{
                print("check page13 $page");
                DefaultModel? responseData = await context.read<CheckDemoController>().submitAns(context: context, ans: context.read<CheckDemoController>().ansQues);
                if (responseData?.status == true) {
                  context.read<CheckDemoController>().addIndex(2,'');
                  context.read<CheckDemoController>().nextPage(2);
                }
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  page == 0 ? 'Next' : 'Submit',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: GoogleFonts.urbanist().fontFamily,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.02,
          )
        ],
      ),
    );
  }
}

class CustomText1 extends StatelessWidget {
  String? text;
  Color? color;
  double? fontSize;
  double? textHeight;
  TextAlign? textAlign;
  FontWeight? fontWeight;
  int? maxLines;

  CustomText1({
    this.color,
    this.text,
    this.fontWeight,
    this.fontSize,
    this.textHeight,
    this.textAlign,
    this.maxLines,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Text(
      text ?? '',
      maxLines: maxLines,
      style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          height: textHeight),
      textAlign: textAlign ?? TextAlign.start,
    );
  }
}
