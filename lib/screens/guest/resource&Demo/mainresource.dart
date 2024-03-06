import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/screens/guest/resource&Demo/resource_and_demo.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import 'package:mrwebbeast/utils/widgets/loading_screen.dart';
import 'package:mrwebbeast/utils/widgets/no_data_found.dart';
import 'package:provider/provider.dart';

import '../../../controllers/guest_controller/guest_controller.dart';
import '../../../core/route/route_paths.dart';
import '../../../models/auth_model/fetchinterestcategory.dart';

class MainResource extends StatefulWidget {
  const MainResource({super.key});

  @override
  State<MainResource> createState() => _MainResourceState();
}

class _MainResourceState extends State<MainResource> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<GuestControllers>().fetchInterestCategories(context: context, type: 'Resource');
    });
    super.initState();
  }

  List<ResourceCategoryData>? categories;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Bank'),
      ),
      body: Consumer<GuestControllers>(
        builder: (context, controller, child) {
          categories = controller.fetchInterestCategory?.data;
          return controller.fetchCategoryLoader == true
              ? const LoadingScreen(message: 'Loading Resources...')
              : (categories.haveData)
                  ? GridView.builder(
                      itemCount: categories?.length ?? 0,
                      controller: ScrollController(keepScrollOffset: false),
                      padding: const EdgeInsets.only(bottom: 100),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: ((size.height - kToolbarHeight - 24) /
                            (size.height - kToolbarHeight - 24) /
                            0.85),
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        var data = categories?[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                              onTap: () {
                                context.push(Routs.resourceAndDemo, extra: ResourceAndDemo(category: data));
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(18))),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: ImageView(
                                          width: 172,
                                          borderRadiusValue: 10,
                                          networkImage: '${data?.path}',
                                          fit: BoxFit.cover,
                                          margin: const EdgeInsets.all(6),
                                        ),
                                      ),
                                      Text(
                                        data?.name ?? '',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            height: 2),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        );
                      },
                    )
                  : const NoDataFound(message: 'No Resources Found');
        },
      ),
    );
  }
}
