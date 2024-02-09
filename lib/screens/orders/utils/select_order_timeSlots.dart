import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/models/partner/setup/timeslots_model.dart';
import 'package:gaas/screens/orders/utils/peoples_counter_buttons.dart';
import 'package:gaas/utils/widgets/custom_bottom_sheet.dart';
import 'package:gaas/utils/widgets/custom_button.dart';
import 'package:gaas/utils/widgets/custom_text_field.dart';
import 'package:gaas/utils/widgets/loading_screen.dart';
import 'package:gaas/utils/widgets/no_data_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../controllers/location/location_controller.dart';
import '../../../controllers/orders/cart_controller.dart';
import '../../../core/config/app_images.dart';
import '../../../core/constant/colors.dart';
import '../../../core/constant/shadows.dart';
import '../../../core/enums/enums.dart';
import '../../../models/dashboard/producer_details_model.dart';
import '../../../models/order_type_data.dart';
import '../../../models/orders/order_addresses.dart';
import '../../../models/orders/partner_time_slots_model.dart';
import '../../../models/orders/partner_timeslote_dates_model.dart';
import '../../../models/partner/setup/delivery_zones_model.dart';
import '../../../route/route_paths.dart';
import '../../../utils/widgets/widgets.dart';
import '../../home/product/utils/custom_time_card.dart';
import '../../home/product/utils/custom_date_card.dart';
import '../../home/product/utils/order_type_card.dart';
import '../delivery_zone_picker.dart';
import '../order_address_picker.dart';
import 'pick_timeslots_dates.dart';

class SelectOrderTypeTimeSlot extends StatefulWidget {
  const SelectOrderTypeTimeSlot({Key? key, required this.serviceTypes, required this.producer})
      : super(key: key);
  final ProducerDetailsData? producer;
  final List<ProducerServiceTypes>? serviceTypes;

  @override
  State<SelectOrderTypeTimeSlot> createState() => _SelectOrderTypeTimeSlotState();
}

class _SelectOrderTypeTimeSlotState extends State<SelectOrderTypeTimeSlot> {
  late ProducerDetailsData? producer = widget.producer;
  late List<ProducerServiceTypes>? serviceTypes = widget.serviceTypes;
  late List<String>? serverOrderTypes = producer?.orderTypes;

  bool typeExist(AllOrderTypes type) {
    bool exist = false;
    exist = (serverOrderTypes?.any((element) {
          bool result = element == type.value;
          debugPrint("AllOrderTypes Exist $element  & ${type.value} =$result");

          return result;
        }) ==
        true);
    return exist;
  }

  late List<OrderTypeData> orderTypes = [
    if (typeExist(AllOrderTypes.uPick))
      OrderTypeData(type: AllOrderTypes.uPick, image: AppImages.deliveryMan2),
    if (typeExist(AllOrderTypes.readyToPick))
      OrderTypeData(type: AllOrderTypes.readyToPick, image: AppImages.deliveryMan),
    if (typeExist(AllOrderTypes.delivery))
      OrderTypeData(type: AllOrderTypes.delivery, image: AppImages.fastDelivery),
  ];

  OrderTypeData? getOrderType() {
    if (producer?.orderType == AllOrderTypes.uPick.value) {
      return OrderTypeData(type: AllOrderTypes.uPick, image: AppImages.deliveryMan2);
    } else if (producer?.orderType == AllOrderTypes.readyToPick.value) {
      return OrderTypeData(type: AllOrderTypes.readyToPick, image: AppImages.deliveryMan);
    } else if (producer?.orderType == AllOrderTypes.delivery.value) {
      return OrderTypeData(type: AllOrderTypes.delivery, image: AppImages.fastDelivery);
    }
  }

  bool changingLocation = false;
  late bool isSameAddress = producer?.isSameAddress ?? false;

  late OrderTypeData? selectedOrderType = orderTypes.haveData ? orderTypes.first : null;

  DeliveryZonesData? selectedDeliveryZone;

  OrderAddress? selectedHomeAddress;

