import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/core/route/route_paths.dart';
import 'package:mrwebbeast/screens/member/network/network_pinnacle_list.dart';
import 'package:mrwebbeast/screens/member/network/network_pinnacle_view.dart';
import 'package:mrwebbeast/screens/member/network/network_projection.dart';
import 'package:mrwebbeast/screens/member/network/network_tree_view.dart';
import 'package:mrwebbeast/utils/widgets/gradient_button.dart';

import '../../../models/dashboard/custom_tab_data.dart';

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> tabs;

  const CustomTabBar({super.key, required this.tabs});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black, // Customize the background color as needed
      child: TabBar(
        tabs: tabs,
        labelColor: Colors.white, // Customize the selected tab text color
        unselectedLabelColor: Colors.grey, // Customize the unselected tab text color
      ),
    );
  }
}

class CustomTabBarView extends StatelessWidget {
  final List<Widget> tabViews;

  const CustomTabBarView({super.key, required this.tabViews});

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: tabViews,
    );
  }
}

class NetworkScreen extends StatefulWidget {
  const NetworkScreen({super.key});

  @override
  State<NetworkScreen> createState() => _NetworkScreenState();
}

class _NetworkScreenState extends State<NetworkScreen> {
  PageController pageController = PageController();

  List<CustomTabData> tabs = [
    CustomTabData(id: 0, title: 'Tree View', tab: const NetworkTreeView()),
    CustomTabData(id: 1, title: 'Pinnacle View', tab: const NetworkPinnacleView()),
    CustomTabData(id: 2, title: 'Pinnacle List', tab: const NetworkPinnacleList()),
    CustomTabData(id: 3, title: 'Projection', tab: const NetworkProjection()),
  ];

  late CustomTabData currentTab = tabs.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network'),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: kPadding,right: kPadding,top: 12,bottom: 12),
            decoration: BoxDecoration(
              gradient: inActiveGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: tabs.map(
                (e) {
                  bool isSelected = currentTab.id == e.id;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        currentTab = e;
                        pageController.jumpToPage(currentTab.id);
                        setState(() {});
                      },
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: isSelected ? primaryGradient : null,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            e.title,
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected ? Colors.black : Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: pageController,
              itemCount: tabs.length,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                changeTab(index);
              },
              itemBuilder: (BuildContext context, int index) {
                var widget = tabs.elementAt(index).tab;

                return widget;
              },
            ),
          ),
        ],
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.only(bottom: 90),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GradientButton(
              height: 50,
              width: 120,
              borderRadius: 18,
              backgroundGradient: primaryGradient,
              onTap: null,
              margin: const EdgeInsets.symmetric(horizontal: kPadding, vertical: 8),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Print',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GradientButton(
              height: 50,
              width: 120,
              borderRadius: 18,
              backgroundGradient: whiteGradient,
              margin: const EdgeInsets.symmetric(horizontal: kPadding, vertical: 8),
              onTap: () {
                context.pushNamed(Routs.networkReport);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Report',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void changeTab(index) {
    currentTab = tabs.elementAt(index);
    setState(() {});
  }
}
