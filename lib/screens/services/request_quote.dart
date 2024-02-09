import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/core/constant/constant.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/utils/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/database/local_database.dart';
import '../../../../utils/widgets/custom_button.dart';
import '../../controllers/services_controller.dart';
import '../../core/constant/colors.dart';
import '../../core/constant/shadows.dart';
import '../../core/enums/enums.dart';
import '../../models/dashboard/service/service_provider_detail.dart';
import '../../models/partner/auth/partner_model.dart';
import '../../utils/validators.dart';
import '../../utils/widgets/widgets.dart';

class RequestQuote extends StatefulWidget {
  const RequestQuote({
    Key? key,
    required this.onSuccess,
    required this.serviceProvider,
    this.selectedService,
  }) : super(key: key);

  final ServiceProviderData? serviceProvider;
  final Services? selectedService;
  final GestureTapCallback? onSuccess;

  @override
  State<RequestQuote> createState() => _RequestQuoteState();
}

class _RequestQuoteState extends State<RequestQuote> {
  late ServiceProviderData? serviceProvider = widget.serviceProvider;

  late VoidCallback? onSuccess = widget.onSuccess;
  LocalDatabase localDatabase = LocalDatabase();

  late TextEditingController nameCtrl = TextEditingController(text: localDatabase.name ?? "");
  late TextEditingController emailCtrl = TextEditingController(text: localDatabase.email ?? "");
  late TextEditingController mobileCtrl = TextEditingController(text: localDatabase.mobile ?? "");

  TextEditingController commentCtrl = TextEditingController();

  final formKey = GlobalKey<FormState>();
  PartnerData? partnerData;
  bool publicContactInfo = true;

