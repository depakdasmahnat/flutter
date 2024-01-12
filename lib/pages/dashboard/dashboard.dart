import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/widgets/no_data_found.dart';
import '../../controllers/dashboard_controller.dart';

import '../dev/typography.dart';
import '../home/home_screen.dart';
import '../profile/settings.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key, this.dashBoardIndex}) : super(key: key);
  final int? dashBoardIndex;

  @override
  DashBoardState createState() => DashBoardState();
}

class DashBoardState extends State<DashBoard> {
  late int dashBoardIndex = widget.dashBoardIndex ?? 0;

  late List widgets = [
    const HomeScreen(),
    const TypographyScreen(),
    NoDataFound(buildContext: context),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<DashboardController>().changeDashBoardIndex(index: dashBoardIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    DashboardController mainScreenController = Provider.of<DashboardController>(context);
    dashBoardIndex = mainScreenController.dashBoardIndex;

    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return widgets.elementAt(dashBoardIndex);
      }),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: dashBoardIndex,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey.shade400,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.pencil_outline), label: 'Typography'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.chart_bar_alt_fill), label: 'Chart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          context.read<DashboardController>().changeDashBoardIndex(index: index);
        },
      ),
    );
  }
}
