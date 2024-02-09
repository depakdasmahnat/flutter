import 'package:flutter/material.dart';
import 'package:gaas/controllers/orders/cart_controller.dart';
import 'package:gaas/core/enums/enums.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/models/orders/confirm_order_timeslot.dart';
import 'package:gaas/utils/widgets/data_widget_builder.dart';
import 'package:gaas/utils/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../controllers/dashboard_controller.dart';
import '../../core/constant/colors.dart';
import '../../core/constant/constant.dart';
import '../../core/constant/shadows.dart';
import '../../models/dashboard/producer_details_model.dart';
import '../../models/orders/order_detail_model.dart';
import '../../route/route_paths.dart';
import '../../utils/widgets/custom_bottom_sheet.dart';
import '../../utils/widgets/custom_button.dart';
import '../home/product/utils/order_detail_card.dart';
import '../home/utils/nearby_product.dart';
import '../home/view_producer.dart';
import '../services/service_provider_detail.dart';
import 'utils/rate_this_order.dart';

class OrderDetail extends StatefulWidget {
  const OrderDetail({Key? key, required this.orderId, required this.partnerId, this.refreshOrders})
      : super(key: key);
  final num? orderId;
  final num? partnerId;
  final GestureTapCallback? refreshOrders;

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  late num? orderId = widget.orderId;
  late num? partnerId = widget.partnerId;

  OrderDetailData? orderDetail;
  List<OrderDetailProducts>? products;
  Set<Marker> markers = {};
  GoogleMapController? mapController;

  fetchOrderDetail() async {
    CartController controller = Provider.of<CartController>(context, listen: false);
    return await controller.fetchOrderDetail(context: context, orderId: orderId, partnerId: partnerId);
  }

  double orderLatitude = 0;
  double orderLongitude = 0;

