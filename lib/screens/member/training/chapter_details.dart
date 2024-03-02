import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
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
import 'package:mrwebbeast/utils/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controllers/dashboard/download_controller.dart';
import '../../../controllers/member/training/training_controller.dart';
import '../../../core/constant/enums.dart';
import '../../../models/member/training/chapter_details_model.dart';
import '../../../models/member/training/chapters_model.dart';
import '../../../utils/widgets/image_opener.dart';
import '../../../utils/widgets/loading_screen.dart';
import '../../../utils/widgets/no_data_found.dart';
import '../../../utils/widgets/pdf_viewer.dart';

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
              if (controller.loadingChapterDetails)
                const LoadingScreen(
                  heightFactor: 0.7,
                  message: 'Loading Chapter Details...',
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
              Padding(
                padding: const EdgeInsets.only(left: kPadding, right: kPadding, top: kPadding),
                child: Text(
                  'Attachment',
                  style: TextStyle(
                    color: Colors.grey.shade300,
                    fontSize: 14,
                  ),
                ),
              ),
              if (chapterDetails?.attachments.haveData == true)
                ListView.builder(
                  itemCount: chapterDetails?.attachments?.length ?? 0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final ChapterExercise? data = chapterDetails?.attachments?.elementAt(index);
                    return DownloadAttachment(data: data);
                  },
                )
              else
                NoDataFound(
                  heightFactor: 0.7,
                  message: controller.chaptersModel?.message ?? 'No Attachments Found',
                ),
              if (chapterDetails?.assets.haveData == true)
                Padding(
                  padding: const EdgeInsets.only(left: kPadding, right: kPadding, top: kPadding),
                  child: Text(
                    'Test',
                    style: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 14,
                    ),
                  ),
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

class DownloadAttachment extends StatelessWidget {
  const DownloadAttachment({
    super.key,
    this.data,
  });

  final ChapterExercise? data;

  @override
  Widget build(BuildContext context) {
    return Consumer<DownloadState>(builder: (context, controller, child) {
      return GestureDetector(
        onTap: () {
          if (data?.fileType == FeedsFileType.image.value && data?.file != null) {
            context.pushNamed(Routs.imageOpener, extra: ImageOpener(networkImage: '${data?.file}'));
          } else if (data?.fileType == FeedsFileType.pdf.value && data?.file != null) {
            context.pushNamed(Routs.viewPdf,
                extra: PDFViewer(
                  pdfUrl: '${data?.file}',
                ));
          } else if (data?.file != null) {
            launchUrl(Uri.parse('${data?.file}'));
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: kPadding, horizontal: kPadding),
          margin: const EdgeInsets.symmetric(horizontal: kPadding, vertical: kPadding),
          decoration: BoxDecoration(
            gradient: blackGradient,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GradientButton(
                        borderRadius: 0,
                        padding: EdgeInsets.zero,
                        margin: const EdgeInsets.only(right: 8),
                        backgroundGradient: blackGradient,
                        child: const Center(
                          child: ImageView(
                            height: 30,
                            width: 30,
                            fit: BoxFit.contain,
                            assetImage: AppAssets.pdfIcon,
                            margin: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              data?.fileName ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Text(
                            data?.fileSize ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: null,
                    child: const Icon(CupertinoIcons.doc),
                  ),
                ],
              ),
              // DownloadScreen(url: data?.file, filename: data?.fileName)
            ],
          ),
        ),
      );
    });
  }
}

// ... other imports

class DownloadScreen extends StatefulWidget {
  final String? url;
  final String? filename;

  const DownloadScreen({Key? key, required this.url, required this.filename}) : super(key: key);

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  final downloadProvider = DownloadState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (downloadProvider.status == DownloadStatus.downloading)
            LinearProgressIndicator(
              value: downloadProvider.progress,
            ),
          if (downloadProvider.status == DownloadStatus.completed) const Text('Download completed!'),
          if (downloadProvider.status == DownloadStatus.failed)
            Text('Download failed: ${downloadProvider.errorMessage}'),
          ElevatedButton(
            onPressed: downloadProvider.status == DownloadStatus.idle
                ? () {
                    downloadProvider.startDownload(widget.url, widget.filename);
                    setState(() {});
                  }
                : null,
            child: Text(
              downloadProvider.status == DownloadStatus.idle ? 'Start Download' : 'Downloading...',
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    downloadProvider.removeListener(() => setState(() {}));
    super.dispose();
  }
}
