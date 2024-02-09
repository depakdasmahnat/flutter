import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/controllers/partner/partner_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/dashboard_controller.dart';
import '../../../../controllers/partner/offers/offers_controller.dart';
import '../../../../core/constant/colors.dart';
import '../../../../core/enums/enums.dart';
import '../../../../models/partner/category_model.dart';
import '../../../../models/partner/offers/partner_offers_model.dart';
import '../../../../utils/widgets/custom_bottom_sheet.dart';
import '../../../../utils/widgets/custom_button.dart';
import '../../../../utils/widgets/custom_text_field.dart';
import '../../../../utils/widgets/widgets.dart';
import '../../signup/utils/category_picker.dart';
import '../../utils/partner_app_bar.dart';

class AddOffer extends StatefulWidget {
  const AddOffer({super.key, this.offersData, required this.index});

  final int? index;

  final PartnerOffersData? offersData;

  @override
  State<AddOffer> createState() => AddOfferState();
}

class AddOfferState extends State<AddOffer> {
  late int? index = widget.index;
  late PartnerOffersData? offersData = widget.offersData;

  ServiceType? type;
  late TextEditingController discountName = TextEditingController(text: offersData?.name ?? "");
  late TextEditingController offerCode = TextEditingController(text: offersData?.code ?? "");
  late TextEditingController eligibilityType = TextEditingController(text: offersData?.eligibilityType ?? "");

  late TextEditingController discountPercentage = TextEditingController(text: "${offersData?.percent ?? ""}");
  late TextEditingController maxUsers = TextEditingController(text: "${offersData?.maxUser ?? ""}");

  DateTime? startDate;
  late TextEditingController startDateText = TextEditingController(text: offersData?.startDate ?? "");
  DateTime? endDate;
  late TextEditingController endDateText = TextEditingController(text: offersData?.endDate ?? "");

  late TextEditingController discountUPtoText = TextEditingController(text: offersData?.discountUpto ?? "");
  late TextEditingController amountText = TextEditingController(text: offersData?.amount ?? "");
  late TextEditingController maxAmountText = TextEditingController(text: offersData?.maxValidAmount ?? "");
  GlobalKey<FormState> addOffersFormKey = GlobalKey<FormState>();
  CategoryData? selectedCategory;
  List<CategoryData>? categoryData;

