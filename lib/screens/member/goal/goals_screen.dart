import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/controllers/member/member_auth_controller.dart';
import 'package:mrwebbeast/controllers/member/member_controller/member_controller.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/constant/enums.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/core/route/route_paths.dart';
import 'package:mrwebbeast/models/member/goals/goals_model.dart';
import 'package:mrwebbeast/screens/member/goal/partner_goals_screen.dart';
import 'package:mrwebbeast/utils/widgets/gradient_button.dart';
import 'package:mrwebbeast/utils/widgets/gradient_text.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../core/constant/gradients.dart';
import '../../../models/default/default_model.dart';
import '../../../utils/widgets/custom_back_button.dart';
import '../../../utils/widgets/image_view.dart';
import '../../../utils/widgets/loading_screen.dart';
import '../../../utils/widgets/no_data_found.dart';
import 'create_goal.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({
    super.key,
  });

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  TextEditingController searchController = TextEditingController();
  List<GoalsData>? goals;
  List<GoalsData>? partnerGoals;

  Future fetchGoals({bool? loadingNext}) async {
    return await context.read<MembersController>().fetchGoals(
          context: context,
          isRefresh: loadingNext == true ? false : true,
          loadingNext: loadingNext ?? false,
          searchKey: searchController.text,
        );
  }

  Future fetchPartnerGoals({bool? loadingNext}) async {
    return await context.read<MembersController>().fetchPartnerGoals(
          context: context,
          isRefresh: loadingNext == true ? false : true,
          loadingNext: loadingNext ?? false,
          searchKey: searchController.text,
        );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchGoals();
      fetchPartnerGoals();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<MembersController>(builder: (context, controller, child) {
      goals = controller.goals;
      partnerGoals = controller.partnerGoals;
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: const CustomBackButton(),
          title: const Text('Goals'),
        ),
        body: SmartRefresher(
          controller: controller.goalsController,
          enablePullUp: true,
          enablePullDown: true,
          onRefresh: () async {
            if (mounted) {
              await fetchGoals();
            }
          },
          onLoading: () async {
            if (mounted) {
              await fetchGoals(loadingNext: true);
            }
          },
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: kPadding, right: kPadding, bottom: kPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'My Partners Goals',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.pushNamed(Routs.partnerGoals);
                      },
                      child: const Text(
                        'See more',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (controller.loadingPartnerGoals)
                const LoadingScreen(
                  heightFactor: 0.3,
                  message: 'Loading Goals...',
                )
              else if (partnerGoals.haveData)
                SizedBox(
                  height: 240,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: partnerGoals?.length ?? 0,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: kPadding),
                    // physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var data = partnerGoals?.elementAt(index);
                      return GestureDetector(
                        onTap: () {
                          // context.pushNamed(Routs.productDetail);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: HorizontalGoalCard(
                            index: index,
                            goal: data,
                          ),
                        ),
                      );
                    },
                  ),
                )
              else
                NoDataFound(
                  heightFactor: 0.3,
                  message: controller.goalsModel?.message ?? 'No Goals Found',
                ),
              const Padding(
                padding: EdgeInsets.only(left: kPadding, right: kPadding, bottom: kPadding, top: kPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Goals',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (controller.loadingGoals)
                const LoadingScreen(
                  heightFactor: 0.5,
                  message: 'Loading Goals...',
                )
              else if (goals.haveData)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: goals?.length ?? 0,
                  padding: const EdgeInsets.only(bottom: bottomNavbarSize),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    var data = goals?.elementAt(index);
                    return GestureDetector(
                      onTap: () {
                        // context.pushNamed(Routs.productDetail);
                      },
                      child: GoalCard(
                        index: index,
                        goal: data,
                      ),
                    );
                  },
                )
              else
                NoDataFound(
                  heightFactor: 0.5,
                  message: controller.goalsModel?.message ?? 'No Goals Found',
                ),
            ],
          ),
        ),
        bottomSheet: GradientButton(
          height: 60,
          backgroundGradient: primaryGradient,
          margin: const EdgeInsets.symmetric(horizontal: kPadding, vertical: 8),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Add a new goal',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          onTap: () {
            context.pushNamed(Routs.createGoal);
          },
        ),
      );
    });
  }
}

