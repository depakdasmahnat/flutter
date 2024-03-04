import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/controllers/member/training/training_controller.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/screens/member/training/chapters_screen.dart';
import 'package:mrwebbeast/utils/widgets/custom_back_button.dart';
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
import '../../../utils/widgets/training_progress.dart';
import '../../dashboard/dashboard.dart';
import '../../guest/home/home_screen.dart';
import '../home/member_dashboard.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  TextEditingController searchController = TextEditingController();

  List<TrainingCategoryData>? trainingCategories;

  Future fetchTrainings({bool? loadingNext}) async {
    return await context.read<TrainingControllers>().fetchTrainings(
          basic: tabIndex == 0,
          search: searchController.text,
        );
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
      activeImage: AppAssets.feedsFilledIcon,
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
  Timer? _debounce;

  void onSearchFieldChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchTrainings();

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<TrainingControllers>(
      builder: (context, controller, child) {
        trainingCategories = controller.trainingCategories;
        return Scaffold(
          appBar: AppBar(
            leading: const Column(
              children: [
                CustomBackButton(),
              ],
            ),
            title: const Text('Training'),
          ),
          body: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GradientButton(
                    width: size.width * 0.75,
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
                              child: CustomTabBar(
                                index: index,
                                dashBoardIndex: tabIndex,
                                data: data,
                                height: 50,
                                alwaysShowLabel: true,
                                width: size.width,
                                onTap: () {
                                  tabIndex = index;
                                  setState(() {});
                                  fetchTrainings();
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
              TrainingProgress(
                onTap: () {},
              ),
              CustomTextField(
                hintText: 'Search',
                controller: searchController,
                hintStyle: const TextStyle(color: Colors.white),
                prefixIcon: ImageView(
                  height: 20,
                  width: 20,
                  borderRadiusValue: 0,
                  color: Colors.white,
                  margin: const EdgeInsets.only(left: kPadding, right: kPadding),
                  fit: BoxFit.contain,
                  assetImage: AppAssets.searchIcon,
                  onTap: () {
                    fetchTrainings();
                  },
                ),
                onChanged: (val) {
                  onSearchFieldChanged(val);
                },
                onEditingComplete: () {
                  fetchTrainings();
                },
                margin:
                    const EdgeInsets.only(left: kPadding, right: kPadding, top: kPadding, bottom: kPadding),
              ),
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: kPadding, right: kPadding, bottom: kPadding),
                    child: Text(
                      'Explore Categories',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                            decoration: BoxDecoration(
                              gradient: blackGradient,
                              borderRadius: const BorderRadius.all(
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
                                      backgroundColor: Colors.grey.shade800.withOpacity(0.6),
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
                                          color: Colors.white,
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
