import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/core/constant/constant.dart';

import '../../core/constant/colors.dart';
import '../../core/enums/enums.dart';
import '../../models/partner/partner_status_model.dart';

class CustomCheckbox extends StatefulWidget {
  final ServiceType serviceType;

  final bool value;
  final bool? requestedMode;
  final bool? partnerServiceRequested;
  final bool addMoreServices;
  final PartnerStatus? status;
  final List<ServiceType> selectedServices;

  final Function(List<ServiceType>) onChanged;

  const CustomCheckbox({
    super.key,
    required this.serviceType,
    required this.value,
    required this.requestedMode,
    required this.partnerServiceRequested,
    required this.selectedServices,
    required this.onChanged,
    this.status,
    required this.addMoreServices,
  });

  @override
  CustomCheckboxState createState() => CustomCheckboxState();
}

class CustomCheckboxState extends State<CustomCheckbox> {
  late bool requestedMode = widget.requestedMode ?? false;
  late bool partnerServiceRequested = widget.partnerServiceRequested ?? false;
  late bool addMoreServices = widget.addMoreServices;
  late bool value = widget.selectedServices.contains(widget.serviceType);
  late ServiceType serviceType = widget.serviceType;
  late PartnerStatus? status = widget.status;
  late bool haveStatus = addMoreServices == true
      ? (status?.status != null && status?.status != PartnerRequests.rejected.value)
      : true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (requestedMode == true ? (partnerServiceRequested ? status?.status != null : true) : true)
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: haveStatus
                ? null
                : () {
                    setState(() {
                      value = !value;
                      if (value) {
                        widget.selectedServices.add(widget.serviceType);
                      } else {
                        widget.selectedServices.remove(widget.serviceType);
                      }
                      widget.onChanged(widget.selectedServices);
                    });
                  },
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              horizontalTitleGap: 0,
              leading: Icon(
                haveStatus ? Icons.check_box : (value ? Icons.check_box : Icons.check_box_outline_blank),
                color: haveStatus ? Colors.grey.shade400 : primaryColor,
              ),
              title: Text(
                "As a ${serviceType.value} Partner",
              ),
              subtitle: status?.message != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        "${status?.message}",
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                  : null,
              trailing: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                  decoration: BoxDecoration(
                    color: partnerStatusColor(status: status?.status).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status?.status ?? "",
                    style: TextStyle(
                        fontSize: 12,
                        color: partnerStatusColor(status: status?.status),
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
