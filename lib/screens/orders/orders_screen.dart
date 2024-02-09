import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gaas/controllers/orders/cart_controller.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/utils/widgets/custom_bottom_sheet.dart';
import 'package:gaas/utils/widgets/service_type_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../core/config/app_images.dart';
import '../../core/constant/colors.dart';
import '../../core/enums/enums.dart';
import '../../core/services/database/local_database.dart';
import '../../models/fresh_produce_data.dart';
import '../../models/orders/orders_model.dart';
import '../../route/route_paths.dart';
import '../../utils/widgets/custom_text_field.dart';
import '../../utils/widgets/data_widget_builder.dart';
import '../../utils/widgets/image_view.dart';
import 'utils/orders_card.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({
    Key? key,
    this.categoryIndex,
    this.selectedCategories,
    this.orderType,
    this.id,
  }) : super(key: key);

  final String? id;
  final int? categoryIndex;
  final AllOrderTypes? orderType;
  final List<FreshProduceData>? selectedCategories;

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with TickerProviderStateMixin {
  late String? id = widget.id;
  late int? selectedIndex = widget.categoryIndex;

  late AllServiceType selectedServiceType = AllServiceType.all;

  RefreshController ordersRefresher = RefreshController(initialRefresh: false);
  TextEditingController searchCtrl = TextEditingController();
  bool isAuthenticated = LocalDatabase().accessToken != null;

  fetchOrders({bool? loadingNext}) {
    CartController controller = Provider.of<CartController>(context, listen: false);
    controller.fetchPartnerOrders(
        context: context,
        isRefresh: loadingNext == true ? false : true,
        loadingNext: loadingNext ?? false,
        serviceType: selectedServiceType,
        controller: ordersRefresher,
        search: searchCtrl.text);
  }

  Timer? _debounce;

  void onSearchFieldChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchOrders();

      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (isAuthenticated) {
        fetchOrders();
      } else {
        context.pushNamed(Routs.getStarted);
      }
    });
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  List<OrdersData>? ordersData;

  @override
  Widget build(BuildContext context) {
    CartController controller = Provider.of<CartController>(context);
    ordersData = controller.ordersData;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("${selectedServiceType.value} Orders"),
        ),
        body: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: CustomTextField(
                    height: 50,
                    autofocus: false,
                    controller: searchCtrl,
                    prefixIcon: ImageView(
                      height: 24,
                      width: 24,
                      assetImage: AppImages.search,
                      onTap: () async {
                        await fetchOrders();
                      },
                    ),
                    fillColor: primaryGrey,
                    hintText: "Search ${selectedServiceType.value} Orders",
                    onEditingComplete: () async {
                      await fetchOrders();
                    },
                    onChanged: (val) async {
                      onSearchFieldChanged(val);
                    },
                    borderColor: primaryGrey,
                    margin: const EdgeInsets.only(left: 12, right: 12, bottom: 16),
                  ),
                ),
                Container(
                  height: 50,
                  width: 58,
                  margin: const EdgeInsets.only(right: 16, bottom: 16),
                  decoration: BoxDecoration(
                    color: primaryGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ImageView(
                    height: 24,
                    width: 24,
                    fit: BoxFit.contain,
                    assetImage: AppImages.funnel,
                    color: primaryColor,
                    onTap: () {
                      CustomBottomSheet.show(
                        context: context,
                        title: "Select Partner Service",
                        body: AllServiceTypePicker(
                            selected: selectedServiceType,
                            list: AllServiceType.values,
                            onChanged: (val) {
                              selectedServiceType = val;
                              setState(() {});
                              fetchOrders();
                            }),
                      );
                    },
                    margin: EdgeInsets.zero,
                  ),
                )
              ],
            ),
            Expanded(
              child: DataWidgetBuilder(
                isLoading: controller.loadingOrders,
                haveData: ordersData.haveData,
                heightFactor: 0.65,
                child: SmartRefresher(
                  controller: ordersRefresher,
                  enablePullUp: true,
                  enablePullDown: true,
                  onRefresh: () async {
                    if (mounted) {
                      await fetchOrders();
                    }
                  },
                  onLoading: () async {
                    await controller.fetchPartnerOrders(
                        serviceType: selectedServiceType,
                        loadingNext: true,
                        context: context,
                        controller: ordersRefresher,
                        search: searchCtrl.text);
                  },
                  child: ListView.builder(
                    // physics: const BouncingScrollPhysics(),
                    itemCount: ordersData?.length ?? 0,
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    itemBuilder: (context, index) {
                      var order = ordersData?.elementAt(index);

                      return OrdersCard(
                        order: order,
                        refreshOrders: () {
                          fetchOrders();
                        },
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
