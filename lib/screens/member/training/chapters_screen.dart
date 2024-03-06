import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/constant/enums.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/core/route/route_paths.dart';
import 'package:mrwebbeast/screens/member/training/chapter_details.dart';
import 'package:mrwebbeast/utils/widgets/gradient_button.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import 'package:provider/provider.dart';

import '../../../controllers/member/training/training_controller.dart';
import '../../../models/member/training/chapters_model.dart';
import '../../../models/member/training/training_categories_model.dart';
import '../../../utils/widgets/loading_screen.dart';
import '../../../utils/widgets/no_data_found.dart';

class ChaptersScreen extends StatefulWidget {
  const ChaptersScreen({super.key, required this.category});

  final TrainingCategoryData? category;

  @override
  State<ChaptersScreen> createState() => _ChaptersScreenState();
}

class _ChaptersScreenState extends State<ChaptersScreen> {
  late TrainingCategoryData? category = widget.category;

  List<ChapterData>? chapters;

  Future fetchChapters({bool? loadingNext}) async {
    return await context.read<TrainingControllers>().fetchChapters(trainingId: category?.id);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchChapters();
    });
  }

  Timer? _debounce;

  void onSearchFieldChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchChapters();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TrainingControllers>(
      builder: (context, controller, child) {
        chapters = controller.chapters;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              category?.subCategoryName ?? 'Chapters',
            ),
          ),
          body: ListView(
            shrinkWrap: true,
            children: [
              if (controller.loadingChapters)
                const LoadingScreen(
                  heightFactor: 0.7,
                  message: 'Loading Chapters...',
                )
              else if (chapters.haveData)
                ListView.builder(
                  itemCount: chapters?.length ?? 0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ChapterCard(
                      chapter: chapters?.elementAt(index),
                    );
                  },
                )
              else
                NoDataFound(
                  heightFactor: 0.7,
                  message: controller.chaptersModel?.message ?? 'No Chapters Found',
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
    required this.chapter,
  });

  final ChapterData? chapter;

  @override
  Widget build(BuildContext context) {
    bool isOpen = chapter?.chapterStatus == ChapterStatus.open.value;
    bool isCompleted = chapter?.chapterStatus == ChapterStatus.complete.value;
    bool isLocked = chapter?.chapterStatus == ChapterStatus.locked.value;

    return GestureDetector(
      onTap: () {
        if (isOpen || isCompleted) {
          context.pushNamed(Routs.chaptersDetails, extra: ChaptersDetails(chapter: chapter));
          // context.pushNamed(Routs.examQuiz, extra: const ExamQuiz());
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        margin: const EdgeInsets.symmetric(
          horizontal: kPadding,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          gradient: blackGradient,
          borderRadius: BorderRadius.circular(14),
        ),
        child: ListTile(
          dense: true,
          leading: GradientButton(
            height: 45,
            width: 45,
            borderRadius: 30,
            padding: EdgeInsets.zero,
            margin: const EdgeInsets.only(),
            backgroundColor: isLocked ? Colors.black : null,
            backgroundGradient: isLocked ? null : primaryGradient,
            child: Center(
              child: ImageView(
                height: 20,
                width: 20,
                color: isLocked ? null : Colors.black,
                fit: BoxFit.contain,
                assetImage: AppAssets.playVideoIcon,
              ),
            ),
          ),
          title: Text(
            '${chapter?.chapterName} ${chapter?.chapterNo}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          subtitle: chapter?.description != null
              ? Text(
                  '${chapter?.description}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                )
              : null,
          trailing: isLocked
              ? GradientButton(
                  borderRadius: 30,
                  backgroundColor: Colors.white,
                  child: const ImageView(
                    height: 16,
                    width: 16,
                    color: Colors.black,
                    fit: BoxFit.contain,
                    assetImage: AppAssets.lockFilledIcon,
                  ),
                )
              : (isCompleted)
                  ? GradientButton(
                      height: 28,
                      width: 28,
                      borderRadius: 30,
                      backgroundGradient: limeGradient,
                      child: const ImageView(
                        height: 16,
                        width: 16,
                        fit: BoxFit.contain,
                        assetImage: AppAssets.checkIcon,
                      ),
                    )
                  : const SizedBox(),
        ),
      ),
    );
  }
}
