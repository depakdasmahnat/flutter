import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/controllers/member/member_controller/member_controller.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/core/route/route_paths.dart';
import 'package:mrwebbeast/models/member/goals/goals_model.dart';
import 'package:mrwebbeast/screens/guest/guest_check_demo/guest_check_demo_step2.dart';
import 'package:mrwebbeast/utils/widgets/gradient_button.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../core/constant/gradients.dart';

import '../../../utils/widgets/custom_back_button.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/image_view.dart';
import '../../../utils/widgets/loading_screen.dart';
import '../../../utils/widgets/no_data_found.dart';

import '../home/member_profile_details.dart';


class PartnerGoalsScreen extends StatefulWidget {
  const PartnerGoalsScreen({
    super.key,
  });

  @override
  State<PartnerGoalsScreen> createState() => _PartnerGoalsScreenState();
}

class _PartnerGoalsScreenState extends State<PartnerGoalsScreen> {
  TextEditingController searchController = TextEditingController();
  List<GoalsData>? goals;
  String downLineRank = '';
  String filterByStatus = '';

  Future fetchGoals({bool? loadingNext}) async {
    return await context.read<MembersController>().fetchPartnerGoals(
        context: context,
        isRefresh: loadingNext == true ? false : true,
        loadingNext: loadingNext ?? false,
        searchKey: searchController.text,
        filter: filter,
        filterByRank: downLineRank,
        filterByStatus: filterByStatus);
  }

  String? filter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      fetchGoals();
      await context.read<MembersController>().fetchDownLineRank(
            context: context,
        userId: ''
          );
    });
  }

  Timer? _debounce;

  void onSearchFieldChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchGoals();

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<MembersController>(builder: (context, controller, child) {
      goals = controller.partnerGoals;
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: const CustomBackButton(),
          title: const Text('My Partners Goals'),
        ),
        body: SmartRefresher(
          controller: controller.partnerGoalsController,
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
                    fetchGoals();
                  },
                ),
                onChanged: (val) {
                  onSearchFieldChanged(val);
                },
                onEditingComplete: () {
                  fetchGoals();
                },
                margin:
                    const EdgeInsets.only(left: kPadding, right: kPadding, bottom: kPadding, top: kPadding),
              ),
              Padding(
                padding: const EdgeInsets.only(left: kPadding, right: kPadding, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Consumer<MembersController>(
                      builder: (context, controller, child) {
                        return Container(
                          width: 100,
                          height: size.height * 0.04,
                          padding: const EdgeInsets.only(left: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: inActiveGradient,
                          ),
                          child: Center(
                            child: DropdownSearch<String>(

                              dropdownButtonProps: const DropdownButtonProps(
                                  // padding: EdgeInsets.only(bottom: 10),
                                  icon: Icon(
                                CupertinoIcons.chevron_down,
                                size: 14,
                              )),
                              // selectedItem: selectedItem,

                              popupProps: const PopupProps.menu(
                                menuProps: MenuProps(
                                  backgroundColor: Color(0xFF1B1B1B),
                                ),
                                fit: FlexFit.loose,
                                // showSelectedItems: true,
                              ),

                              items: controller.fetchDownlineRan?.data ?? [],
                              dropdownDecoratorProps: const DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 0, top: 8),
                                  border: InputBorder.none,
                                  hintText: 'Rank',
                                  hintStyle: TextStyle(),
                                  isDense: true,
                                  isCollapsed: true,
                                ),
                              ),
                              onChanged: (value) async {
                                downLineRank = value ?? '';
                                setState(() {});
                                await fetchGoals();
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    GestureDetector(
                      onTap: () async {
                        filterByStatus = 'Achieved';
                        setState(() {});
                        await fetchGoals();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: filterByStatus == 'Achieved' ? primaryGradient : inActiveGradient),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 8.0, bottom: 8, left: kPadding, right: kPadding),
                          child: Center(
                            child: CustomText1(
                              text: 'Achieved',
                              fontSize: 14,
                              color: filterByStatus == 'Achieved' ? Colors.black : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        filterByStatus = 'Pending';
                        setState(() {});
                        await fetchGoals();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: filterByStatus == 'Pending' ? primaryGradient : inActiveGradient),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 8.0, bottom: 8, left: kPadding, right: kPadding),
                          child: Center(
                            child: CustomText1(
                              text: 'Pending',
                              fontSize: 14,
                              color: filterByStatus == 'Pending' ? Colors.black : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (controller.loadingPartnerGoals)
                const LoadingScreen(
                  heightFactor: 0.5,
                  message: 'Loading Goals...',
                )
              else if (goals.haveData)
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: goals?.length ?? 0,
                  padding: const EdgeInsets.only(bottom: bottomNavbarSize, left: kPadding, right: kPadding),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    var data = goals?.elementAt(index);
                    return GestureDetector(
                      onTap: () {
                        // context.pushNamed(Routs.productDetail);
                      },
                      child: HorizontalGoalCard(
                        index: index,
                        goal: data,
                      ),
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 0.8, mainAxisSpacing: 16, crossAxisSpacing: 16),
                )
              else
                NoDataFound(
                  heightFactor: 0.5,
                  message: controller.partnerGoalsModel?.message ?? 'No Goals Found',
                ),
            ],
          ),
        ),
      );
    });
  }
}

class HorizontalGoalCard extends StatelessWidget {
  final double? imageHeight;
  final BoxFit? fit;

  final int index;

  final GoalsData? goal;

  const HorizontalGoalCard({
    super.key,
    this.imageHeight,
    this.fit,
    required this.index,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        gradient: feedsCardGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Expanded(
            child: ImageView(
              width: 200,
              borderRadiusValue: 10,
              margin: const EdgeInsets.all(10),
              fit: BoxFit.cover,
              networkImage: '${goal?.image}',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        lastMenu: true,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'Completion date: ${goal?.endDate ?? ''}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          context.pushNamed(Routs.memberProfileDetails,
                              extra: MemberProfileDetails(memberId: '${goal?.memberId}'));
                        },
                        child: Row(
                          children: [
                            ImageView(
                              height: 28,
                              width: 28,
                              borderRadiusValue: 50,
                              networkImage: '${goal?.profilePic}',
                              fit: BoxFit.cover,
                              isAvatar: true,
                              margin: const EdgeInsets.only(right: 8),
                            ),
                            Flexible(
                              child: Text(
                                goal?.partnerName ?? '',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GradientButton(
                      height: 18,
                      borderRadius: 50,
                      backgroundGradient: whiteGradient,
                      margin: const EdgeInsets.symmetric(vertical: kPadding),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${goal?.status}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
            height: 10,
            width: 10,
            borderRadiusValue: 0,
            color: Colors.white,
            margin: const EdgeInsets.only(right: 2),
            fit: BoxFit.contain,
            onTap: onTap,
            assetImage: icon,
          ),
          if (value != null)
            Text(
              '$value',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.start,
            ),
        ],
      ),
    );
  }
}
