import 'package:flutter/material.dart';
import 'package:gaas/controllers/partner/product_controller.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/utils/widgets/data_widget_builder.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../core/constant/colors.dart';
import '../../../models/partner/product/inventory_card.dart';
import '../../../models/partner/product/my_products_model.dart';
import '../../../utils/widgets/custom_button.dart';

class PartnerInventory extends StatefulWidget {
  const PartnerInventory({Key? key, required this.id}) : super(key: key);
  final num? id;

  @override
  State<PartnerInventory> createState() => _PartnerInventoryState();
}

class _PartnerInventoryState extends State<PartnerInventory> {
  late num? id = widget.id;

  TextEditingController searchCtrl = TextEditingController();

  Future fetchMyProducts({bool? loadingNext}) async {
    ProductController productController = Provider.of<ProductController>(context, listen: false);
    return productController.fetchMyProducts(
      context: context,
      searchKey: searchCtrl.text,
      isRefresh: loadingNext == true ? null : true,
      loadingNext: loadingNext,
    );
  }

  List<MyProductsData>? myProductsData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      fetchMyProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    ProductController controller = Provider.of<ProductController>(context);
    myProductsData = controller.myProductsData;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventory"),
      ),
      body: SmartRefresher(
        key: widget.key,
        controller: controller.myProductsController,
        enablePullUp: true,
        enablePullDown: true,
        onRefresh: () async {
          if (mounted) {
            await fetchMyProducts();
          }
        },
        onLoading: () async {
          if (mounted) {
            await fetchMyProducts(loadingNext: true);
          }
        },
        child: DataWidgetBuilder(
          isLoading: controller.loadingMyProducts,
          haveData: myProductsData.haveData,
          child: ListView.builder(
            itemCount: myProductsData?.length,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              var data = myProductsData?.elementAt(index);
              return InventoryCard(
                index: index,
                data: data,
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: controller.inventoryHaveChanges()
          ? CustomButton(
              height: 45,
              text: "Update",
              backgroundColor: primaryColor,
              fontSize: 18,
              onPressed: () {
                update();
              },
              mainAxisAlignment: MainAxisAlignment.center,
              margin: const EdgeInsets.all(16),
            )
          : const SizedBox(),
    );
  }

  Future update() async {
    ProductController productController = Provider.of<ProductController>(context, listen: false);
    productController.updateInventory(context: context);
  }
}
