import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/utils/widgets/no_data_found.dart';
import 'package:provider/provider.dart';

import '../../../controllers/guest_controller/guest_controller.dart';
import '../../../core/config/app_assets.dart';
import '../../../core/constant/constant.dart';
import '../../../core/constant/gradients.dart';
import '../../../core/route/route_paths.dart';
import '../../../models/auth_model/fetchinterestcategory.dart';
import '../../../models/guest_Model/fetchguestproduct.dart';
import '../../../utils/widgets/custom_back_button.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/image_view.dart';
import '../../../utils/widgets/loading_screen.dart';
import '../../guest/product/guest_product_details.dart';
import '../../guest/resource&Demo/resource_and_demo.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  List item = [
    {'image': AppAssets.resources, 'title': 'Business Images'},
    {'image': AppAssets.pdf, 'title': 'Business Images'},
    {'image': AppAssets.pdf, 'title': 'Demo Video'},
    {'image': AppAssets.pdf, 'title': 'Trainings PDFs'}
  ];

  double? trainingProgress = 75;
  TextEditingController searchController = TextEditingController();
  int dashBoardIndex = 0;
  Fetchguestproduct? fetchGuestProduct;

  Future fetchProduct({bool? loadingNext}) async {
    return await context.read<GuestControllers>().fetchProduct(
          context: context,
          page: '1',
        );
  }

  Future fetchCategories({bool? loadingNext}) async {
    return context.read<GuestControllers>().fetchInterestCategories(context: context, type: 'Resource');
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      fetchCategories();
      fetchProduct();
    });
    super.initState();
  }

  List<ResourceCategoryData>? categories;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<GuestControllers>(builder: (context, controller, child) {
      fetchGuestProduct = controller.fetchguestProduct;

      return Scaffold(
        appBar: AppBar(
          leading: const Column(
            children: [
              CustomBackButton(),
            ],
          ),
          title: const Text('Library'),
        ),
        body: ListView(
          children: [
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: kPadding, right: kPadding, bottom: kPadding),
                  child: Text(
                    'Products',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            if (fetchGuestProduct?.data.haveData == true)
              SizedBox(
                height: 250,
                child: ListView.builder(
                  itemCount: fetchGuestProduct?.data?.length ?? 0,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(left: kPadding),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    var data = fetchGuestProduct?.data?.elementAt(index);

                    return ProductCard(
                      index: index,
                      data: data,
                      controller: controller,
                    );
                  },
                ),
              ),

            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: kPadding, right: kPadding, bottom: 8, top: kPadding),
                  child: Text(
                    'Categories',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            Consumer<GuestControllers>(
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
                                      context.push(Routs.resourceAndDemo,
                                          extra: ResourceAndDemo(category: data));
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
                                                '${data?.name}',
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
                                    )),
                              );
                            },
                          )
                        : const NoDataFound(message: 'No Resources Found');
              },
            )
          ],
        ),
      );
    });
  }
}

class ProductCard extends StatelessWidget {
  final int index;
  final Data? data;
  final GuestControllers? controller;

  const ProductCard({
    required this.index,
    super.key,
    this.data,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        context.push(Routs.guestProductDetail,
            extra: GusetProductDetails(
              productId: controller?.fetchguestProduct?.data?[index].id.toString() ?? '',
            ));
      },
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: kPadding),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(22)),
          gradient: index == 0 ? primaryGradient : blackGradient,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ImageView(
                  networkImage: '${data?.productImage}',
                  margin: EdgeInsets.zero,
                  borderRadiusValue: 16,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '${data?.name}',
                  style: TextStyle(
                    color: index == 0 ? Colors.black : Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '₹ ${data?.price}/',
                      style: TextStyle(
                        color: index == 0 ? Colors.black : Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Unit',
                      style: TextStyle(
                        color: index == 0 ? Colors.black : Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
