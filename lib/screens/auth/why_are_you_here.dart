import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/route/route_paths.dart';
import 'package:mrwebbeast/screens/guest/guestProfile/guest_faq.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller/auth_controller.dart';
import '../../core/constant/gradients.dart';
import '../../models/auth_model/fetchinterestcategory.dart';
import '../../models/default/default_model.dart';
import '../../utils/widgets/gradient_button.dart';

class WhyAreYouHere extends StatefulWidget {
  final String questionId;
  final String question;
  final List item;

  WhyAreYouHere({super.key, required this.questionId, required this.item, required this.question});

  @override
  State<WhyAreYouHere> createState() => _WhyAreYouHereState();
}

class _WhyAreYouHereState extends State<WhyAreYouHere> {
  Fetchinterestcategory? fetchInterestCategory;
  GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
  List<String> selectedInterests = [];
  String question = '';
  int? tabIndex = -1;

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    //   fetchInterestCategory = await context.read<AuthControllers>().fetchInterestCategories(context: context, type: 'Interest');
    //
    //   fetchInterestCategory?.data?.forEach((element) {
    //     print('check interest category ${element.name}');
    //   });
    // });
    // super.initState();
  }

  navigateToConnectWithUs() {
    return context.pushNamed(Routs.connectWithUs);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          GradientButton(
            height: 30,
            width: 75,
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
      body: Consumer<AuthControllers>(
        builder: (context, controller, child) {
          return Form(
            key: signInFormKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: Column(
                // padding: const EdgeInsets.only(left: 24, right: 24),
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: size.height * 0.05, bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Text(
                        widget.question,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w400,
                          height: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    child: widget.item.isNotEmpty == true
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: widget.item.length,
                            // physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(top: 24, bottom: kPadding),
                            itemBuilder: (context, index) {
                              // var data = interests.elementAt(index);
                              // bool isSelected = selectedInterests.contains(data);

                              return GradientButton(
                                height: 50,
                                borderRadius: 8,
                                backgroundGradient: tabIndex == index ? primaryGradient : inActiveGradient,
                                backgroundColor: Colors.transparent,
                                boxShadow: const [],
                                margin: const EdgeInsets.only(bottom: 6, top: 6),
                                onTap: () {
                                  tabIndex = index;
                                  question = widget.item[index];
                                  print("checkk name $question");
                                  // if (isSelected) {
                                  //   selectedInterests.remove(data);
                                  // } else {
                                  //   selectedInterests.add(data);
                                  // }
                                  // categoryId =fetchInterestCategory?.data?[index].id.toString()??'';
                                  setState(() {});
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.item[index] ?? '',
                                      style: TextStyle(
                                        color: tabIndex == index ? Colors.black : Colors.white,
                                        fontFamily: GoogleFonts.urbanist().fontFamily,
                                        fontWeight: FontWeight.w600,
                                        fontSize:tabIndex == index ?17: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : Center(
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
          );
        },
      ),
      bottomNavigationBar: question.isNotEmpty
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
                    questionAns(widget.questionId, question);
                    // context.pushNamed(Routs.questions, extra: QuestionsScreen(categoryId: categoryId,) );
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
    );
  }

  Future questionAns(String questionId, String answer) async {
    DefaultModel? responce = await context.read<AuthControllers>().questions(
          context: context,
          questionId: questionId,
          answer: answer,
        );
    if (responce?.status == true) {
      await context.pushNamed(
        Routs.connectWithUs,
      );
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
