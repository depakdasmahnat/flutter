import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/utils/widgets/gradient_button.dart';
import 'package:provider/provider.dart';

import '../../../controllers/member/training/training_controller.dart';
import '../../../models/member/training/quiz_model.dart';
import '../../../utils/widgets/loading_screen.dart';
import '../../../utils/widgets/no_data_found.dart';

class ExamQuiz extends StatefulWidget {
  const ExamQuiz({super.key, this.chapterId});

  final num? chapterId;

  @override
  State<ExamQuiz> createState() => _ExamQuizState();
}

class _ExamQuizState extends State<ExamQuiz> {
  late num? chapterId = widget.chapterId;

  List<QuizData>? quizzes;

  Future fetchQuizzes({bool? loadingNext}) async {
    return await context.read<TrainingControllers>().fetchQuizzes(chapterId: chapterId);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchQuizzes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TrainingControllers>(
      builder: (context, controller, child) {
        quizzes = controller.quizzes;
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Test',
            ),
          ),
          body: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 100),
            children: [
              if (controller.loadingQuizzes)
                const LoadingScreen(
                  heightFactor: 0.8,
                  message: 'Loading Test...',
                )
              else if (quizzes.haveData)
                ListView.builder(
                  itemCount: quizzes?.length ?? 0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    QuizData? data = quizzes?.elementAt(index);

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      margin: const EdgeInsets.symmetric(horizontal: kPadding, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: blackGradient,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Text(
                                  'Q${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${data?.question}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          GridView.builder(
                            itemCount: data?.options?.length,
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(top: 16),
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 4),
                            itemBuilder: (context, optionIndex) {
                              var option = data?.options?.elementAt(optionIndex);
                              bool isSelected = quizzes?[index].selectedAnswer == option;

                              return GradientButton(
                                height: 40,
                                borderRadius: 50,
                                backgroundGradient: isSelected ? primaryGradient : null,
                                backgroundColor: isSelected ? null : Colors.white,
                                onTap: () {
                                  quizzes?[index].selectedAnswer = option;
                                  context.read<TrainingControllers>().submitUsersAnswer(
                                        context: context,
                                        index: index,
                                        questionId: data?.id,
                                        answer: option,
                                      );

                                  setState(() {});
                                },
                                margin: EdgeInsets.zero,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${optionIndex + 1}) $option',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
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
                    );
                  },
                )
              else
                NoDataFound(
                  heightFactor: 0.8,
                  message: controller.quizModel?.message ?? 'No Test Found',
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
                  // context.pushNamed(Routs.createDemo);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Submit',
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
        );
      },
    );
  }
}
