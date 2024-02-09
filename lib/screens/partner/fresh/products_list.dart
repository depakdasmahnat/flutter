import 'package:flutter/material.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/screens/partner/fresh/product_category_picker.dart';
import 'package:gaas/utils/widgets/loading_screen.dart';
import 'package:gaas/utils/widgets/no_data_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../controllers/dashboard_controller.dart';
import '../../../controllers/partner/product_controller.dart';
import '../../../core/config/app_images.dart';
import '../../../core/constant/colors.dart';
import '../../../models/partner/category_model.dart';
import '../../../models/partner/product/product_templates_model.dart';
import '../../../route/route_paths.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/image_view.dart';
import '../../map/utils/location_radius_picker.dart';
import '../utils/product_info.dart';
import 'add_product.dart';

class ProductsList extends StatefulWidget {
  const ProductsList({Key? key}) : super(key: key);

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  TextEditingController searchCtrl = TextEditingController();
  List<ProductTemplatesData>? productTemplateData;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchProductTemplates();
    });
    super.initState();
  }

  fetchProductTemplates() {
    ProductController controller = Provider.of<ProductController>(context, listen: false);

    controller.fetchProductTemplates(
      context: context,
      searchKey: searchCtrl.text,
      categoryId: selectedCategory?.id,
    );
  }

  setLocationRange({CategoryData? range}) {
    if (range != null) {
      selectedCategory = range;
      setState(() {});
      fetchProductTemplates();
    }
  }

  CategoryData? selectedCategory;

  List<CategoryData>? categoryData;

  @override
  Widget build(BuildContext context) {
    ProductController controller = Provider.of<ProductController>(context);
    productTemplateData = controller.productTemplateData;
    DashboardController dashboardController = Provider.of<DashboardController>(context);
    categoryData = dashboardController.categoryData;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: searchCtrl,
                height: 50,
                prefixIcon: ImageView(
                  height: 24,
                  width: 24,
                  assetImage: AppImages.search,
                  onTap: () {
                    fetchProductTemplates();
                  },
                ),
                fillColor: primaryGrey,
                hintText: "Search Products",
                onChanged: (val) {
                  if (controller.loadingProductTemplates == false) {
                    fetchProductTemplates();
                    setState(() {});
                  }
                },
                borderColor: primaryGrey,
                margin: const EdgeInsets.only(left: 24, right: 12, bottom: 16, top: 24),
              ),
            ),
            Container(
              height: 50,
              margin: const EdgeInsets.only(bottom: 16, top: 24, right: 16),
              decoration: BoxDecoration(
                color: primaryGrey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: ProductCategoryPicker(
                  selectedItem: selectedCategory,
                  items: categoryData,
                  onChanged: (range) {
                    setLocationRange(range: range);
                  },
                ),
              ),
            )
          ],
        ),
        if (controller.loadingProductTemplates)
          const LoadingScreen(
            heightFactor: 0.4,
          )
        else if (productTemplateData.haveData)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: productTemplateData?.length ?? 0,
            itemBuilder: (context, index) {
              var data = productTemplateData?.elementAt(index);
              return ProductInfoCard(
                data: data,
                onTap: () {
                  context.pop();
                  context.pushNamed(Routs.addProduct, extra: AddProduct(templateData: data));
                },
              );
            },
          )
        else
          const NoDataScreen(
            heightFactor: 0.4,
          )
      ],
    );
  }
}
