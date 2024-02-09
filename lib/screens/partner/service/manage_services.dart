import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/controllers/partner/partner_controller.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/core/services/database/local_database.dart';
import 'package:gaas/models/partner/services/utils/multi_services_picker.dart';
import 'package:gaas/utils/validators.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/dashboard_controller.dart';
import '../../../../core/constant/colors.dart';
import '../../../../core/enums/enums.dart';
import '../../../../models/partner/category_model.dart';
import '../../../../utils/widgets/custom_bottom_sheet.dart';
import '../../../../utils/widgets/custom_button.dart';
import '../../../../utils/widgets/custom_text_field.dart';
import '../../../../utils/widgets/widgets.dart';
import '../../../controllers/partner/service_provider_controller.dart';
import '../../../core/constant/constant.dart';
import '../../../core/constant/shadows.dart';
import '../../../models/partner/auth/partner_model.dart';
import '../../../models/partner/services/my_service_model.dart';
import '../../../models/partner/services/services_model.dart';
import '../../../utils/file_picker_controller.dart';
import '../../../utils/widgets/image_view.dart';
import '../utils/partner_app_bar.dart';

class ManageService extends StatefulWidget {
  const ManageService({super.key, this.registerMode});

  final bool? registerMode;

  @override
  State<ManageService> createState() => ManageServiceState();
}

class ManageServiceState extends State<ManageService> {
  late bool? registerMode = widget.registerMode;

  ServiceType type = ServiceType.serviceProvider;
  LocalDatabase localDatabase = LocalDatabase();
  PartnerData? partnerData;
  late TextEditingController about = TextEditingController();

  GlobalKey<FormState> addOffersFormKey = GlobalKey<FormState>();

  List<CategoryData?>? selectedCategory;
  List<CategoryData>? categoryData;

  // List<ServiceImages>? serviceImages = [];

  Future fetchServices() async {
    ServiceProviderController controller = Provider.of<ServiceProviderController>(context, listen: false);
    await controller.fetchServices(context: context);
  }

  List<Subcategory>? selectedCategories;

  List<String> serviceChargesUnits = ["Hour", "Day"];

  late bool showContact = false;
  late bool showEmail = false;

  ServicesModel? servicesModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      PartnerController partnerController = Provider.of<PartnerController>(context, listen: false);
      ServiceProviderController controller = Provider.of<ServiceProviderController>(context, listen: false);
      partnerData = partnerController.partnerData;
      about.text = partnerData?.about ?? "";
      setState(() {});
      controller.clearServiceImages(context);
      servicesModel = await fetchServices();

