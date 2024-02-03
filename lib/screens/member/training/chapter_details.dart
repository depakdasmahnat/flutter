import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/core/route/route_paths.dart';
import 'package:mrwebbeast/screens/member/training/chapter_details_card.dart';
import 'package:mrwebbeast/screens/member/training/exam_quiz.dart';
import 'package:mrwebbeast/utils/widgets/gradient_button.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import 'package:provider/provider.dart';

import '../../../controllers/member/training/training_controller.dart';
import '../../../models/member/training/chapter_details_model.dart';
import '../../../models/member/training/chapters_model.dart';
import '../../../utils/widgets/loading_screen.dart';
import '../../../utils/widgets/no_data_found.dart';

class ChaptersDetails extends StatefulWidget {
  const ChaptersDetails({super.key, required this.chapter});

  final ChapterData? chapter;

  @override
  State<ChaptersDetails> createState() => _ChaptersDetailsState();
}

class _ChaptersDetailsState extends State<ChaptersDetails> {
  late ChapterData? chapter = widget.chapter;

  ChapterDetailsData? chapterDetails;

  Future fetchChapters({bool? loadingNext}) async {
    return await context.read<TrainingControllers>().fetchChapterDetails(chapterId: chapter?.id);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchChapters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TrainingControllers>(
      builder: (context, controller, child) {
        chapterDetails = controller.chapterDetails;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              chapter?.chapterName ?? 'Chapter',
            ),
          ),
          body: ListView(
            shrinkWrap: true,
            children: [
              if (controller.loadingChapters)
                const LoadingScreen(
                  heightFactor: 0.7,
                  message: 'Loading Chapter...',
                )
              else if (chapterDetails?.assets.haveData == true)
                ListView.builder(
                  itemCount: chapterDetails?.assets?.length ?? 0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final ChapterExercise? data = chapterDetails?.assets?.elementAt(index);
                    return ChapterDetailsCard(data: data);
                  },
                )
              else
                NoDataFound(
                  heightFactor: 0.7,
                  message: controller.chaptersModel?.message ?? 'No Chapter Found',
                ),
              if (chapterDetails?.assets.haveData == true)
                ChapterCard(
                  chapterId: chapterDetails?.id,
                ),
            ],
          ),
        );
      },
    );
  }
}

class ChapterCard extends StatelessWidget {
  const ChapterCard({
    super.key,
    this.chapterId,
  });

  final num? chapterId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(Routs.examQuiz,
            extra: ExamQuiz(
              chapterId: chapterId,
            ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: kPadding, vertical: kPadding),
        decoration: BoxDecoration(
          gradient: whiteGradient,
          borderRadius: BorderRadius.circular(14),
        ),
        child: ListTile(
          leading: GradientButton(
            height: 50,
            width: 50,
            borderRadius: 30,
            padding: EdgeInsets.zero,
            backgroundGradient: blackGradient,
            child: const Center(
              child: ImageView(
                height: 20,
                width: 20,
                color: Colors.white,
                fit: BoxFit.contain,
                assetImage: AppAssets.documentIcon,
              ),
            ),
          ),
          title: const Text(
            'Test',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          trailing: GradientButton(
            borderRadius: 30,
            backgroundColor: Colors.white,
            child: const ImageView(
              height: 16,
              width: 16,
              color: Colors.black,
              fit: BoxFit.contain,
              assetImage: AppAssets.lockFilledIcon,
            ),
          ),
        ),
      ),
    );
  }
}