  void openMapDirection({LatLng? latLng}) {
    launchUrl(
      Uri.parse("https://www.google.com/maps/dir/?api=1&destination=$orderLatitude,$orderLongitude"),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      CartController controller = Provider.of<CartController>(context, listen: false);
      orderDetail = await fetchOrderDetail();

      orderLatitude = double.parse(
          "${(orderDetail?.type == OrderTypes.delivery.value ? orderDetail?.deliveryLatitude : orderDetail?.partnerLatitude) ?? 0}");
      orderLongitude = double.parse(
          "${(orderDetail?.type == OrderTypes.delivery.value ? orderDetail?.deliveryLongitude : orderDetail?.partnerLongitude) ?? 0}");
      debugPrint("orderLatitude $orderLatitude");
      debugPrint("orderLongitude $orderLongitude");
      MarkerId markerId = MarkerId("$orderLatitude,$orderLongitude");
      markers.add(
        Marker(
          markerId: markerId,
          icon: BitmapDescriptor.defaultMarker,
          position: LatLng(orderLatitude, orderLongitude),
          infoWindow: InfoWindow(
            title: orderDetail?.partnerName,
            snippet: orderDetail?.partnerAddress,
            onTap: () {
              openMapDirection();
            },
          ),
        ),
      );

      late CameraPosition orderCameraPosition = CameraPosition(
        target: LatLng(orderLatitude, orderLongitude),
        zoom: 12,
      );

      Future.delayed(const Duration(milliseconds: 300)).then((value) {
        if (context.mounted) {
          mapController?.animateCamera(CameraUpdate.newCameraPosition(orderCameraPosition));
          setState(() {});
        }
      });

      controller.fetchSuggestedTimesSlots(context: context, orderId: orderId, partnerId: partnerId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    CartController controller = Provider.of<CartController>(context);
    orderDetail = controller.orderDetailData;
    products = orderDetail?.products;

    return Scaffold(
      appBar: AppBar(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            backButton(context: context),
          ],
        ),
        leadingWidth: 50,
        title: const Text(
          "Order Detail",
          style: TextStyle(fontSize: 20, letterSpacing: 1.3, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: DataWidgetBuilder(
        isLoading: controller.loadingOrderDetail,
        haveData: orderDetail != null,
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade100),
                borderRadius: BorderRadius.circular(8),
                boxShadow: defaultBoxShadow(),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        orderDetail?.orderType ?? "",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if ((orderDetail?.noOfPersons ?? 0) > 0)
                        Text(
                          "(${orderDetail?.noOfPersons ?? ""} ${((orderDetail?.noOfPersons ?? 0) > 1) ? 'Persons' : "Person"})",
                          style: const TextStyle(
                            color: primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        orderDetail?.timeslotName ?? "",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        orderDetail?.datetime ?? "",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                statusTag(
                  width: size.width * 0.6,
                  status: "${orderDetail?.orderStatus}",
                ),
              ],
            ),
            if (orderDetail?.comment != null)
              Container(
                margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: defaultBoxShadow(),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Comment",
                            style: TextStyle(
                              fontSize: 16,
                              color: primaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${orderDetail?.comment}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            Container(
              margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: defaultBoxShadow(),
              ),
              child: Column(
                children: [
                  customRow(
                    title1: "Order Id",
                    title1Style: title1Style(),
                    title2: "#${orderDetail?.orderNumber ?? ""}",
                    title2Style: title2Style(),
                  ),
                  customRow(
                    title1: "Date & Time",
                    title1Style: title1Style(),
                    title2: orderDetail?.datetime ?? "",
                    title2Style: title2Style(),
                  ),
                  if (orderDetail?.paymentMethod != null)
                    customRow(
                      title1: "Payment Method",
                      title1Style: title1Style(),
                      title2: orderDetail?.paymentMethod ?? "",
                      title2Style: title2Style(),
                    ),
                  customRow(
                    title1: "Order Total",
                    title1Style: title1Style(),
                    title2: "\$${orderDetail?.totalAmount ?? 0}",
                    title2Style: const TextStyle(
                      color: primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if ((orderDetail?.paidAmount ?? 0) > 0)
                    customRow(
                      title1: "Paid Amount",
                      title1Style: title1Style(),
                      title2: "-\$${orderDetail?.paidAmount ?? 0}",
                      title2Style: const TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  if ((orderDetail?.paidAmount ?? 0) > 0)
                    customRow(
                      title1: "Balance Amount",
                      title1Style: title1Style(),
                      title2: "\$${(orderDetail?.totalAmount ?? 0) - (orderDetail?.paidAmount ?? 0)}",
                      title2Style: const TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  InkWell(
                    onTap: () {
                      context.read<CartController>().downloadOrderInvoice(context: context, orderId: orderId);
                    },
                    child: Container(
                      height: 40,
                      margin: const EdgeInsets.only(top: 8),
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Download Invoice",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Divider(color: primaryGrey, thickness: 3, height: 1),
            ),
            NearbyProductCard(
              id: orderDetail?.id,
              title: orderDetail?.partnerName,
              image: orderDetail?.profilePhoto,
              address: orderDetail?.partnerAddress,
              rating: orderDetail?.partnerRating,
              reviews: orderDetail?.partnerReviews,
              distance: orderDetail?.distanceLabel,
              onTap: () {
                String? serviceType = orderDetail?.type;
                debugPrint("serviceType $serviceType");
                if (serviceType == ServiceType.freshProduce.value) {
                  context.read<DashboardController>().setServiceType(serviceType: ServiceType.freshProduce);
                  context.pushNamed(Routs.viewProducer,
                      extra: ViewProducer(
                          partnerId: "${orderDetail?.partnerId}", orderType: orderDetail?.orderType));
                } else if (serviceType == ServiceType.nursery.value) {
                  context.read<DashboardController>().setServiceType(serviceType: ServiceType.nursery);
                  context.pushNamed(Routs.viewProducer,
                      extra: ViewProducer(
                          partnerId: "${orderDetail?.partnerId}", orderType: orderDetail?.orderType));
                } else if (serviceType == ServiceType.serviceProvider.value) {
                  context.push(Routs.serviceProviderDetail,
                      extra: ServiceProviderDetailScreen(id: orderDetail?.partnerId));
                }
              },
              padding: const EdgeInsets.symmetric(horizontal: 18),
            ),
            if (orderDetail?.partnerLatitude?.isNotEmpty == true &&
                orderDetail?.partnerLatitude?.isNotEmpty == true)
              Container(
                height: 250,
                width: size.width,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: primaryColor.withOpacity(0.3),
                    )),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      GoogleMap(
                        myLocationButtonEnabled: false,
                        myLocationEnabled: false,
                        mapToolbarEnabled: true,
                        markers: markers,
                        padding: const EdgeInsets.only(top: 48, bottom: 72),
                        zoomControlsEnabled: false,
                        onTap: (loc) {
                          setState(() {});
                        },
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            orderLatitude,
                            orderLongitude,
                          ),
                          zoom: 13,
                        ),
                        onMapCreated: (GoogleMapController controller) async {
                          mapController = controller;
                        },
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomButton(
                              text: "Call",
                              textColor: primaryColor,
                              icon: const Icon(
                                Icons.phone,
                                color: primaryColor,
                              ),
                              width: 110,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              backgroundColor: Colors.white.withOpacity(0.9),
                              borderColor: primaryColor.withOpacity(0.4),
                              onPressed: () {
                                launchUrl(
                                  Uri.parse("tel:${orderDetail?.partnerMobile}"),
                                  mode: LaunchMode.externalApplication,
                                );
                              },
                              margin: const EdgeInsets.only(left: 8),
                            ),
                            CustomButton(
                              width: 180,
                              text: "Get Direction",
                              textColor: primaryColor,
                              icon: const Icon(
                                Icons.my_location,
                                color: primaryColor,
                              ),
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              backgroundColor: Colors.white.withOpacity(0.9),
                              borderColor: primaryColor.withOpacity(0.4),
                              onPressed: () {
                                openMapDirection();
                              },
                              margin: const EdgeInsets.only(right: 8),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (products.haveData)
              ListView.builder(
                itemCount: products?.length ?? 0,
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var product = products?.elementAt(index);
                  return OrderDetailCard(
                    index: index,
                    product: ProducerProducts(
                      image: product?.image,
                      name: product?.productName,
                      price: "${product?.regularAmount ?? 0}",
                      mrpPrice: "${product?.mrpAmount ?? 0}",
                      unitName: "${product?.unitName}",
                      quantity: (product?.quantity ?? 0).toInt(),
                      initialInventory: (product?.totalRegularAmount ?? 0).toInt(),
                    ),
                    hideCounter: true,
                  );
                },
              ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              padding: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: defaultBoxShadow(),
              ),
              child: Column(
                children: [
                  customRow(
                    title1: "Subtotal",
                    title1Style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    title2: "\$${orderDetail?.subtotal ?? 0}",
                  ),
                  if ((orderDetail?.totalPersonAmount ?? 0) > 0)
                    customRow(
                      title1: "Self Picking Charges",
                      title2: "\$${orderDetail?.totalPersonAmount ?? "N/A"}",
                      title2Style: title2Style(),
                    ),
                  if ((orderDetail?.discount ?? 0) > 0)
                    customRow(
                      title1: "Discount",
                      title2: "\$${orderDetail?.discount ?? "N/A"}",
                      title2Style: title2Style(),
                    ),
                  if (orderDetail?.couponApplied == "Yes")
                    customRow(
                      title1: "Coupon",
                      title2: "-\$${orderDetail?.couponPrice ?? 0.0}",
                      title2Style: const TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  if (orderDetail?.coinsApplied == "Yes")
                    customRow(
                      title1: "Applied Coins",
                      title2: "-\$${orderDetail?.coinsAmount ?? 0.0}",
                      title2Style: const TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  customRow(
                    title1:
                        "Taxes ${(orderDetail?.taxPercent ?? 0) > 0 ? "(${orderDetail?.taxPercent} %)" : ""} ",
                    title2: "\$${orderDetail?.taxAmount ?? 0.0}",
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 14),
                    child: Divider(color: primaryGrey, thickness: 3, height: 1),
                  ),
                  customRow(
                    title1: "Grand Total",
                    title1Style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    title2: "\$${orderDetail?.totalAmount ?? 0}",
                    title2Style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (orderDetail?.orderStatus == OrderStatuses.onHold.value && orderDetail?.comment == null)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: CustomButton(
                    height: 45,
                    fontSize: 13,
                    text: "Confirm TimeSlot",
                    textColor: primaryColor,
                    backgroundColor: Colors.white,
                    mainAxisAlignment: MainAxisAlignment.center,
                    margin: EdgeInsets.zero,
                    onPressed: () {
                      CustomBottomSheet.show(
                        context: context,
                        isScrollControlled: true,
                        enableDrag: true,
                        physics: const NeverScrollableScrollPhysics(),
                        showTitleDivider: true,
                        title: "Confirm TimeSlot",
                        body: ConfirmOrderTimeSlot(
                          partnerId: partnerId,
                          orderId: orderId,
                          orderDetail: orderDetail,
                        ),
                      );
                    },
                  ),
                ),
              ),
            if (orderDetail?.orderStatus == OrderStatuses.completed.value)
              Expanded(
                child: CustomButton(
                  height: 45,
                  margin: EdgeInsets.zero,
                  mainAxisAlignment: MainAxisAlignment.center,
                  fontSize: 13,
                  text: orderDetail?.reviewAdded == true ? "Update Feedback" : "Rate this Order",
                  onPressed: () {
                    CustomBottomSheet.show(
                      context: context,
                      isScrollControlled: true,
                      enableDrag: true,
                      physics: const BouncingScrollPhysics(),
                      showTitleDivider: false,
                      body: RateThisOrder(
                        onSuccess: () {
                          context.pop();
                          fetchOrderDetail();
                        },
                        id: orderDetail?.orderId,
                        partnerId: orderDetail?.partnerId,
                        reviewAdded: orderDetail?.reviewAdded,
                        reviewDetail: orderDetail?.reviewDetail,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget statusTag({
    required String? status,
    Color? color,
    double? width,
  }) {
    return Container(
      height: 32,
      width: width,
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color ?? statusColor(status: status),
        border: Border.all(color: color ?? statusColor(status: status)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          "$status",
          style: const TextStyle(
            fontSize: 14,
            letterSpacing: 1.3,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  TextStyle title2Style() {
    return const TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    );
  }

  TextStyle title1Style() {
    return const TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w700,
    );
  }
}