      showContact = servicesModel?.showContacts == "Yes" ? true : false;
      debugPrint("showContacts ${servicesModel?.showContacts} & $showContact");
      showEmail = servicesModel?.showEmail == "Yes" ? true : false;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    DashboardController dashboardController = Provider.of<DashboardController>(context);
    ServiceProviderController controller = Provider.of<ServiceProviderController>(context);
    categoryData = dashboardController.categoryData;
    servicesModel = controller.servicesModel;
    // serviceImages = controller.serviceImages;
    selectedCategories = controller.selectedCategories();

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: partnerAppBar(
        context: context,
        title: "Manage Service",
        actions: [],
        onBackPress: () {
          context.pop();
        },
      ),
      body: Form(
        key: addOffersFormKey,
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            // if (serviceImages.haveData) ServiceImagesBanner(serviceImages: serviceImages),
            // CustomButton(
            //   height: serviceImages.haveData ? 45 : 160,
            //   text: "Add Service Image".toUpperCase(),
            //   textColor: primaryColor,
            //   backgroundColor: Colors.white,
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   onPressed: () {
            //     pickServiceImages();
            //   },
            // ),

            Container(
              margin: const EdgeInsets.only(left: 16, right: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: defaultBoxShadow(),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  radius: 18,
                  backgroundColor: primaryColor,
                  child: Icon(
                    Icons.person_pin_rounded,
                    color: Colors.white,
                  ),
                ),
                title: Row(
                  children: [
                    const Text(
                      "Contacts Info",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "(${showContact ? 'Public' : 'Only You'})",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  "Your Contacts Info is visible to ${showContact ? 'Public' : 'Only You'}",
                  style: const TextStyle(fontSize: 11),
                ),
                trailing: CupertinoSwitch(
                  value: showContact,
                  activeColor: primaryColor,
                  onChanged: (val) {
                    showContact = val;
                    setState(() {});
                  },
                ),
              ),
            ),
            // Container(
            //   margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     boxShadow: defaultBoxShadow(),
            //     borderRadius: BorderRadius.circular(12),
            //   ),
            //   child: ListTile(
            //     leading: const CircleAvatar(
            //       radius: 18,
            //       backgroundColor: primaryColor,
            //       child: Icon(
            //         Icons.email,
            //         color: Colors.white,
            //       ),
            //     ),
            //     title: Row(
            //       children: [
            //         const Text(
            //           "Email Address",
            //           style: TextStyle(
            //             color: Colors.black,
            //             fontSize: 14,
            //             fontWeight: FontWeight.w700,
            //           ),
            //         ),
            //         const SizedBox(width: 4),
            //         Text(
            //           "(${showEmail ? 'Public' : 'Only You'})",
            //           style: const TextStyle(
            //             color: Colors.black,
            //             fontSize: 12,
            //             fontWeight: FontWeight.w700,
            //           ),
            //         ),
            //       ],
            //     ),
            //     subtitle: Text(
            //       "Your Email Address is visible to ${showEmail ? 'Public' : 'Only You'}",
            //       style: const TextStyle(fontSize: 11),
            //     ),
            //     trailing: CupertinoSwitch(
            //       value: showEmail,
            //       activeColor: primaryColor,
            //       onChanged: (val) {
            //         showEmail = val;
            //         setState(() {});
            //       },
            //     ),
            //   ),
            // ),
            Column(
              children: [
                headingText(text: "Service's", context: context),
                CustomButton(
                  height: 45,
                  text: "Add Service's".toUpperCase(),
                  textColor: primaryColor,
                  backgroundColor: Colors.white,
                  mainAxisAlignment: MainAxisAlignment.center,
                  onPressed: () {
                    CustomBottomSheet.show(
                      context: context,
                      isScrollControlled: false,
                      enableDrag: true,
                      constraints: BoxConstraints(minHeight: size.height * 0.6),
                      physics: const ScrollPhysics(),
                      mainAxisSize: MainAxisSize.max,
                      title: "Select Service's",
                      body: const MultiServicePicker(),
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
                  margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                ),
              ],
            ),
            if (selectedCategories.haveData)
              ListView.builder(
                shrinkWrap: true,
                itemCount: selectedCategories?.length ?? 0,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var data = selectedCategories?.elementAt(index);

                  return Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                "${data?.name}",
                                style: const TextStyle(
                                    color: primaryColor, fontSize: 16, fontWeight: FontWeight.w500),
                                maxLines: 2,
                              ),
                            ),
                            IconButton(
                              visualDensity: VisualDensity.adaptivePlatformDensity,
                              onPressed: () {
                                ServiceProviderController controller =
                                    Provider.of<ServiceProviderController>(context, listen: false);

                                controller.updateSubCategorySelectedStatus(
                                  categoryId: data?.categoryId,
                                  subCategoryId: data?.id,
                                  selected: false,
                                );
                              },
                              icon: const Icon(
                                Icons.cancel_outlined,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: defaultBoxShadow(),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: const CircleAvatar(
                              radius: 18,
                              backgroundColor: primaryColor,
                              child: Icon(
                                Icons.miscellaneous_services_rounded,
                                color: Colors.white,
                              ),
                            ),
                            title: Row(
                              children: [
                                Text(
                                  "${data?.name}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "(${data?.isActive == true ? 'Active' : 'InActive'})",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              "${data?.name} service is ${data?.isActive == true ? 'Active' : 'InActive'}",
                              style: const TextStyle(fontSize: 11),
                            ),
                            trailing: CupertinoSwitch(
                              value: data?.isActive == true,
                              activeColor: primaryColor,
                              onChanged: (val) {
                                controller.updateSubCategoryActiveStatus(
                                  categoryId: data?.categoryId,
                                  subCategoryId: data?.id,
                                  status: data?.isActive,
                                );
                                setState(() {});
                              },
                            ),
                          ),
                        ),

                        // if (data?.isActive == true)
                        Column(
                          children: [
                            if (data?.serviceImages.haveData == true)
                              ServiceImagesBanner(
                                serviceImages: data?.serviceImages,
                              ),
                            CustomButton(
                              height: data?.serviceImages.haveData == true ? 45 : 160,
                              text: "Add ${data?.name} Image".toUpperCase(),
                              textColor: primaryColor,
                              backgroundColor: Colors.white,
                              mainAxisAlignment: MainAxisAlignment.center,
                              onPressed: () {
                                pickServiceImages(subcategory: data);
                              },
                              margin: const EdgeInsets.only(bottom: 16, top: 8),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Padding(
                                      //   padding: const EdgeInsets.only(bottom: 8),
                                      //   child: Text(
                                      //     "Service Charges",
                                      //     style:
                                      //     Theme.of(context).textTheme.labelMedium,
                                      //     maxLines: 1,
                                      //   ),
                                      // ),

                                      CustomTextField(
                                        autofocus: false,
                                        initialValue: "${data?.amount ?? ''}",
                                        hintText: "Service Amount",
                                        borderRadius: 8,
                                        prefixIcon: const Icon(Icons.attach_money),
                                        keyboardType: TextInputType.number,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        hintStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        isDense: true,
                                        isCollapsed: true,
                                        contentPadding: const EdgeInsets.all(8),
                                        margin: EdgeInsets.zero,
                                        validator: (val) {
                                          return Validator.numericValidator(val);
                                        },
                                        onChanged: (val) {
                                          ServiceProviderController controller =
                                              Provider.of<ServiceProviderController>(context, listen: false);

                                          controller.updateSubCategorySelectedAmount(
                                            categoryId: data?.categoryId,
                                            subCategoryId: data?.id,
                                            amount: val,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Padding(
                                    //   padding: const EdgeInsets.only(bottom: 8),
                                    //   child: Text(
                                    //     "Charges Per",
                                    //     style:
                                    //         Theme.of(context).textTheme.labelMedium,
                                    //     maxLines: 2,
                                    //   ),
                                    // ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 12),
                                      padding: const EdgeInsets.only(left: 16, right: 8, top: 10, bottom: 10),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: primaryColor),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          IntrinsicWidth(
                                            child: DropdownButtonFormField(
                                              value: data?.unit,
                                              hint: Text(
                                                "Select Unit",
                                                style: dropDownTextStyle(),
                                                textAlign: TextAlign.right,
                                              ),
                                              isDense: true,
                                              isExpanded: false,
                                              decoration: InputDecoration(
                                                enabled: false,
                                                isDense: true,
                                                isCollapsed: true,
                                                border: underLineBorder(),
                                                errorBorder: underLineBorder(),
                                                enabledBorder: underLineBorder(),
                                                focusedBorder: underLineBorder(),
                                                disabledBorder: underLineBorder(),
                                                focusedErrorBorder: underLineBorder(),
                                                contentPadding: EdgeInsets.zero,
                                              ),
                                              padding: EdgeInsets.zero,
                                              icon: const Padding(
                                                padding: EdgeInsets.only(left: 8),
                                                child: Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: primaryColor,
                                                  size: 22,
                                                ),
                                              ),
                                              dropdownColor: Colors.white,
                                              items: serviceChargesUnits.map((String items) {
                                                return DropdownMenuItem(
                                                  value: items,
                                                  child: Text(
                                                    items,
                                                    style: dropDownTextStyle(),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                ServiceProviderController controller =
                                                    Provider.of<ServiceProviderController>(context,
                                                        listen: false);

                                                controller.updateSubCategorySelectedUnit(
                                                  categoryId: data?.categoryId,
                                                  subCategoryId: data?.id,
                                                  unit: newValue,
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16, bottom: 16),
                              child: Row(
                                children: [
                                  Text(
                                    "About ${data?.name} Service",
                                    style: Theme.of(context).textTheme.titleSmall,
                                  ),
                                ],
                              ),
                            ),
                            CustomTextField(
                              autofocus: false,
                              initialValue: data?.about ?? '',
                              prefixIcon: const Icon(CupertinoIcons.info, size: 20),
                              hintText: "About ${data?.name} Service",
                              minLines: 1,
                              maxLines: 4,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Enter About ${data?.name} Service";
                                }
                                return null;
                              },
                              onChanged: (val) {
                                controller.updateSubCategoryAbout(
                                  categoryId: data?.categoryId,
                                  subCategoryId: data?.id,
                                  about: val,
                                );
                              },
                              margin: const EdgeInsets.only(bottom: 16),
                            ),
                            const Divider(color: primaryColor),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            // headingText(
            //   text: "About Service",
            //   context: context,
            //   padding: const EdgeInsets.only(top: 14, bottom: 8),
            // ),
            //
            // CustomTextField(
            //   autofocus: false,
            //   controller: about,
            //   prefixIcon: const Icon(CupertinoIcons.info, size: 20),
            //   hintText: "About Service",
            //   minLines: 1,
            //   maxLines: 4,
            //   validator: (val) {
            //     if (val!.isEmpty) {
            //       return "Enter About Service";
            //     }
            //     return null;
            //   },
            //   margin: const EdgeInsets.only(top: 14, bottom: 8),
            // ),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomButton(
            height: 45,
            text: "UPDATE",
            mainAxisAlignment: MainAxisAlignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            onPressed: () async {
              if (addOffersFormKey.currentState!.validate()) {
                ServiceProviderController offerController =
                    Provider.of<ServiceProviderController>(context, listen: false);

                await offerController.manageServices(
                  context: context,
                  about: about.text,
                  registerMode: registerMode,
                  // serviceImages: serviceImages,
                  showContacts: showContact,
                  showEmail: showEmail,
                );

                setState(() {});
              } else {
                String error = "Fill All Required Fields ";
                showBanner(text: error, color: Colors.redAccent);
              }
            },
          ),
        ],
      ),
    );
  }

  underLineBorder({Color? color}) {
    return InputBorder.none;
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
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Future<void> addServiceImage({required ImageSource source, required Subcategory? subcategory}) async {
    File? image = await FilePickerController().selectCroppedImage(
      source: source,
      context: context,
      cropStyle: CropStyle.rectangle,
      aspectRatioPresets: thumbnailAspectRatioPresets,
    );

    if (context.mounted) {
      Navigator.pop(context);
      if (image != null) {
        context.read<ServiceProviderController>().uploadServiceImage(
              context: context,
              image: image,
              subcategory: subcategory,
            );
      }
    }
  }

  Future pickServiceImages({
    required Subcategory? subcategory,
  }) async {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(24),
                topLeft: Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Add ${subcategory?.name} Image",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        addServiceImage(source: ImageSource.camera, subcategory: subcategory);
                      },
                      child: pickImageButton(
                        text: "Camera",
                        icon: Icons.camera,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        addServiceImage(source: ImageSource.gallery, subcategory: subcategory);
                      },
                      child: pickImageButton(
                        text: "Gallery",
                        icon: Icons.photo,
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }

  dropDownTextStyle({Color? color, double? fontSize}) {
    return const TextStyle(
      color: Colors.black,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    );
  }
}

class ServiceImagesBanner extends StatelessWidget {
  const ServiceImagesBanner({
    super.key,
    required this.serviceImages,
  });

  final List<ServiceImages>? serviceImages;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        aspectRatio: 16 / 9,
        viewportFraction: 1,
        initialPage: 0,
        enableInfiniteScroll: false,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 1200),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: false,
        enlargeFactor: 0.3,
        scrollDirection: Axis.horizontal,
      ),
      items: List.generate(
        serviceImages?.length ?? 0,
        (index) {
          var data = serviceImages?.elementAt(index);

          return Stack(
            children: [
              ImageView(
                height: 190,
                width: MediaQuery.of(context).size.width,
                networkImage: "${data?.image}",
                backgroundColor: Colors.grey.shade50,
                borderRadiusValue: 12,
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: defaultBoxShadow(),
                onTap: () {},
                fit: BoxFit.cover,
                margin: const EdgeInsets.symmetric(vertical: 8),
              ),
              Positioned(
                top: 8,
                right: 12,
                child: IconButton(
                    onPressed: () {
                      ServiceProviderController controller =
                          Provider.of<ServiceProviderController>(context, listen: false);
                      controller.removeServiceImages(index);
                    },
                    icon: const Icon(
                      Icons.cancel,
                      color: Colors.red,
                    )),
              )
            ],
          );
        },
      ),
    );
  }
}
