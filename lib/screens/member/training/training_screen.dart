import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/controllers/member/training/training_controller.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/screens/member/training/chapters_screen.dart';
import 'package:provider/provider.dart';

import '../../../core/config/app_assets.dart';
import '../../../core/constant/constant.dart';
import '../../../core/route/route_paths.dart';
import '../../../models/dashboard/dashboard_data.dart';
import '../../../models/member/training/training_categories_model.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../../../utils/widgets/gradient_progress_bar.dart';
import '../../../utils/widgets/image_view.dart';
import '../../../utils/widgets/loading_screen.dart';
import '../../../utils/widgets/no_data_found.dart';
import '../../dashboard/dashboard.dart';
import '../../guest/home/home_screen.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  TextEditingController searchController = TextEditingController();

  List<TrainingCategoryData>? trainingCategories;

  Future fetchTrainings({bool? loadingNext}) async {
    return await context.read<TrainingControllers>().fetchTrainings(basic: tabIndex == 0);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchTrainings();
    });
  }

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

  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<TrainingControllers>(
      builder: (context, controller, child) {
        trainingCategories = controller.trainingCategories;
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
                    width: size.width * 0.8,
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
                                dashBoardIndex: tabIndex,
                                data: data,
                                height: 50,
                                alwaysShowLabel: true,
                                width: size.width,
                                onTap: () {
                                  tabIndex = index;
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
                          style:
                              const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w500),
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
              if (controller.loadingTrainingCategories)
                const LoadingScreen(
                  heightFactor: 0.7,
                  message: 'Loading Trainings...',
                )
              else if (trainingCategories.haveData)
                GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1,
                  controller: ScrollController(keepScrollOffset: false),
                  padding: const EdgeInsets.only(bottom: 100, left: 16, right: 16, top: 8),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: List.generate(
                    trainingCategories?.length ?? 0,
                    (index) {
                      var data = trainingCategories?.elementAt(index);
                      return InkWell(
                          onTap: () {
                            context.push(Routs.chapters, extra: ChaptersScreen(category: data));
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(18),
                              ),
                            ),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: ImageView(
                                      networkImage: '${data?.image}',
                                      backgroundColor: Colors.grey.shade200,
                                      fit: BoxFit.cover,
                                      borderRadiusValue: 12,
                                      margin: const EdgeInsets.only(top: 12, left: 12, right: 12),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
                                    child: Text(
                                      '${data?.subCategoryName}',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          height: 2),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                    },
                  ),
                )
              else
                NoDataFound(
                  heightFactor: 0.7,
                  message: controller.trainingCategoriesModel?.message ?? 'No Feeds Found',
                ),
            ],
          ),
        );
      },
    );
  }
}
