import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/controllers/member/member_controller/member_controller.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:provider/provider.dart';

import '../../core/constant/constant.dart';
import '../../core/route/route_paths.dart';
import '../../models/member/dashboard/traning_progress_model.dart';
import 'gradient_progress_bar.dart';

class TrainingProgress extends StatefulWidget {
  const TrainingProgress({super.key, this.title, this.onTap, this.margin});

  final String? title;

  final GestureTapCallback? onTap;
  final EdgeInsets? margin;

  @override
  State<TrainingProgress> createState() => _TrainingProgressState();
}

class _TrainingProgressState extends State<TrainingProgress> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<MembersController>().fetchTrainingProgress();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MembersController>(
      builder: (context, controller, child) {
        TrainingProgressModel? trainingProgress = controller.trainingProgress;
        double progress = (trainingProgress?.perc ?? 0).toDouble();

        return trainingProgress?.advanceEligible == true
            ? const SizedBox()
            : GestureDetector(
                onTap: widget.onTap ??
                    () {
                      context.pushNamed(Routs.trainingScreen);
                    },
                child: Container(
                  margin:
                      widget.margin ?? const EdgeInsets.only(top: kPadding, left: kPadding, right: kPadding),
                  padding: const EdgeInsets.only(left: kPadding, right: kPadding, top: 12, bottom: 12),
                  decoration: BoxDecoration(
                    gradient: darkGreyGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title ?? 'Complete Your Training Progress',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GradientProgressBar(
                        value: (progress / 100),
                        margin: const EdgeInsets.only(top: 12, bottom: 12),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Steps ${trainingProgress?.modules ?? ''}',
                            style: TextStyle(
                                color: Colors.grey.shade200, fontSize: 11, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            progress < 100 ? 'Complete your training' : 'Training Completed',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          Text(
                            '${(progress).toStringAsFixed(0)}%',
                            style: TextStyle(
                                color: Colors.grey.shade200, fontSize: 11, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
