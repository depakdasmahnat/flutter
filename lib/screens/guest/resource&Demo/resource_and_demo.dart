import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:provider/provider.dart';

import '../../../controllers/guest_controller/guest_controller.dart';
import '../../../core/constant/constant.dart';
import '../../../core/constant/gradients.dart';
import '../../../core/route/route_paths.dart';
import '../../../utils/widgets/appbar.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/image_view.dart';
import '../home/home_screen.dart';

class RecourceAndDemo extends StatefulWidget {
  String? type;
   RecourceAndDemo({super.key,this.type});
  @override
  State<RecourceAndDemo> createState() => _RecourceAndDemoState();
}

class _RecourceAndDemoState extends State<RecourceAndDemo> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.read<GuestControllers>().resourcesDetailLoader=false;
      await context.read<GuestControllers>().fetchResourcesDetail(context: context, page: '1');
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(size.height * 0.18),
          child: CustomAppBar(
            showLeadICon: true,
            title: widget.type=='true'?'Demo Video':'Resources',
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(size.height * 0.06), child: const CustomTextField(
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
            ),
          )

      ),
      body: Consumer<GuestControllers>(
      builder: (context, controller, child) {
        return controller.resourcesDetailLoader==false?const Center(
          child:   CupertinoActivityIndicator(
              animating: true,
              radius: 20, color: CupertinoColors.white),
        )  : ListView.builder(
          itemCount:controller.fetchResourcesDetailModel?.data?.length??0,
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: kPadding),
          // physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  // if(widget.type!='true'){
                  //   context.pushNamed(Routs.resourceAndDemo,extra:true );
                  // }

                },
                child: FeedCard(
                  index: index,
                  type: 'true',
                  networkImage: controller.fetchResourcesDetailModel?.data?[index].file,
                  imageHeight: size.height*0.3,
                  fit: BoxFit.cover,));
          },
        );
      },

      ),
    );
  }
}