  pickStartDate() async {
    var newDate = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 30),
      lastDate: DateTime(DateTime.now().year + 30),
    );

    if (newDate != null) {
      setState(() {
        startDate = newDate;
        startDateText.text = "${startDate!.day}-${startDate!.month}-${startDate!.year}";
      });
    }
  }

  pickEndDate() async {
    var newDate = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 30),
      lastDate: DateTime(DateTime.now().year + 30),
    );

    if (newDate != null) {
      setState(() {
        endDate = newDate;
        endDateText.text = "${endDate!.day}-${endDate!.month}-${endDate!.year}";
      });
    }
  }

  late String? selectedOfferClaimType = offersData?.claimType ?? OfferClaimType.percent.value;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      PartnerController partnerController = Provider.of<PartnerController>(context, listen: false);
      type = partnerController.serviceType;
      DashboardController dashboardController = Provider.of<DashboardController>(context, listen: false);
      dashboardController.fetchCategories(context: context, type: type).then((value) {
        categoryData = value;
        setState(() {});
      });

      if (offersData != null) {
        selectedCategory = CategoryData(id: offersData?.categoryId, name: offersData?.categoryName);
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DashboardController dashboardController = Provider.of<DashboardController>(context);
    categoryData = dashboardController.categoryData;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: partnerAppBar(
        context: context,
        title: "Add Offers",
        onBackPress: () {
          context.pop();
        },
        actions: [
          if (index != null)
            IconButton(
              onPressed: () {
                OffersController offerController = Provider.of<OffersController>(context, listen: false);
                offerController.deletePartnerCouponPopUp(context: context, id: offersData?.id);
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            )
          else
            const SizedBox()
        ],
      ),
      body: Form(
        key: addOffersFormKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            headingText(text: "Offer Name", context: context),
            CustomTextField(
              autofocus: true,
              controller: discountName,
              prefixIcon: const Icon(CupertinoIcons.doc_fill, size: 20),
              hintText: "Offer Name",
              validator: (val) {
                if (val!.isEmpty) {
                  return "Enter Offer Name";
                }
                return null;
              },
            ),
            headingText(text: "Offer Code", context: context),
            CustomTextField(
              autofocus: true,
              controller: offerCode,
              prefixIcon: const Icon(CupertinoIcons.doc_fill, size: 20),
              hintText: "Offer Code",
              validator: (val) {
                if (val!.isEmpty) {
                  return "Enter Offer Code";
                }
                return null;
              },
            ),
            headingText(text: "Offer Start Date", context: context),
            InkWell(
              onTap: () {
                pickStartDate();
                FocusScope.of(context).unfocus();
              },
              child: CustomTextField(
                enabled: false,
                controller: startDateText,
                prefixIcon: const Icon(Icons.calendar_month),
                errorStyle: const TextStyle(color: Colors.red),
                hintText: startDateText.text.isEmpty ? "Offer Start Date" : startDateText.text,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Enter Offer Start Date";
                  }
                  return null;
                },
              ),
            ),
            headingText(text: "Offer End Date", context: context),
            InkWell(
              onTap: () {
                pickEndDate();
                FocusScope.of(context).unfocus();
              },
              child: CustomTextField(
                enabled: false,
                controller: endDateText,
                prefixIcon: const Icon(Icons.calendar_month),
                errorStyle: const TextStyle(color: Colors.red),
                hintText: endDateText.text.isEmpty ? "Offer End Date" : startDateText.text,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Enter Offer End Date";
                  }
                  return null;
                },
              ),
            ),
            headingText(text: "Maximum Users Limit", context: context),
            CustomTextField(
              autofocus: true,
              controller: maxUsers,
              keyboardType: TextInputType.phone,
              prefixIcon: const Icon(CupertinoIcons.person_2_square_stack, size: 20),
              hintText: "Maximum Users Limit",
              validator: (val) {
                if (val!.isEmpty) {
                  return "Enter Maximum Users Limit";
                }
                return null;
              },
            ),
            headingText(text: "Eligibility Order Type", context: context),
            InkWell(
              onTap: () {
                selectPackagePopup(
                  title: "Select Eligibility Order Type",
                  selected: eligibilityType.text,
                  dataList: EligibilityOrderType.values,
                ).then((value) {
                  if (value != null) {
                    eligibilityType.text = value;
                    setState(() {});
                  }
                });
              },
              child: CustomTextField(
                controller: eligibilityType,
                enabled: false,
                prefixIcon: const Icon(Icons.accessibility_new_rounded, size: 20),
                hintText: "Eligibility Order Type",
                errorStyle: const TextStyle(color: Colors.red),
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Select Eligibility Order Type";
                  }
                  return null;
                },
              ),
            ),
            if (eligibilityType.text == EligibilityOrderType.orderCategory.value)
              Column(
                children: [
                  headingText(text: "Category", context: context),
                  GestureDetector(
                    onTap: () {
                      CustomBottomSheet.show(
                        context: context,
                        isScrollControlled: false,
                        enableDrag: true,
                        constraints: BoxConstraints(minHeight: size.height * 0.6),
                        physics: const ScrollPhysics(),
                        mainAxisSize: MainAxisSize.max,
                        title: "Select Category",
                        body: CategoryPicker(
                          selected: selectedCategory,
                          list: categoryData,
                          onChanged: (CategoryData? value) {
                            selectedCategory = value;
                            setState(() {});
                          },
                        ),
                        bottomNavBar: CustomButton(
                          height: 45,
                          text: "Continue",
                          backgroundColor: primaryColor,
                          fontSize: 18,
                          onPressed: () {
                            context.pop();
                          },
                          mainAxisAlignment: MainAxisAlignment.center,
                          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        ),
                        showTitleDivider: false,
                      );
                    },
                    child: CustomTextField(
                      autofocus: true,
                      enabled: false,
                      errorStyle: const TextStyle(color: Colors.red),
                      prefixIcon: const Icon(Icons.category_outlined, color: primaryColor),
                      suffixIcon: const Icon(Icons.arrow_drop_down_rounded, color: primaryColor),
                      hintText: selectedCategory?.name ?? "Select Category",
                      hintStyle: const TextStyle(color: primaryColor, fontSize: 13, fontWeight: FontWeight.w500),
                      validator: (val) {
                        return null;
                      },
                      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    ),
                  ),
                ],
              ),
            Column(
              children: [
                headingText(text: "Offer Claim Type", context: context),
                SizedBox(
                  height: 42,
                  child: ListView.builder(
                    itemCount: OfferClaimType.values.length,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      var data = OfferClaimType.values.elementAt(index);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedOfferClaimType = data.value;
                          });
                        },
                        child: imageChips(
                          firstChip: index == 0,
                          text: data.value,
                          selected: selectedOfferClaimType == data.value,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            if (selectedOfferClaimType == OfferClaimType.percent.value)
              Column(
                children: [
                  headingText(text: "Discount Percent", context: context),
                  CustomTextField(
                    autofocus: true,
                    controller: discountPercentage,
                    keyboardType: TextInputType.phone,
                    prefixIcon: const Icon(CupertinoIcons.percent, size: 20),
                    hintText: "Discount Percent",
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Enter Discount Percent";
                      }
                      return null;
                    },
                  ),
                  headingText(text: "Discount upto", context: context),
                  CustomTextField(
                    autofocus: true,
                    controller: discountUPtoText,
                    keyboardType: TextInputType.number,
                    prefixIcon: const Icon(Icons.attach_money),
                    hintText: "Discount upto",
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Enter Discount uPto";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            if (selectedOfferClaimType == OfferClaimType.amount.value)
              Column(
                children: [
                  headingText(text: "Amount", context: context),
                  CustomTextField(
                    autofocus: true,
                    controller: amountText,
                    keyboardType: TextInputType.number,
                    prefixIcon: const Icon(Icons.attach_money),
                    hintText: "Amount",
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Enter Amount";
                      }
                      return null;
                    },
                  ),
                  headingText(text: "Minimum Valid Amount", context: context),
                  CustomTextField(
                    autofocus: true,
                    controller: maxAmountText,
                    keyboardType: TextInputType.number,
                    prefixIcon: const Icon(Icons.attach_money),
                    hintText: "Minimum valid Amount",
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Enter Minimum valid Amount";
                      }
                      return null;
                    },
                  ),
                ],
              )
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomButton(
            height: 45,
            text: index != null ? "Update" : "Add",
            mainAxisAlignment: MainAxisAlignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            onPressed: () async {
              if (addOffersFormKey.currentState!.validate() && selectedOfferClaimType?.isNotEmpty == true) {
                OffersController offerController = Provider.of<OffersController>(context, listen: false);

                if (offersData?.id == null) {
                  await offerController.addOffer(
                    context: context,
                    name: discountName.text,
                    code: offerCode.text,
                    startDate: startDateText.text,
                    endDate: endDateText.text,
                    maxUser: maxUsers.text,
                    eligibilityType: eligibilityType.text,
                    categoryId: "${selectedCategory?.id ?? ""}",
                    claimType: selectedOfferClaimType,
                    discountUPto: discountUPtoText.text,
                    percent: discountPercentage.text,
                    amount: amountText.text,
                    maxValidAmount: maxAmountText.text,
                  );
                } else {
                  await offerController.editOffer(
                    id: offersData?.id,
                    context: context,
                    name: discountName.text,
                    code: offerCode.text,
                    startDate: startDateText.text,
                    endDate: endDateText.text,
                    maxUser: maxUsers.text,
                    eligibilityType: eligibilityType.text,
                    categoryId: "${selectedCategory?.id ?? ""}",
                    claimType: selectedOfferClaimType,
                    discountUPto: discountUPtoText.text,
                    percent: discountPercentage.text,
                    amount: amountText.text,
                    maxValidAmount: maxAmountText.text,
                  );
                }

                setState(() {});
                setState(() {});
              } else {
                String error = "Fill All Required Fields ";
                if (selectedOfferClaimType?.isEmpty == true) {
                  error = "Select Service Type";
                }
                showBanner(text: error, color: Colors.redAccent);
              }
            },
          ),
        ],
      ),
    );
  }

  Future<String?> selectPackagePopup({
    required String title,
    required String? selected,
    required List? dataList,
  }) async {
    String? selectedData;

    await CustomBottomSheet.show(
      context: context,
      isScrollControlled: false,
      enableDrag: true,
      physics: const BouncingScrollPhysics(),
      title: title,
      body: StatefulBuilder(
        builder: (context, setState) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: dataList?.length,
            itemBuilder: (context, index) {
              var data = dataList?.elementAt(index);

              return Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selectedData = data.value;
                      FocusScope.of(context).unfocus();
                      Navigator.pop(context);
                    });
                  },
                  child: Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade200)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        headingText(text: data.value, context: context),
                        (selected == data.value)
                            ? const Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Colors.green)
                            : Icon(Icons.circle, color: Colors.grey.shade200),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
    return selectedData;
  }

  Future showPop({
    required BuildContext context,
    final int? index,
    final PartnerOffersData? offersData,
  }) async {
    Size size = MediaQuery.of(context).size;
    await CustomBottomSheet.show(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      centerTitle: true,
      margin: EdgeInsets.only(top: size.height * 0.12),
      physics: const BouncingScrollPhysics(),
      title: "Add Offer",
      body: AddOffer(
        index: index,
        offersData: offersData,
      ),
    );
  }

  headingText({
    required String text,
    EdgeInsets? padding,
    required BuildContext context,
  }) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(left: 16, right: 16, top: 14, bottom: 8),
      child: Row(
        children: [
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
