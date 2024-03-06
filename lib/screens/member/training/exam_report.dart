import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/utils/widgets/custom_back_button.dart';
import 'package:mrwebbeast/utils/widgets/gradient_button.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import 'package:provider/provider.dart';

import '../../../controllers/member/training/training_controller.dart';
import '../../../models/member/training/quiz_report_model.dart';

class ExamReport extends StatefulWidget {
  const ExamReport({super.key, this.report});

  final QuizReportModel? report;

  @override
  State<ExamReport> createState() => _ExamReportState();
}

class _ExamReportState extends State<ExamReport> {
  late QuizReportModel? report = widget.report;

  late List<QuestionAnswers>? questionAnswers = report?.questionAnswers;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TrainingControllers>(
      builder: (context, controller, child) {
        return Stack(
          children: [
            const ImageView(
              assetImage: AppAssets.reportBg,
              backgroundColor: Colors.black,
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                leading: const Column(
                  children: [CustomBackButton()],
                ),
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          'Test Result',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      GradientButton(
                        backgroundGradient: primaryGradient,
                        borderRadius: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          report?.result ?? 'Fail',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 8, bottom: kPadding),
                        child: Text(
                          'Your test results in chapter this time',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    alignment: Alignment.topCenter,
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            left: kPadding, right: kPadding, top: 48, bottom: kPadding),
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                        decoration: BoxDecoration(
                          gradient: primaryGradient,
                          borderRadius: BorderRadius.circular(kPadding),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 8),
                                      child: Text(
                                        'Correct answer',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8, bottom: kPadding),
                                      child: Text(
                                        '${report?.correctAnswers ?? 0}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 8),
                                      child: Text(
                                        'Wrong answer',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8, bottom: kPadding),
                                      child: Text(
                                        '${report?.wrongAnswers ?? 0}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${report?.score ?? 0}',
                                  style: const TextStyle(
                                    fontSize: 56,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 0,
                        child: ImageView(
                          height: 80,
                          width: 80,
                          assetImage: AppAssets.trophyIcon,
                          borderRadiusValue: 100,
                          padding: const EdgeInsets.all(16),
                          backgroundColor: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              bottomNavigationBar: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GradientButton(
                    height: 60,
                    borderRadius: 18,
                    backgroundGradient: primaryGradient,
                    blur: 20,
                    backgroundColor: Colors.transparent,
                    boxShadow: const [],
                    margin: const EdgeInsets.only(left: 16, right: 24, bottom: 24),
                    onTap: () {
                      context.pop();
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
              ),
            ),
          ],
        );
      },
    );
  }
}