  TimeSlotsData? selectedTimeSlot;
  List<TimeSlotsData>? timeSlots;
  List<DeliveryZonesData>? deliveryZonesData;
  List<PartnerServicesData>? partnerServicesData;

  PartnerTimeSlotDates? selectedDateSlot;

  List<PartnerTimeSlotDates>? dateSlots;

  fetchCartTimeslotDates() async {
    final cartController = Provider.of<CartController>(context, listen: false);
    dateSlots = await cartController.fetchCartTimeslotDates(
      context: context,
      partnerId: producer?.id,
      orderType: producer?.orderType,
      date: producer?.selectedDateSlot?.date,
    );

    setState(() {});
    getServiceTimeSlotDates();
  }

  fetchTimeSlots() async {
    final cartController = Provider.of<CartController>(context, listen: false);
    partnerServicesData = await cartController.fetchCartTimeslots(
      context: context,
      partnerId: producer?.id,
      orderType: producer?.orderType,
      date: producer?.selectedDateSlot?.date,
    );

    getServiceTimeSlots();
  }

  getServiceTimeSlots() {
    List<PartnerServicesData>? service =
        partnerServicesData?.where((element) => element.type == selectedOrderType?.type?.value).toList();
    if (service.haveData) {
      timeSlots = service?.first.timeslots;
      setState(() {});

      if (timeSlots.haveData) {
        selectedTimeSlot = timeSlots?.first;
        setState(() {});
      }
    }

    setOrderMethod();
    setTimeSlot();
  }

  getServiceTimeSlotDates() {
    if (dateSlots.haveData) {
      selectedDateSlot = dateSlots?.first;
      setState(() {});
      debugPrint("selectedDateSlot ${selectedDateSlot?.date}");
    }

    setOrderMethod();
    setDateSlot();
    fetchTimeSlots();
  }

  late OrderAddress? homeAddress = producer?.homeAddress;
  late OrderAddress? deliveryAddressOrder = producer?.deliveryAddressOrder;
  late OrderAddress? billingAddress = producer?.billingAddress;
  List<OrderAddress>? orderAddresses;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchCartTimeslotDates();
      fetchTimeSlots();
      getServiceTimeSlots();
      setOrderMethod();
      selectedOrderType = getOrderType();
      setState(() {});

