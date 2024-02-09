import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/controllers/partner/partner_controller.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/models/partner/setup/timeslot_date_picker.dart';
import 'package:gaas/utils/widgets/data_widget_builder.dart';
import 'package:provider/provider.dart';

import '../../../core/constant/colors.dart';
import '../../../core/enums/enums.dart';
import '../../../models/partner/auth/check_timeline_status.dart';
import '../../../models/partner/setup/day_wise_time_slots.dart';
import '../../../models/partner/setup/timeslot_dates.dart';
import '../../../models/partner/setup/timeslots_model.dart';
import '../../../utils/widgets/custom_button.dart';
import '../../../utils/widgets/widgets.dart';
import '../signup/utils/multi_timeslot_card.dart';

class SelectTimeSlots extends StatefulWidget {
  const SelectTimeSlots(
      {Key? key,
      required this.selectedOrderTypes,
      this.route,
      required this.type,
      this.editMode,
      this.timeLineStatus})
      : super(key: key);

  final String? route;
  final bool? editMode;

  final CheckTimeLinesStatus? timeLineStatus;
  final ServiceType? type;
  final Set<OrderTypes?>? selectedOrderTypes;

  @override
  State<SelectTimeSlots> createState() => _SelectTimeSlotsState();
}

class _SelectTimeSlotsState extends State<SelectTimeSlots> {
  late bool? editMode = widget.editMode;
  late String? route = widget.route;
  late ServiceType? type = widget.type;
  late CheckTimeLinesStatus? timeLineStatus = widget.timeLineStatus;
  late Set<OrderTypes?> selectedOrderTypes = widget.selectedOrderTypes ?? {};

  List<TimeSlotsData>? timeslots;

  late bool selfPickingAvailable = selectedOrderTypes.contains(OrderTypes.uPick);
  late bool readyToGoAvailable = selectedOrderTypes.contains(OrderTypes.readyToPick);
  late bool deliveryAvailable = selectedOrderTypes.contains(OrderTypes.delivery);

  int dayWiseTimeSlotIndex = 0;
  late TimeSlotsDayData? dayWiseTimeSlots;

  Set<num?>? deleteIds = {};
  TimeslotDates? timeslotDates;
  late String? selectedDate = timeLineStatus?.data;
  late bool timeLineUpdate = timeLineStatus != null ? true : false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      PartnerController partnerController = Provider.of<PartnerController>(context, listen: false);

