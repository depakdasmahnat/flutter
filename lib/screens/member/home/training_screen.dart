import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_assets.dart';
import '../../../core/constant/constant.dart';
import '../../../core/route/route_paths.dart';
import '../../../guest/home/home_screen.dart';
import '../../../models/dashboard/dashboard_data.dart';
import '../../../utils/widgets/appbar.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../../../utils/widgets/gradient_progress_bar.dart';
import '../../../utils/widgets/image_view.dart';
import '../../../utils/widgets/no_data_found.dart';
import '../../dashboard/dashboard.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  List item = [
    {'image': AppAssets.resources, 'title': 'Business Images'},
    {'image': AppAssets.pdf, 'title': 'Business Images'},
    {'image': AppAssets.pdf, 'title': 'Demo Video'},
    {'image': AppAssets.pdf, 'title': 'Trainings PDFs'}
  ];

  double? trainingProgress = 75;
  final List<DashboardData> bottomNabBarItems = [
    DashboardData(
      title: 'Basic',
      activeImage: AppAssets.feedsIcon,
      inActiveImage: AppAssets.feedsIcon,
      widget: const HomeScreen(),
    ),
    DashboardData(
      title: 'Advance',
      activeImage: AppAssets.membersFilledIcon,
      inActiveImage: AppAssets.membersIcon,
      widget: const NoDataFound(),
    ),
  ];

  int dashBoardIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Training'),
      ),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GradientButton(
                width: size.width * 0.7,
                borderRadius: 50,
                blur: 15,
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                // backgroundGradient: inActiveGradientTransparent,
                backgroundColor: Colors.white.withOpacity(0.15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    bottomNabBarItems.length,
                    (index) {
                      var data = bottomNabBarItems.elementAt(index);
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: CustomBottomNavBar(
                            index: index,
                            dashBoardIndex: dashBoardIndex,
                            data: data,
                            height: 50,
                            alwaysShowLabel: true,
                            width: size.width,
                            onTap: () {
                              dashBoardIndex = index;
                              setState(() {});
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 8, left: kPadding, right: kPadding, bottom: 8),
            padding: const EdgeInsets.only(left: kPadding, right: kPadding, top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Basic Training Progress',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GradientProgressBar(
                  value: (trainingProgress ?? 0) > 0 ? (trainingProgress! / 100) : 0,
                  backgroundColor: Colors.grey.shade300,
                  margin: const EdgeInsets.only(top: 8, bottom: 8),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Steps 35/60',
                      style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w500),
                    ),
                    const Text(
                      'Compete your training',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    Text(
                      '${(trainingProgress ?? 0).toStringAsFixed(0)}%',
                      style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const CustomTextField(
            hintText: 'Search',
            readOnly: true,
            hintStyle: TextStyle(color: Colors.white),
            prefixIcon: ImageView(
              height: 20,
              width: 20,
              borderRadiusValue: 0,
              color: Colors.white,
              margin: EdgeInsets.only(left: kPadding, right: kPadding),
              fit: BoxFit.contain,
              assetImage: AppAssets.searchIcon,
            ),
            margin: EdgeInsets.only(left: kPadding, right: kPadding, top: kPadding, bottom: kPadding),
          ),
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: kPadding, right: kPadding, bottom: kPadding),
                child: Text(
                  'Explore Categories',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio:
                ((size.height - kToolbarHeight - 24) / (size.height - kToolbarHeight - 24) / 0.85),
            controller: ScrollController(keepScrollOffset: false),
            padding: const EdgeInsets.only(bottom: 100, left: 16, right: 16, top: 8),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: List.generate(
              item.length,
              (index) {
                return InkWell(
                    onTap: () {
                      context.push(Routs.resourceAndDemo);
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(18))
                          // image: DecorationImage(
                          //   image: AssetImage(AppAssets.geustProduct,),
                          //       fit: BoxFit.contain
                          // )
                          ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: Image.asset(
                                item[index]['image'],
                                fit: BoxFit.cover,
                              ),
                            ),
                            Text(
                              item[index]['title'],
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500, height: 2),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
