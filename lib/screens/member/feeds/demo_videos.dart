import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/utils/widgets/gradient_button.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';

class DemoVideos extends StatefulWidget {
  const DemoVideos({super.key});

  @override
  State<DemoVideos> createState() => _DemoVideosState();
}

class _DemoVideosState extends State<DemoVideos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Demo Videos',
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: kPadding, right: kPadding, bottom: kPadding),
                child: Text(
                  'Phase 01',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          ListView.builder(
            itemCount: 10,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: kPadding,
                  vertical: 8,
                ),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                child: ListTile(
                  leading: GradientButton(
                    height: 50,
                    width: 50,
                    borderRadius: 30,
                    backgroundGradient: primaryGradient,
                    child: const ImageView(
                      height: 16,
                      width: 16,
                      fit: BoxFit.contain,
                      assetImage: AppAssets.playIcon,
                    ),
                  ),
                  title: Text(
                    'Chapter ${index + 1}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  subtitle: Text(
                    'Chapter ${index + 1}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  trailing: GradientButton(
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
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
