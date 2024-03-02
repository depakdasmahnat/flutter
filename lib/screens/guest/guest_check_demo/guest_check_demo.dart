import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/guest_controller/guest_controller.dart';
import '../../../utils/widgets/appbar.dart';
import '../../../utils/widgets/loading_screen.dart';
import '../../member/feeds/feeds_card.dart';

class GuestCheckDemo extends StatefulWidget {
  const GuestCheckDemo({super.key});

  @override
  State<GuestCheckDemo> createState() => _GuestCheckDemoState();
}

class _GuestCheckDemoState extends State<GuestCheckDemo> {
  Future fetchResourcesDetail({bool? loadingNext}) async {
    return await context.read<GuestControllers>().fetchGuestDemo(context: context);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      fetchResourcesDetail();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(size.height * 0.06),
          child: CustomAppBar(
            showLeadICon: true,
            title: 'Demo Videos',
          )),
      body: Consumer<GuestControllers>(
        builder: (context, controller, child) {
          return controller.guestDemoLoader==false?const LoadingScreen(heightFactor: 0.7):
          ListView.builder(
            shrinkWrap: true,
            itemCount: controller.guestDemoModel?.data?.length??0,
            itemBuilder: (context, index) {
              var data = controller.guestDemoModel?.data?.elementAt(index);
              return FeedCardForDemo(
                index: index,
                data: data,
                // isFeeds: false,
              );
            },);
        },
      ),
    );
  }
}
