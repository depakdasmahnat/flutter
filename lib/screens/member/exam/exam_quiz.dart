import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/models/member/exam_quiz_model.dart';
import 'package:mrwebbeast/utils/widgets/gradient_button.dart';

class ExamQuiz extends StatefulWidget {
  const ExamQuiz({super.key});

  @override
  State<ExamQuiz> createState() => _ExamQuizState();
}

class _ExamQuizState extends State<ExamQuiz> {
  List<ExamQuizQuestion> interestQuestions = [
    ExamQuizQuestion(
      id: 1,
      categoryId: 1,
      question: 'Do you want to make money?',
      answers: ['Yes', 'No'],
    ),
    ExamQuizQuestion(
      id: 2,
      categoryId: 1,
      question: 'Why are you here?',
      answers: ['Illness', 'Enhance leadership'],
    ),
    ExamQuizQuestion(
      id: 3,
      categoryId: 2,
      question: 'Are you interested in technology?',
      answers: ['Yes', 'No'],
    ),
    ExamQuizQuestion(
      id: 4,
      categoryId: 2,
      question: 'What programming languages do you know?',
      answers: ['Python', 'JavaScript', 'Java', 'C++', 'Other'],
    ),
    ExamQuizQuestion(
      id: 5,
      categoryId: 3,
      question: 'Do you enjoy outdoor activities?',
      answers: ['Yes', 'No'],
    ),
    ExamQuizQuestion(
      id: 6,
      categoryId: 3,
      question: "What's your favorite sport?",
      answers: ['Football', 'Basketball', 'Tennis', 'Other'],
    ),
    ExamQuizQuestion(
      id: 7,
      categoryId: 4,
      question: 'Are you passionate about environmental issues?',
      answers: ['Yes', 'No'],
    ),
    ExamQuizQuestion(
      id: 8,
      categoryId: 4,
      question: 'Do you recycle regularly?',
      answers: ['Yes', 'No'],
    ),
    ExamQuizQuestion(
      id: 9,
      categoryId: 5,
      question: 'Are you a fan of science fiction?',
      answers: ['Yes', 'No'],
    ),
    ExamQuizQuestion(
      id: 10,
      categoryId: 5,
      question: 'Star Wars or Star Trek?',
      answers: ['Star Wars', 'Star Trek', 'Both', 'Neither'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Exam',
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: 100),
        children: [
          ListView.builder(
            itemCount: interestQuestions.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              ExamQuizQuestion data = interestQuestions.elementAt(index);

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
                            '${data.question}',
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
                      itemCount: data.answers?.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 16),
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 4),
                      itemBuilder: (context, optionIndex) {
                        var option = data.answers?.elementAt(optionIndex);
                        bool isSelected = interestQuestions[index].selectedAnswer == option;

                        return GradientButton(
                          height: 40,
                          borderRadius: 50,
                          backgroundGradient: isSelected ? primaryGradient : null,
                          backgroundColor: isSelected ? null : Colors.white,
                          onTap: () {
                            interestQuestions[index].selectedAnswer = option;
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
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GradientButton(
            height: 50,
            width: 120,
            borderRadius: 8,
            border: Border.all(color: Colors.white),
            backgroundColor: Colors.black,
            onTap: () {},
            margin: const EdgeInsets.symmetric(horizontal: kPadding, vertical: 8),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Previous',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GradientButton(
            height: 50,
            width: 120,
            borderRadius: 8,
            backgroundGradient: whiteGradient,
            margin: const EdgeInsets.symmetric(horizontal: kPadding, vertical: 8),
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
