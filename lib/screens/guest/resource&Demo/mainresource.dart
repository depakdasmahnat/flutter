import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../../controllers/guest_controller/guest_controller.dart';
import '../../../core/config/app_assets.dart';
import '../../../core/route/route_paths.dart';
import '../../../utils/widgets/appbar.dart';
import '../product/guest_product.dart';

class Mainresource extends StatefulWidget {
  const Mainresource({super.key});

  @override
  State<Mainresource> createState() => _MainresourceState();
}

class _MainresourceState extends State<Mainresource> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.read<GuestControllers>().fetchCategoryLoader=false;
      await context.read<GuestControllers>().fetchInterestCategories(context: context, type: 'Resource');
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
            showLeadICon: false,
            title: 'Resources',
          )),
      body:  Consumer<GuestControllers>(
        builder: (context, controller, child) {
          return  controller.fetchCategoryLoader==false?const Center(
            child:   CupertinoActivityIndicator(
                animating: true,
                radius: 20, color: CupertinoColors.white),
          ) :
          GridView.count(
            crossAxisCount: 2,

            childAspectRatio: ((size.height - kToolbarHeight - 24) / (size.height - kToolbarHeight - 24) / 0.85),
            controller: ScrollController(keepScrollOffset: false),
            padding: const EdgeInsets.only(bottom: 100),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: List.generate(
              controller.fetchInterestCategory?.data?.length??0, (index) {
              return
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:  InkWell(
                      onTap: () {
                        context.push(Routs.resourceAndDemo,);
                      },
                      child:Container(
                        decoration:  const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(18))
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
                                // child: Image.network(controller.resourceModel?.data?[index].file??'',fit: BoxFit.cover,),
                                child: Image.asset(AppAssets.resources,fit: BoxFit.cover,),
                              ),
                              Text(
                                controller.fetchInterestCategory?.data?[index].name??'',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    height: 2
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      )),
                );
            },
            ),
          );
        },

      ),
    );
  }
}
