import 'package:flutter/material.dart';
import 'package:gaas/core/enums/enums.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/utils/skeleton.dart';
import 'package:gaas/utils/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../controllers/partner/partner_controller.dart';
import '../../../core/config/app_images.dart';
import '../../../core/constant/colors.dart';
import '../../../models/partner/earnings_model.dart';
import '../../../utils/widgets/custom_bottom_sheet.dart';
import '../../../utils/widgets/image_view.dart';
import '../../../utils/widgets/loading_screen.dart';
import '../../../utils/widgets/no_data_screen.dart';
import '../utils/earning_card.dart';
import '../utils/earnings_card.dart';
import 'order_status_picker.dart';

class PartnerEarning extends StatefulWidget {
  const PartnerEarning({Key? key}) : super(key: key);

  @override
  State<PartnerEarning> createState() => _PartnerEarningState();
}

class _PartnerEarningState extends State<PartnerEarning> with TickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();

  late EarningStatuses status = EarningStatuses.all;

  fetchOrders({bool? loadingNext}) {
    PartnerController controller = Provider.of<PartnerController>(context, listen: false);
    controller.fetchEarnings(
      context: context,
      isRefresh: loadingNext == true ? false : true,
      loadingNext: loadingNext ?? false,
      search: searchController.text,
      status: status,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchOrders();
    });
  }

  EarningsModel? earningsModel;
  List<EarningsData>? earningsData;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    PartnerController controller = Provider.of<PartnerController>(context);
    earningsModel = controller.earningsModel;
    earningsData = controller.earningsData;

    return Scaffold(
      body: SmartRefresher(
        controller: controller.earningsController,
        enablePullUp: true,
        enablePullDown: true,
        onRefresh: () async {
          if (mounted) {
            await fetchOrders();
          }
        },
        onLoading: () async {
          if (mounted) {
            await fetchOrders(loadingNext: true);
          }
        },
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const ScrollPhysics(),
          children: [
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 270,
                  width: size.width,
                  margin: EdgeInsets.zero,
                  decoration: const BoxDecoration(
                    color: secondaryColor,
                    image: DecorationImage(
                      image: AssetImage(AppImages.earningBg),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(48),
                      bottomRight: Radius.circular(48),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  child: SafeArea(
                    child: Column(
                      children: [
                        const Text(
                          "Earning",
                          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 2),
                          child: Text(
                            "\$${earningsModel?.totalEarning ?? 0.0}",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 36, fontWeight: FontWeight.w800),
                          ),
                        ),
                        const Text(
                          "Total Earning",
                          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: -60,
                  child: SizedBox(
                    height: 152,
                    width: size.width * 0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        EarningCard(
                          title: "Paid",
                          value: "${earningsModel?.totalPaid ?? 0.0}",
                          image: AppImages.paidAmount,
                          onTap: () {},
                        ),
                        EarningCard(
                          title: "Pending",
                          value: "${earningsModel?.totalPending ?? 0.0}",
                          image: AppImages.pending,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 8,
                  child: SafeArea(
                    child: backButton(
                      context: context,
                      onTap: () async {
                        context.read<PartnerController>().onPartnerBackPress(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 72, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Orders",
                    style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: primaryColor,
                    child: ImageView(
                      height: 18,
                      width: 18,
                      fit: BoxFit.contain,
                      assetImage: AppImages.funnel,
                      color: Colors.white,
                      onTap: () {
                        CustomBottomSheet.show(
                          context: context,
                          title: "Select Order Status",
                          body: OrderStatusPicker(
                              selected: status,
                              list: EarningStatuses.values,
                              onChanged: (val) {
                                status = val;
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
            ),
            controller.loadingEarnings
                ? Skeletons().skeletonEarningsCard(context: context, itemCount: 10)
                : (earningsData.haveData)
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: earningsData?.length ?? 0,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          var data = earningsData?.elementAt(index);

                          return EarningsCard(
                            data: data,
                            onTap: () {},
                          );
                        },
                      )
                    : NoDataScreen(
                        heightFactor: 0.35,
                        message: earningsModel?.message ?? "No Earnings Found",
                      ),
          ],
        ),
      ),
    );
  }
}