      timeslots = await partnerController.fetchTimeslots(context: context);
      if (timeLineStatus?.data == null) {
        timeslotDates = await partnerController.fetchTimeslotDates(context: context);
        setState(() {});
        if (timeslotDates?.data?.haveData == true) {
          selectedDate = timeslotDates?.data?.first;
          setState(() {});
        }
      }
      if (editMode == true || timeLineStatus != null) {
        if (context.mounted) {
          fetchPartnerTimeslots();
        }
      } else {
        partnerController.setDayWiseTimeSlots(
          selfPickingAvailable: selfPickingAvailable,
          readyToGoAvailable: readyToGoAvailable,
          deliveryAvailable: deliveryAvailable,
          defaultTimeSlots: timeslots,
        );
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PartnerController controller = Provider.of<PartnerController>(context);
    dayWiseTimeSlots = controller.dayWiseTimeSlots;
    timeslotDates = controller.timeslotDates;
    debugPrint("selectedOrderTypes ${selectedOrderTypes.length}");

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${editMode == true ? "Update" : ""} ${type?.value} \n(Time Slots)",
          style: const TextStyle(fontSize: 14, color: Colors.black),
          textAlign: TextAlign.center,
        ),
        actions: [
          if (timeLineStatus != null)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text("Last update :- ${timeLineStatus?.data}"),
                ),
              ],
            )
          else if (selectedDate != null && (timeslotDates?.data?.length ?? 0) > 1)
            TimeslotDatePicker(
              date: selectedDate,
              dates: timeslotDates?.data,
              onChanged: (date) {
                selectedDate = date;
                setState(() {});

                loadingDialog(
                  context: context,
                  future: fetchPartnerTimeslots(),
                );
              },
            )
          else if (selectedDate != null)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text("For :- $selectedDate"),
                ),
              ],
            )
        ],
      ),
      body: DataWidgetBuilder(
        isLoading: controller.loadingTimeslots,
        haveData: timeslots.haveData,
        child: ListView(
          shrinkWrap: true,
          children: [
            if (selfPickingAvailable == true)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                    child: Text(
                      "${OrderTypes.uPick.value} Time Slots",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16),
                    child: MultiTimeCard(
                      key: Key(OrderTypes.uPick.value),
                      selected: dayWiseTimeSlots?.selfPickingTimeslots,
                      timeslotsList: timeslots,
                      deleteIds: deleteIds,
                      onChanged: (val, deleted) {
                        PartnerController controller = Provider.of<PartnerController>(context, listen: false);
                        controller.setTimeslots(
                          dayWiseTimeSlotsIndex: dayWiseTimeSlotIndex,
                          selectedTimeSlots: val,
                          orderTypes: OrderTypes.uPick,
                        );
                        deleteIds = deleted;
                        debugPrint("my deleteIds $deleteIds");
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            if (readyToGoAvailable == true)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                    child: Text(
                      "${OrderTypes.readyToPick.value} Time Slots",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16),
                    child: MultiTimeCard(
                      key: Key(OrderTypes.readyToPick.value),
                      selected: dayWiseTimeSlots?.readyToPickTimeslots,
                      timeslotsList: timeslots,
                      deleteIds: deleteIds,
                      onChanged: (val, deleted) {
                        PartnerController controller = Provider.of<PartnerController>(context, listen: false);
                        controller.setTimeslots(
                            dayWiseTimeSlotsIndex: dayWiseTimeSlotIndex,
                            selectedTimeSlots: val,
                            orderTypes: OrderTypes.readyToPick);
                        deleteIds = deleted;
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            if (deliveryAvailable == true)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                    child: Text(
                      "${OrderTypes.delivery.value} Time Slots",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16),
                    child: MultiTimeCard(
                      key: Key(OrderTypes.delivery.value),
                      selected: dayWiseTimeSlots?.deliveryTimeslots,
                      timeslotsList: timeslots,
                      deleteIds: deleteIds,
                      onChanged: (val, deleted) {
                        PartnerController controller = Provider.of<PartnerController>(context, listen: false);
                        controller.setTimeslots(
                            dayWiseTimeSlotsIndex: dayWiseTimeSlotIndex,
                            selectedTimeSlots: val,
                            orderTypes: OrderTypes.delivery);

                        deleteIds = deleted;
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
      bottomNavigationBar: timeslots.haveData
          ? CustomButton(
              height: 45,
              text: editMode == true ? "Update" : "Continue",
              backgroundColor: primaryColor,
              fontSize: 18,
              onPressed: () {
                nextSetup();
              },
              mainAxisAlignment: MainAxisAlignment.center,
              margin: const EdgeInsets.all(16),
            )
          : const SizedBox(),
    );
  }

  Future nextSetup() async {
    if (context.read<PartnerController>().validateDayWiseTimeSlots()) {
      context.read<PartnerController>().addPartnerTimeslot(
            context: context,
            route: route,
            type: type,
            editMode: editMode,
            timeLineUpdate: timeLineUpdate,
            deleteIds: deleteIds,
            date: selectedDate,
            deliveryAvailable: deliveryAvailable,
            selectedOrderTypes: selectedOrderTypes,
          );
    } else {
      String error = "Something went wrong";

      showSnackBar(
          context: context,
          text: error,
          color: Colors.red,
          textColor: Colors.white,
          icon: Icons.error_outline);
    }
  }

  Future fetchPartnerTimeslots() async {
    PartnerController partnerController = Provider.of<PartnerController>(context, listen: false);
    await partnerController.fetchPartnerTimeslots(
      context: context,
      date: selectedDate,
      timeLineTimeslots: timeLineUpdate,
    );
  }
}
