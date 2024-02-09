import 'package:flutter/material.dart';
import 'package:gaas/core/enums/enums.dart';
import 'package:gaas/route/route_paths.dart';
import 'package:gaas/utils/widgets/custom_button.dart';
import 'package:gaas/utils/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../controllers/auth/auth_controller.dart';
import '../../../core/constant/colors.dart';
import '../../../models/partner/partner_status_model.dart';
import '../../../utils/widgets/custom_check_box.dart';
import 'join_as_partner.dart';

class SelectPartnerService extends StatefulWidget {
  const SelectPartnerService({Key? key, this.requestedMode, this.isDirect}) : super(key: key);
  final bool? requestedMode;
  final bool? isDirect;

  @override
  State<SelectPartnerService> createState() => _SelectPartnerServiceState();
}

class _SelectPartnerServiceState extends State<SelectPartnerService> {
  late bool? requestedMode = widget.requestedMode;
  late bool? isDirect = widget.isDirect;
  GlobalKey<FormState> partnerSignUpKey = GlobalKey<FormState>();
  List<ServiceType> selectedServiceTypes = [];
  PartnerStatusModel? partnerRequestData;

  late List<PartnerStatus>? partnerStatus = [
    partnerRequestData?.freshProduce ?? PartnerStatus(),
    partnerRequestData?.nursery ?? PartnerStatus(),
    partnerRequestData?.serviceProvider ?? PartnerStatus(),
  ];

  late bool partnerServiceRequested = (partnerStatus?.any((element) => element.status != null) == true);
  late bool addMoreServices = requestedMode == true ? (partnerServiceRequested == false) : true;

  @override
  Widget build(BuildContext context) {
    AuthControllers authControllers = Provider.of<AuthControllers>(context);
    partnerRequestData = authControllers.partnerStatusData;

    debugPrint("partnerServiceRequested $partnerServiceRequested");

    return Form(
      key: partnerSignUpKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 16),
            child: Text(
              addMoreServices ? "Join as a GAAS partner" : "Requested For GAAS partner",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                Text(
                  addMoreServices
                      ? "What kind of value you want to add on?"
                      : "Requested Partner Services are ",
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: ServiceType.values.length,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            itemBuilder: (context, index) {
              ServiceType serviceType = ServiceType.values.elementAt(index);

              PartnerStatus? status = partnerStatus?.elementAt(index);
              return CustomCheckbox(
                serviceType: serviceType,
                value: false,
                requestedMode: requestedMode,
                addMoreServices: addMoreServices,
                partnerServiceRequested: partnerServiceRequested,
                status: status,
                selectedServices: selectedServiceTypes,
                onChanged: (newSelectedIds) {
                  setState(() {
                    selectedServiceTypes = newSelectedIds;
                  });
                },
              );
            },
          ),
          if (selectedServiceTypes.isNotEmpty)
            CustomButton(
              height: 45,
              text: "Continue",
              backgroundColor: primaryColor,
              fontSize: 18,
              onPressed: () {
                if (selectedServiceTypes.isNotEmpty) {
                  if (isDirect == true) {
                    context.pushReplacementNamed(Routs.joinAsPartner,
                        extra: JoinAsPartner(
                          type: selectedServiceTypes.first,
                          isDirect: isDirect,
                          selectedServiceTypes: selectedServiceTypes,
                        ));
                  } else {
                    context.pushNamed(Routs.joinAsPartner,
                        extra: JoinAsPartner(
                          type: selectedServiceTypes.first,
                          isDirect: isDirect,
                          selectedServiceTypes: selectedServiceTypes,
                        ));
                  }
                } else {
                  showBanner(text: "Select at least 1 Service.", color: Colors.red);
                }
              },
              mainAxisAlignment: MainAxisAlignment.center,
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            )
        ],
      ),
    );
  }
}