class GoalCard extends StatelessWidget {
  final double? imageHeight;
  final BoxFit? fit;

  final int index;

  final GoalsData? goal;

  const GoalCard({
    super.key,
    this.imageHeight,
    this.fit,
    required this.index,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: kPadding, right: kPadding, bottom: kPadding),
      decoration: BoxDecoration(
        gradient: feedsCardGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: ImageView(
                height: imageHeight,
                borderRadiusValue: 10,
                margin: EdgeInsets.zero,
                fit: BoxFit.cover,
                networkImage: '${goal?.image}',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      goal?.name ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    if (goal?.edited == 'Yes')
                      GradientText(
                        'Changed',
                        gradient: primaryGradient,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          overflow: TextOverflow.ellipsis,
                          fontFamily: GoogleFonts.urbanist().fontFamily,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        textAlign: TextAlign.start,
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 4),
                  child: Text(
                    goal?.description ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      FeedMenu(
                        icon: AppAssets.eventIcon,
                        value: goal?.startDate ?? '',
                      ),
                      FeedMenu(
                        icon: AppAssets.membersIcon,
                        value: goal?.type ?? '',
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    mainAxisAlignment: goal?.completionDate.toString() == 'null'
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.spaceBetween,
                    children: [
                      if (goal?.completionDate.toString() != 'null')
                        Text(
                          'Completion Date: ${goal?.completionDate ?? ' '}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      GestureDetector(
                        onTap: () {
                          context
                              .pushNamed(Routs.createGoal,
                                  extra: CreateGoal(
                                    goalId: '${goal?.id}',
                                    type: 'Edit',
                                  ))
                              .whenComplete(
                            () async {
                              await context.read<MembersController>().fetchGoals(
                                    context: context,
                                    isRefresh: true,
                                    loadingNext: false,
                                    searchKey: '',
                                  );
                            },
                          );
                        },
                        child: const Row(
                          children: [
                            ImageView(
                              height: 14,
                              width: 14,
                              assetImage: AppAssets.edit,
                              onTap: null,
                              margin: EdgeInsets.only(right: 4),
                            ),
                            Text(
                              'Edit',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                GradientButton(
                  height: 40,
                  borderRadius: 50,
                  onTap: () {
                    if (goal?.status == 'Pending') {
                      context.read<MemberAuthControllers>().confirmationPopup(
                            context: context,
                            title: 'Are you sure, you have achieved this goal!',
                            onPressed: () async {
                              DefaultModel? model = await context
                                  .read<MembersController>()
                                  .achieveGoal(context: context, goalId: goal?.id);
                              if (model?.status == true) {
                                context.pop();
                              }
                            },
                          );
                    }
                  },
                  backgroundGradient: goal?.status == 'Pending' ? inActiveGradient : whiteGradient,
                  margin: const EdgeInsets.symmetric(vertical: kPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${goal?.status}',
                        style: TextStyle(
                            // color: goal?.status == GoalStatus.achieved.value ? Colors.white : Colors.black),
                            color: goal?.status == 'Pending' ? Colors.white : Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class FeedMenu extends StatelessWidget {
  const FeedMenu({
    super.key,
    required this.icon,
    this.value,
    this.onTap,
    this.lastMenu,
  });

  final String icon;
  final String? value;
  final bool? lastMenu;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: lastMenu != true ? kPadding : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ImageView(
            height: 12,
            width: 12,
            borderRadiusValue: 0,
            color: Colors.white,
            margin: const EdgeInsets.only(right: 4),
            fit: BoxFit.contain,
            onTap: onTap,
            assetImage: icon,
          ),
          if (value != null)
            Text(
              '$value',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.start,
            ),
        ],
      ),
    );
  }
}