      debugPrint("orderType #producer ${producer?.orderType}");
      debugPrint("orderType #selectedOrderTypes ${selectedOrderType?.type?.value}");
    });
  }

  setOrderMethod() {
    final cartController = Provider.of<CartController>(context, listen: false);
    cartController.setOrderMethod(producer: producer, orderMethod: selectedOrderType?.type?.value);
  }

  setDateSlot() {
    final cartController = Provider.of<CartController>(context, listen: false);
    cartController.setDateSlot(producer: producer, timeSlot: selectedDateSlot);
  }

  setTimeSlot() {
    final cartController = Provider.of<CartController>(context, listen: false);
    cartController.setTimeSlot(producer: producer, timeSlot: selectedTimeSlot);
  }

  setHomeAddress() {
    final cartController = Provider.of<CartController>(context, listen: false);
    cartController.setHomeAddress(producer: producer, address: homeAddress);
  }

  setDeliveryAddressOrder() {
    final cartController = Provider.of<CartController>(context, listen: false);
    cartController.setDeliveryAddressOrder(producer: producer, address: deliveryAddressOrder);
  }

  setBillingAddress() {
    final cartController = Provider.of<CartController>(context, listen: false);
    cartController.setBillingAddress(producer: producer, address: billingAddress);
  }

  setIsSameAddress() {
    final cartController = Provider.of<CartController>(context, listen: false);
    cartController.setIsSameAddress(producer: producer, same: isSameAddress);
  }

  setOrderTypeData() {
    final cartController = Provider.of<CartController>(context, listen: false);
    cartController.setOrderType(
        context: context, producerId: producer?.id, orderType: selectedOrderType?.type?.value);
  }

  double? deliveryLatitude;
  double? deliveryLongitude;
  String? deliveryAddress;

  setDeliveryLocation() {
    final cartController = Provider.of<CartController>(context, listen: false);
    cartController.setDeliveryLocation(
      producer: producer,
      deliveryLatitude: deliveryLatitude,
      deliveryLongitude: deliveryLongitude,
      deliveryAddress: deliveryAddress,
    );

    setState(() {});
  }

  setPreFilledDeliveryLocation() {
    changingLocation = true;
    setState(() {});
    final locationController = Provider.of<LocationController>(context, listen: false);
    final cartController = Provider.of<CartController>(context, listen: false);
    double? latitude = locationController.latitude;
    double? longitude = locationController.longitude;
    String? address = locationController.address?.addressLine;
    debugPrint("setPreFilledDeliveryLocation $latitude $longitude $address");
    cartController.setDeliveryLocation(
      producer: producer,
      deliveryLatitude: latitude,
      deliveryLongitude: longitude,
      deliveryAddress: address,
    );

    deliveryAddress = address;
    changingLocation = false;
    setState(() {});
  }

  setDeliveryZone() {
    final cartController = Provider.of<CartController>(context, listen: false);
    cartController.setDeliveryZone(producer: producer, deliveryZone: selectedDeliveryZone);
  }

  @override
  Widget build(BuildContext context) {
    CartController controller = Provider.of<CartController>(context);
    orderAddresses = controller.orderAddresses;
    homeAddress = producer?.homeAddress;
    deliveryAddressOrder = producer?.deliveryAddressOrder;
    billingAddress = producer?.billingAddress;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Please select your order type",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              OrderTypeCard(
                selected: selectedOrderType,
                list: orderTypes,
                onChanged: (val) {
                  setState(() {
                    selectedOrderType = val;
                    setOrderTypeData();
                    isSameAddress = false;
                    setIsSameAddress();
                  });

                  if (selectedOrderType?.type == AllOrderTypes.delivery) {
                    setPreFilledDeliveryLocation();
                    setState(() {});
                  }

                  fetchCartTimeslotDates();
                },
              ),
              if (selectedOrderType?.type == AllOrderTypes.uPick && producer?.isFreeSelfPicking == "No")
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12, top: 12),
                      child: Text(
                        "Select No of Peoples for Self Picking",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: defaultBoxShadow(),
                        border: Border.all(color: Colors.grey.shade100),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Self Picking Charges",
                                style:
                                    TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Text(
                                    "Total Charges :- ",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    "\$${num.parse("${producer?.noOfPersons ?? 1}") * num.parse("${producer?.eachPersonAmount ?? 0}")}",
                                    style: const TextStyle(
                                        color: primaryColor, fontSize: 14, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          PeoplesCounterButtons(
                            producer: producer,
                            hideCounter: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Choose a ${selectedOrderType?.type?.message} Date",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),

        if (controller.loadingPartnerTimeSlotDates)
           LoadingScreen(
            heightFactor: 0.1,
            fontSize: 12,
            message: 'Loading ${selectedOrderType?.type?.message} Dates...',
          )
        else if (dateSlots.haveData)
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16),
            child: PickTimeSlotDates(
              selected: selectedDateSlot,
              list: dateSlots,
              onChanged: (val) {
                setState(() {
                  selectedDateSlot = val;
                });
                setDateSlot();
                fetchTimeSlots();
              },
            ),
          )
        else
           NoDataScreen(
            heightFactor: 0.1,
            fontSize: 12,
            message: 'No ${selectedOrderType?.type?.message} dates available...',
          ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Choose a ${selectedOrderType?.type?.message} Time",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),

        if (controller.loadingPartnerService)
           LoadingScreen(
            heightFactor: 0.1,
            fontSize: 12,
            message: 'Loading ${selectedOrderType?.type?.message} Times...',
          )
        else if (timeSlots.haveData)
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16),
            child: CustomTimeSlotCard(
              selected: selectedTimeSlot,
              list: timeSlots,
              onChanged: (val) {
                setState(() {
                  selectedTimeSlot = val;
                });

                setTimeSlot();
              },
            ),
          )
        else
          const NoDataScreen(
            heightFactor: 0.1,
            fontSize: 12,
            message: 'No pickup time available...',
          ),
        // if (selectedOrderTypes?.type == AllOrderTypes.delivery && !changingLocation)
        //   Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Padding(
        //         padding: const EdgeInsets.only(right: 16, left: 16),
        //         child: Text(
        //           "Delivery Address",
        //           style: Theme.of(context).textTheme.titleSmall,
        //         ),
        //       ),
        //       CustomTextField(
        //         initialValue: deliveryAddress,
        //         readOnly: producer?.deliveryLongitude == null,
        //         prefixIcon: const Icon(Icons.location_pin),
        //         onTap: producer?.deliveryLongitude == null
        //             ? () {
        //                 onDeliveryTap();
        //               }
        //             : null,
        //         onChanged: (val) {
        //           deliveryAddress = val;
        //           setState(() {});
        //           setDeliveryLocation();
        //         },
        //         textAlignVertical: TextAlignVertical.top,
        //         suffixIcon: GestureDetector(
        //           onTap: () {
        //             onDeliveryTap();
        //           },
        //           child: const Icon(Icons.my_location),
        //         ),
        //         minLines: 1,
        //         maxLines: 3,
        //         hintText: 'Select Delivery Address',
        //       ),
        //     ],
        //   ),

        if (selectedOrderType?.type == AllOrderTypes.delivery)
          Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Choose a Delivery Address",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        GestureDetector(
                          onTap: () {
                            changeDeliveryAddress();
                          },
                          child: Text(
                            orderAddresses?.haveData == true ? "Change" : "Add",
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (deliveryAddressOrder != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 16),
                      child: trainingLocationCard(
                        context: context,
                        data: deliveryAddressOrder,
                        selected: true,
                        icon: Icons.edit,
                        onTap: () {
                          changeDeliveryAddress();
                        },
                      ),
                    )
                  else
                    const NoDataScreen(
                      heightFactor: 0.08,
                      fontSize: 12,
                      message: 'No Delivery Address available...',
                    )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Choose a Billing Address",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        GestureDetector(
                          onTap: () {
                            changeBillingAddress();
                          },
                          child: Text(
                            orderAddresses?.haveData == true ? "Change" : "Add",
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Text(
                              "(Same as Delivery Address)",
                              style: TextStyle(color: primaryColor, fontSize: 10),
                            ),
                          ],
                        ),
                        Switch(
                          value: isSameAddress,
                          onChanged: (val) {
                            isSameAddress = val;
                            setState(() {});
                            setIsSameAddress();
                          },
                        ),
                      ],
                    ),
                  ),
                  if (isSameAddress == true)
                    const NoDataScreen(
                      heightFactor: 0.06,
                      fontSize: 12,
                      message: 'Billing Address same as delivery Address...',
                    )
                  else if (billingAddress != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 16),
                      child: trainingLocationCard(
                        context: context,
                        data: billingAddress,
                        selected: true,
                        icon: Icons.edit,
                        onTap: () {
                          changeBillingAddress();
                        },
                      ),
                    )
                  else
                    const NoDataScreen(
                      heightFactor: 0.08,
                      fontSize: 12,
                      message: 'No Billing Address available...',
                    )
                ],
              ),
            ],
          ),
      ],
    );
  }

  Widget trainingLocationCard({
    int? index,
    required BuildContext context,
    required OrderAddress? data,
    required bool? selected,
    IconData? icon,
    required GestureCancelCallback? onTap,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        return InkWell(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.only(left: 8, right: 8, bottom: 16, top: 0),
            padding: const EdgeInsets.only(top: 16, bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: defaultBoxShadow(),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 8),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: Icon((Icons.location_on_outlined), size: 18, color: primaryColor),
                            ),
                            Expanded(
                              child: Text(
                                "${data?.name}",
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "${data?.locAddress}",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Icon(
                    icon ??
                        (selected == true ? CupertinoIcons.checkmark_alt_circle_fill : CupertinoIcons.circle),
                    size: 24,
                    color: selected == true ? primaryColor : Colors.grey.shade300,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void onDeliveryTap() {
    changingLocation = true;
    setState(() {});
    context
        .pushNamed(Routs.deliveryZonePicker,
            extra: DeliveryZonePicker(
              partnerId: producer?.id,
              deliveryZones: deliveryZonesData,
            ))
        .then((value) {
      CartController cartController = Provider.of<CartController>(context, listen: false);
      if (cartController.isValidDeliveryZone) {
        LocationController location = Provider.of<LocationController>(context, listen: false);
        deliveryLatitude = location.tempLatitude;
        deliveryLongitude = location.tempLongitude;
        deliveryAddress = location.tempAddress?.addressLine;

        setState(() {});
        debugPrint(
            "deliveryLatitude is $deliveryLatitude && deliveryLongitude is $deliveryLatitude && deliveryAddress is $deliveryAddress");
        setDeliveryLocation();
      }
      changingLocation = false;
      setState(() {});
    });
  }

  void addOderAddress() {
    changingLocation = true;
    setState(() {});
    context.pop();
    context
        .pushNamed(Routs.oderAddressPicker, extra: OderAddressPicker(partnerId: producer?.id))
        .then((value) {
      CartController cartController = Provider.of<CartController>(context, listen: false);
      if (cartController.isValidDeliveryZone) {
        // LocationController location = Provider.of<LocationController>(context, listen: false);
        // deliveryLatitude = location.tempLatitude;
        // deliveryLongitude = location.tempLongitude;
        // deliveryAddress = location.tempAddress?.addressLine;
        //
        // setState(() {});
        // debugPrint(
        //     "deliveryLatitude is $deliveryLatitude && deliveryLongitude is $deliveryLatitude && deliveryAddress is $deliveryAddress");
        // setDeliveryLocation();
      }

      changingLocation = false;
      setState(() {});
    });
  }

  changeDeliveryAddress() {
    return CustomBottomSheet.show(
      title: "Change Delivery Address",
      centerTitle: true,
      showBackButton: true,
      body: orderAddresses?.haveData == true
          ? ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orderAddresses?.length ?? 0,
              padding: const EdgeInsets.only(top: 8),
              itemBuilder: (context, index) {
                OrderAddress? orderAddress = orderAddresses?.elementAt(index);
                return trainingLocationCard(
                  index: index,
                  context: context,
                  data: orderAddress,
                  selected: orderAddress?.id == deliveryAddressOrder?.id,
                  onTap: () {
                    deliveryAddressOrder = orderAddress;
                    setState(() {});
                    setDeliveryAddressOrder();
                    context.pop();
                  },
                );
              },
            )
          : const NoDataScreen(
              heightFactor: 0.1,
              fontSize: 12,
              message: 'No Address available...',
            ),
      bottomNavBarHeight: 60,
      bottomNavBar: CustomButton(
        height: 45,
        mainAxisAlignment: MainAxisAlignment.center,
        text: "Add a New Address",
        onPressed: () {
          addOderAddress();
        },
      ),
      showTitleDivider: true,
      context: context,
    );
  }

  changeBillingAddress() {
    return CustomBottomSheet.show(
      title: "Change Billing Address",
      centerTitle: true,
      showBackButton: true,
      body: orderAddresses?.haveData == true
          ? ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orderAddresses?.length ?? 0,
              padding: const EdgeInsets.only(top: 8),
              itemBuilder: (context, index) {
                OrderAddress? orderAddress = orderAddresses?.elementAt(index);
                return trainingLocationCard(
                  index: index,
                  context: context,
                  data: orderAddress,
                  selected: orderAddress?.id == billingAddress?.id,
                  onTap: () {
                    billingAddress = orderAddress;
                    setState(() {});
                    setBillingAddress();
                    context.pop();
                  },
                );
              },
            )
          : const NoDataScreen(
              heightFactor: 0.1,
              fontSize: 12,
              message: 'No Address available...',
            ),
      bottomNavBarHeight: 60,
      bottomNavBar: CustomButton(
        height: 45,
        mainAxisAlignment: MainAxisAlignment.center,
        text: "Add a New Address",
        onPressed: () {
          addOderAddress();
        },
      ),
      showTitleDivider: true,
      context: context,
    );
  }
}
