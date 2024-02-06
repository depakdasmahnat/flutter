import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/controllers/guest_controller/guest_controller.dart';
import 'package:mrwebbeast/core/route/route_paths.dart';
import 'package:mrwebbeast/screens/auth/question_screen.dart';
import 'package:mrwebbeast/screens/guest/guestProfile/guest_faq.dart';
import 'package:provider/provider.dart';

import '../../core/constant/gradients.dart';
import '../../core/services/database/local_database.dart';
import '../../models/auth_model/fetchinterestcategory.dart';
import '../../models/auth_model/guest_data.dart';
import '../../utils/widgets/gradient_button.dart';

class InterestScreen extends StatefulWidget {
  const InterestScreen({super.key});

  @override
  State<InterestScreen> createState() => _InterestScreenState();
}

class _InterestScreenState extends State<InterestScreen> {
  Fetchinterestcategory? fetchInterestCategory;

  GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
  List<String> selectedInterests = [];
  String categoryId = '';
  int? tabIndex = -1;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      fetchInterestCategory =
          await context.read<GuestControllers>().fetchInterestCategories(context: context, type: 'Interest');
    });
    super.initState();
  }

  navigateToConnectWithUs() {
    return context.pushNamed(Routs.connectWithUs);
  }

  @override
  Widget build(BuildContext context) {
    GuestData? guest = context.read<LocalDatabase>().guest;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
      body: Consumer<GuestControllers>(
        builder: (context, controller, child) {
          return Form(
            key: signInFormKey,
            child: ListView(
              padding: const EdgeInsets.only(left: 24, right: 24),
              children: [
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.05, bottom: 8),
                  child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome  ${guest?.firstName}!',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          height: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        child: Text(
                          'Choose your interests for your future goal',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // Text(
                      //   'Choose as many as you like',
                      //   style: TextStyle(
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.w400,
                      //     height: 1,
                      //   ),
                      //   textAlign: TextAlign.center,
                      // ),
                    ],
                  ),
                ),
                fetchInterestCategory?.data?.isNotEmpty == true
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: fetchInterestCategory?.data?.length,
                        padding: const EdgeInsets.only(top: 24),
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
                              // if (isSelected) {
                              //   selectedInterests.remove(data);
                              // } else {
                              //   selectedInterests.add(data);
                              // }
                              categoryId = fetchInterestCategory?.data?[index].id.toString() ?? '';
                              setState(() {});
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  fetchInterestCategory?.data?[index].name ?? '',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: GoogleFonts.urbanist().fontFamily,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
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
                      )
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: categoryId.isNotEmpty
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
                    context.pushNamed(Routs.questions,
                        extra: QuestionsScreen(
                          categoryId: categoryId,
                        ));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue',
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
