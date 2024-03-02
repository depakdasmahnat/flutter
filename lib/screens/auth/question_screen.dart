import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/screens/auth/why_are_you_here.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller/auth_controller.dart';
import '../../core/constant/gradients.dart';
import '../../core/route/route_paths.dart';
import '../../models/auth_model/fetchinterestquestions.dart';
import '../../models/default/default_model.dart';
import '../../utils/widgets/gradient_button.dart';
import '../guest/guestProfile/guest_faq.dart';

class QuestionsScreen extends StatefulWidget {
  final String categoryId;
  const QuestionsScreen({super.key, required this.categoryId});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  Fetchinterestquestions? fetchQuestions;
  int? tabIndex =-1;
  String ans ='';

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      fetchQuestions = await context
          .read<AuthControllers>()
          .fetchInterestQuestions(
              context: context, categoryId: widget.categoryId);
    });
    super.initState();
  }

  GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
  navigateToConnectWithUs() {
    return context.pushNamed(Routs.connectWithUs);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<AuthControllers>(
      builder: (context, controller, child) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              GradientButton(
                height: 30,
                width: 75,
                blur: 10,
                borderRadius: 20,
                backgroundGradient: inActiveGradient,
                backgroundColor: Colors.transparent,
                boxShadow: const [],
                margin: const EdgeInsets.only(right: 16),
                onTap: () {
                  navigateToConnectWithUs();
                },
                child: const Center(
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body:Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // padding: const EdgeInsets.only(left: 24, right: 24),
              children: [
                SizedBox(
                  height:   size.height * 0.05
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Text(
                    controller.question1,
                    style: const TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w400,
                      height: 1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Text(
                  'Select your answers',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
                Expanded(
                  child: fetchQuestions?.data?[0].answers?.isNotEmpty==true?
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: fetchQuestions?.data?[0].answers?.length??0,
                    padding: const EdgeInsets.only(top: 24),
                    itemBuilder: (context, index) {


                      return GradientButton(
                        height: 50,
                        borderRadius: 8,
                        backgroundGradient: tabIndex==index ? primaryGradient : inActiveGradient,
                        backgroundColor: Colors.transparent,
                        boxShadow: const [],
                        margin: const EdgeInsets.only(bottom: 6, top: 6),
                        onTap: () {
                          tabIndex =index;
                          ans =fetchQuestions?.data?[0].answers?[index]??'';
                          setState(() {});

                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              fetchQuestions?.data?[0].answers?[index]??'',
                              style: TextStyle(
                                color: tabIndex==index?Colors.black: Colors.white,
                                fontFamily: GoogleFonts.urbanist().fontFamily,
                                fontWeight: FontWeight.w600,
                                fontSize: tabIndex == index?17: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ):
                  Center(
                    child: CustomeText(
                      text: 'No Data Found!',
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,

                    ),
                  ),
                )
              ],
            ),
          ),
          bottomNavigationBar: ans.isNotEmpty
        ? Column(
        mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GradientButton(
              height: 70,
              borderRadius: 18,
              backgroundGradient: primaryGradient,
              backgroundColor: Colors.transparent,
              boxShadow: const [],
              margin: const EdgeInsets.only(left: 16, right: 24),
              onTap: () {

                question(controller.questionId, ans,
                    controller.questionId2,
                    controller.itme,
                    controller.question2);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Next',
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
          ],
        )
            : null,

          // Stack(
          //   children: [
          //     Positioned(
          //       bottom: 0,
          //       child: Container(
          //         height: size.height * 0.6,
          //         width: size.width,
          //         decoration: const BoxDecoration(
          //           image: DecorationImage(
          //             image: AssetImage(
          //               AppAssets.moneyBg,
          //             ),
          //             fit: BoxFit.cover,
          //           ),
          //         ),
          //       ),
          //     ),
          //     Form(
          //       key: signInFormKey,
          //       child: Padding(
          //         padding: const EdgeInsets.only(left: 24, right: 24),
          //         child: Column(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Padding(
          //               padding:
          //                   EdgeInsets.only(top: size.height * 0.05, bottom: 8),
          //               child: Column(
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 children: [
          //                   Padding(
          //                     padding: const EdgeInsets.only(top: 8, bottom: 8),
          //                     child: Text(
          //                       controller.question1,
          //                       style: const TextStyle(
          //                         fontSize: 38,
          //                         fontWeight: FontWeight.w400,
          //                         height: 1,
          //                       ),
          //                       textAlign: TextAlign.center,
          //                     ),
          //                   ),
          //                   const Text(
          //                     'Select your answers',
          //                     style: TextStyle(
          //                       fontSize: 16,
          //                       fontWeight: FontWeight.w400,
          //                       height: 1,
          //                     ),
          //                     textAlign: TextAlign.center,
          //                   ),
          //                 ],
          //               ),
          //             ),
          //             Column(
          //               mainAxisSize: MainAxisSize.min,
          //               children: [
          //                 GradientButton(
          //                   height: 60,
          //                   borderRadius: 18,
          //                   blur: 10,
          //                   backgroundGradient: inActiveGradientTransparent,
          //                   backgroundColor: Colors.transparent,
          //                   boxShadow: const [],
          //                   margin: const EdgeInsets.only(bottom: 6, top: 6),
          //                   onTap: () {
          //                     // navigateToConnectWithUs();
          //                     question(
          //                         controller.questionId,
          //                         'Yes',
          //                         controller.questionId2,
          //                         controller.itme,
          //                         controller.question2);
          //                   },
          //                   child: Row(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     children: [
          //                       Text(
          //                         'Yes',
          //                         style: TextStyle(
          //                           color: Colors.white,
          //                           fontFamily:
          //                               GoogleFonts.urbanist().fontFamily,
          //                           fontWeight: FontWeight.w700,
          //                           fontSize: 18,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //                 GradientButton(
          //                   height: 60,
          //                   borderRadius: 18,
          //                   blur: 10,
          //                   backgroundGradient: inActiveGradientTransparent,
          //                   backgroundColor: Colors.transparent,
          //                   boxShadow: const [],
          //                   margin: const EdgeInsets.only(bottom: 6, top: 6),
          //                   onTap: () {
          //                     // navigateToConnectWithUs();
          //                     question(
          //                         controller.questionId,
          //                         'No',
          //                         controller.questionId2,
          //                         controller.itme,
          //                         controller.question2);
          //                   },
          //                   child: Row(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     children: [
          //                       Text(
          //                         'No',
          //                         style: TextStyle(
          //                           color: Colors.white,
          //                           fontFamily:
          //                               GoogleFonts.urbanist().fontFamily,
          //                           fontWeight: FontWeight.w700,
          //                           fontSize: 18,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ],
          //             )
          //           ],
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        );
      },
    );
  }

  Future question(String questionId, String answer, String questionId2,
      List item, String question2) async {
    DefaultModel? responce = await context.read<AuthControllers>().questions(
          context: context,
          questionId: questionId,
          answer: answer,
        );
    if (responce?.status == true) {
      await context.pushNamed(Routs.whyareYou,
          extra: WhyAreYouHere(
            questionId: questionId2,
            item: item,
            question: question2,
          ));
    }
  }

  Padding prefixIcon({required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          const SizedBox(
            height: 20,
            child: VerticalDivider(
              width: 1,
              thickness: 1.1,
            ),
          )
        ],
      ),
    );
  }
}