  late String? selectedServiceDateType = ServiceDateType.immediately.value;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.selectedService != null) {
        selectService(service: widget.selectedService);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Services>? selectedServices;

  TextEditingController serviceDateCtrl = TextEditingController();

  DateTime? serviceDate;

  pickServiceDate() async {
    var newDate = await showDatePicker(
      context: context,
      initialDate: serviceDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (newDate != null) {
      setState(() {
        serviceDate = newDate;
        if (serviceDate != null) {
          serviceDateCtrl.text = formattedDate(date: serviceDate) ?? "";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ServicesController controller = Provider.of<ServicesController>(context);
    selectedServices = controller.selectedServices();
    return Scaffold(
      appBar: AppBar(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            backButton(context: context),
          ],
        ),
        leadingWidth: 50,
        title: const Text('Request Quote'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              dense: true,
              leading: const CircleAvatar(
                radius: 18,
                backgroundColor: primaryColor,
                child: Icon(
                  Icons.call,
                  color: Colors.white,
                ),
              ),
              title: Text(
                "Contact Info (${publicContactInfo ? "Public" : "Private"})",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                publicContactInfo
                    ? "Your contact info is public"
                    : "Your contact info will not be shared with the service provider",
                style: const TextStyle(color: primaryColor),
              ),
              trailing: CupertinoSwitch(
                value: publicContactInfo,
                activeColor: primaryColor,
                onChanged: (val) {
                  publicContactInfo = !publicContactInfo;
                  setState(() {});
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CustomTextField(
                    //   controller: nameCtrl,
                    //   autofocus: true,
                    //   prefixIcon: const Icon(Icons.person),
                    //   validator: (val) {
                    //     return Validator.nameValidator(val);
                    //   },
                    //   labelText: "Name",
                    //   hintText: "Name",
                    //   margin: const EdgeInsets.only(top: 12),
                    // ),

                    CustomTextField(
                      controller: emailCtrl,
                      autofocus: true,
                      prefixIcon: const Icon(Icons.email_outlined),
                      validator: (val) {
                        return Validator.emailValidator(val);
                      },
                      labelText: "Email",
                      hintText: "Email",
                      margin: const EdgeInsets.only(top: 12),
                    ),
                    CustomTextField(
                      controller: mobileCtrl,
                      autofocus: true,
                      labelText: "Mobile Number",
                      keyboardType: TextInputType.number,
                      prefixIcon: const Icon(Icons.call),
                      limit: 10,
                      hintText: "Enter Mobile Number",
                      margin: const EdgeInsets.only(top: 8),
                    ),

                    CustomTextField(
                      controller: commentCtrl,
                      hintText: "Comment",
                      labelText: "Comment",
                      autofocus: true,
                      minLines: 3,
                      maxLines: 8,
                      margin: const EdgeInsets.only(top: 14, bottom: 14),
                      validator: (val) {
                        if (val?.isEmpty == true) {
                          return "Comment is Required";
                        } else {
                          return null;
                        }
                      },
                    ),

                    Column(
                      children: [
                        Text(
                          "How soon you need service",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),

                    Container(
                      height: 50,
                      margin: const EdgeInsets.only(bottom: 16, top: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: primaryColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: DropdownButtonFormField<String?>(
                          value: selectedServiceDateType,
                          isDense: false,
                          isExpanded: true,
                          hint: const Text("Select Radius"),
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          style: const TextStyle(fontSize: 14, color: Colors.black),
                          dropdownColor: Colors.white,
                          iconEnabledColor: primaryColor,
                          onChanged: (String? newValue) {
                            selectedServiceDateType = newValue;
                            setState(() {});
                          },
                          items: ServiceDateType.values.map((ServiceDateType date) {
                            return DropdownMenuItem<String>(
                              value: date.value,
                              child: Text(date.value),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                            isDense: true,
                            isCollapsed: true,

                            border: InputBorder.none, // Remove the underline
                          ),
                        ),
                      ),
                    ),

                    if (selectedServiceDateType == ServiceDateType.customDate.value)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            controller: serviceDateCtrl,
                            readOnly: true,
                            autofocus: false,
                            onTap: () {
                              pickServiceDate();
                            },
                            labelText: "Service Date",
                            prefixIcon: const Icon(Icons.date_range_outlined),
                            hintText: "Select Service Date",
                            margin: const EdgeInsets.only(top: 8),
                          ),
                        ],
                      ),
                    if (serviceProvider?.services?.haveData == true)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: defaultBoxShadow(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Services",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: serviceProvider?.services?.length ?? 0,
                              itemBuilder: (context, index) {
                                bool lastIndex = ((serviceProvider?.services?.length ?? 0) - 1) == index;
                                var data = serviceProvider?.services?.elementAt(index);
                                return Column(
                                  children: [
                                    ListTile(
                                      dense: true,
                                      contentPadding: const EdgeInsets.only(),
                                      onTap: () {
                                        selectService(service: data);
                                      },
                                      title: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                              data?.selected == true
                                                  ? Icons.check_circle
                                                  : Icons.radio_button_off,
                                              color: data?.selected == true ? primaryColor : Colors.black),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text("${data?.name}"),
                                          ),
                                        ],
                                      ),
                                      trailing: data?.selected == true
                                          ? Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "\$${data?.amount}",
                                                  style: const TextStyle(
                                                      color: primaryColor,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600),
                                                ),
                                                Text(
                                                  data?.unit != null ? " / ${data?.unit}" : "",
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w600),
                                                ),
                                              ],
                                            )
                                          : null,
                                    ),
                                    if (lastIndex != true) const Divider(height: 1)
                                  ],
                                );
                              },
                            ),
                            // if ((controller.selectedServicesPrice() ?? 0) > 0)
                            //   ListTile(
                            //     dense: true,
                            //     contentPadding: const EdgeInsets.only(),
                            //     title: const Row(
                            //       crossAxisAlignment: CrossAxisAlignment.center,
                            //       children: [
                            //         Icon(Icons.attach_money, color: primaryColor),
                            //         SizedBox(width: 8),
                            //         Expanded(
                            //           child: Text("Grand Total"),
                            //         ),
                            //       ],
                            //     ),
                            //     trailing: Text(
                            //       "\$${controller.selectedServicesPrice()}",
                            //       style: const TextStyle(
                            //           color: primaryColor, fontSize: 16, fontWeight: FontWeight.w600),
                            //     ),
                            //   ),
                          ],
                        ),
                      ),

                    // if (selectedServices?.haveData == true)
                    //   Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       CustomButton(
                    //           height: 45,
                    //           width: size.width * 0.7,
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           text: "Request",
                    //           fontSize: 16,
                    //           margin: const EdgeInsets.only(bottom: 16, top: 24),
                    //           onPressed: () {
                    //             requestQuote(onSuccess: onSuccess);
                    //           }),
                    //     ],
                    //   ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: (selectedServices?.haveData == true)
          ? CustomButton(
              height: 45,
              mainAxisAlignment: MainAxisAlignment.center,
              text: "Request",
              fontSize: 16,
              margin: const EdgeInsets.only(bottom: 16, top: 24, left: 16, right: 16),
              onPressed: () {
                requestQuote(onSuccess: onSuccess);
              })
          : null,
    );
  }

  Future requestQuote({required GestureTapCallback? onSuccess}) async {
    if (formKey.currentState?.validate() == true) {
      context.read<ServicesController>().requestQuote(
            context: context,
            partnerId: serviceProvider?.id,
            name: nameCtrl.text,
            email: emailCtrl.text,
            mobile: mobileCtrl.text,
            comment: commentCtrl.text,
            publicContactInfo: publicContactInfo,
            serviceDateType: selectedServiceDateType,
            serviceDate: serviceDateCtrl.text,
            onSuccess: onSuccess,
          );
    } else {}
  }

  void selectService({required Services? service}) {
    ServicesController servicesController = Provider.of<ServicesController>(context, listen: false);

    servicesController.updateServicesStatus(
      serviceId: service?.id,
      selected: service?.selected ?? false,
    );

    setState(() {});
  }
}
