import 'package:flutter/material.dart';
import 'package:gaas/controllers/partner/partner_controller.dart';
import 'package:gaas/controllers/partner/product_controller.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/screens/partner/utils/partner_order_card.dart';
import 'package:gaas/utils/widgets/custom_bottom_sheet.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../core/config/app_images.dart';
import '../../../core/constant/colors.dart';
import '../../../core/enums/enums.dart';
import '../../../models/partner/orders/partner_order_model.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/data_widget_builder.dart';
import '../../../utils/widgets/image_view.dart';
import '../utils/partner_app_bar.dart';

class PartnerOrders extends StatefulWidget {
  const PartnerOrders({Key? key}) : super(key: key);

  @override
  State<PartnerOrders> createState() => _PartnerOrdersState();
}

class _PartnerOrdersState extends State<PartnerOrders> with TickerProviderStateMixin {
  late int tabIndex = 0;
  ServiceType? serviceType;

  List<String>? tabOrderType = ["All", "New", "Completed"];

  TextEditingController searchCtrl = TextEditingController();

  fetchOrders() {
    ProductController controller = Provider.of<ProductController>(context, listen: false);
    controller.fetchPartnerOrders(
        context: context,
        isRefresh: true,
        orderType: tabOrderType?[tabIndex] ?? "All",
        search: searchCtrl.text);
  }

  TabController? tabController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ProductController>().orderStartDate = null;
      context.read<ProductController>().update();

      tabIndex = context.read<PartnerController>().ordersTabIndex;
      serviceType = context.read<PartnerController>().serviceType;
      setState(() {});
      fetchOrders();
      tabController = TabController(initialIndex: tabIndex, length: tabOrderType?.length ?? 0, vsync: this);
      tabController?.animateTo(tabIndex);
      tabController?.addListener(() {
        setState(() {
          tabIndex = tabController?.index ?? 0;
          context.read<PartnerController>().setOrdersTabIndex(tabIndex);
          debugPrint("addListener TabIndex $tabIndex");
        });
      });
    });
  }

  Future onTabChange(int index) async {
    setState(() {
      if (!context.read<ProductController>().loadingOrders) {
        tabIndex = index;
        context.read<PartnerController>().setOrdersTabIndex(tabIndex);
        fetchOrders();

        debugPrint("onTabChange tabIndex $tabIndex  ");
      }
    });
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  List<PartnerOrderData>? ordersData;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ProductController controller = Provider.of<ProductController>(context);
    ordersData = controller.ordersData;
    PartnerController partnerController = Provider.of<PartnerController>(context);
    tabIndex = partnerController.ordersTabIndex;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: partnerAppBar(context: context, title: "${serviceType?.value} Orders"),
        body: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: CustomTextField(
                    controller: searchCtrl,
                    height: 50,
                    prefixIcon: ImageView(
                      height: 24,
                      width: 24,
                      assetImage: AppImages.search,
                      onTap: () async {
                        await fetchOrders();
                      },
                    ),
                    fillColor: primaryGrey,
                    hintText: "Search Orders",
                    onEditingComplete: () async {
                      await fetchOrders();
                    },
                    onChanged: (val) async {
                      if (controller.loadingOrders == false) {
                        await fetchOrders();
                      }
                    },
                    borderColor: primaryGrey,
                    margin: const EdgeInsets.only(left: 24, right: 12),
                  ),
                ),
                Container(
                  height: 50,
                  width: 58,
                  margin: const EdgeInsets.only(right: 24),
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
                        title: 'Select Order Date',
                        body: StatefulBuilder(
                          builder: (context, setState) {
                            return Column(
                              children: [
                                CustomTextField(
                                  readOnly: true,
                                  controller: TextEditingController(text: controller.orderStartDateString()),
                                  onTap: () async {
                                    bool dateChanged = await controller.showOrderStartDatePicker(context);
                                    if (dateChanged) {
                                      context.pop();
                                      fetchOrders();
                                    }
                                  },
                                  prefixIcon: const Icon(Icons.calendar_month),
                                  hintText: 'Select Start Date',
                                  suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                                  margin: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
                                ),
                                CustomTextField(
                                  readOnly: true,
                                  controller: TextEditingController(text: controller.orderEndDateString()),
                                  onTap: () async {
                                    bool dateChanged = await controller.showOrderEndDatePicker(context);
                                    if (dateChanged) {
                                      context.pop();
                                      fetchOrders();
                                    }
                                  },
                                  prefixIcon: const Icon(Icons.calendar_month),
                                  hintText: 'Select End Date',
                                  suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                                  margin: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    },
                    margin: EdgeInsets.zero,
                  ),
                )
              ],
            ),
            Expanded(
              child: DefaultTabController(
                initialIndex: tabIndex,
                length: tabOrderType?.length ?? 0,
                child: Column(
                  children: [
                    SizedBox(
                      width: size.width,
                      height: 55,
                      child: TabBar(
                        controller: tabController,
                        onTap: (val) {
                          onTabChange(val);
                        },
                        isScrollable: true,
                        labelColor: primaryColor,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: primaryColor,
                        indicatorWeight: 1,
                        automaticIndicatorColorAdjustment: true,
                        indicatorSize: TabBarIndicatorSize.tab,
                        padding: const EdgeInsets.only(top: 12, bottom: 8),
                        unselectedLabelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                        labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        tabs: List.generate(
                          tabOrderType?.length ?? 0,
                          (index) {
                            var data = tabOrderType?.elementAt(index);
                            return Text("$data");
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: SmartRefresher(
                        controller: controller.ordersRefresher,
                        enablePullUp: true,
                        enablePullDown: true,
                        onRefresh: () async {
                          if (mounted) {
                            await fetchOrders();
                          }
                        },
                        onLoading: () async {
                          await controller.fetchPartnerOrders(
                              orderType: tabOrderType?[tabIndex] ?? "All",
                              loadingNext: true,
                              context: context,
                              search: searchCtrl.text);
                        },
                        child: ListView(
                          shrinkWrap: true,
                          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                          children: [
                            DataWidgetBuilder(
                              isLoading: controller.loadingOrders,
                              haveData: ordersData.haveData,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: ordersData?.length,
                                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                                itemBuilder: (context, index) {
                                  var order = ordersData?.elementAt(index);

                                  return PartnerOrdersCard(order: order);
                                },
                              ),
                            ),
                          ],
                        ),
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
}
