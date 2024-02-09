import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaas/controllers/location/location_controller.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/models/dashboard/service/service_provider_detail.dart';
import 'package:gaas/route/route_paths.dart';
import 'package:gaas/screens/map/change_map_location.dart';
import 'package:gaas/screens/partner/signup/utils/city_picker.dart';
import 'package:gaas/screens/partner/signup/utils/country_picker.dart';
import 'package:gaas/screens/partner/signup/utils/state_picker.dart';
import 'package:gaas/utils/widgets/custom_bottom_sheet.dart';
import 'package:gaas/utils/widgets/custom_button.dart';
import 'package:gaas/utils/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../controllers/dashboard_controller.dart';
import '../../../controllers/partner/partner_controller.dart';
import '../../../core/config/app_images.dart';
import '../../../core/constant/colors.dart';
import '../../../core/constant/formatters.dart';
import '../../../core/enums/enums.dart';
import '../../../core/services/database/local_database.dart';
import '../../../models/partner/auth/partner_model.dart';
import '../../../models/partner/category_model.dart';
import '../../../models/partner/countries_model.dart';
import '../../../models/partner/services/my_service_model.dart';
import '../../../models/partner/states_model.dart';
import '../../../utils/file_picker_controller.dart';
import '../../../utils/validators.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/image_opener.dart';
import '../../../utils/widgets/image_view.dart';

class JoinAsPartner extends StatefulWidget {
  const JoinAsPartner({Key? key, required this.type, this.selectedServiceTypes, this.editMode, this.isDirect})
      : super(key: key);
  final bool? editMode;
  final bool? isDirect;
  final ServiceType? type;
  final List<ServiceType>? selectedServiceTypes;

  @override
  State<JoinAsPartner> createState() => _JoinAsPartnerState();
}

class _JoinAsPartnerState extends State<JoinAsPartner> {
  late bool? isDirect = widget.isDirect;
  late bool? editMode = widget.editMode;
  late ServiceType? type = widget.type;
  late List<ServiceType>? selectedServiceTypes = widget.selectedServiceTypes;

  LocalDatabase localDatabase = LocalDatabase();
  late TextEditingController nameCtrl = TextEditingController(text: localDatabase.name ?? "");
  late TextEditingController emailCtrl = TextEditingController(text: localDatabase.email ?? "");
  late TextEditingController mobileCtrl = TextEditingController(text: localDatabase.mobile ?? "");
  late TextEditingController locAddressCtrl = TextEditingController();
  late TextEditingController addressCtrl = TextEditingController();

  String? partnerType = PartnerType.self.value;
  String? documentName = KYCDocumentTypes.ssn.value;
  TextEditingController documentNumberCtrl = TextEditingController();
  List<PlatformFile?>? documents = [];
  List<File?>? images = [];

  TextEditingController businessNameCtrl = TextEditingController();
  TextEditingController businessEmailCtrl = TextEditingController();
  TextEditingController businessMobileCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController pinCodeCtrl = TextEditingController();
  TextEditingController searchCtrl = TextEditingController();

  String? profilePhoto;

  String? countryCode = "+1";
  bool agreePolicy = false;
  double imageRadius = 110;
  File? image;
  GlobalKey<FormState> partnerSignUpKey = GlobalKey<FormState>();
  bool isServiceProvider = false;
  List<CategoryData?>? selectedCategories = [];
  List<CategoryData>? categoryData;

  CountriesData? selectedCountry;
  List<CountriesData>? countriesData;

  StatesData? selectedState;
  List<StatesData>? statesData;

  CategoryData? selectedCity;
  List<CategoryData>? citiesData;
  PartnerData? partnerData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        if (isDirect == true) {
          context
              .read<LocationController>()
              .determinePosition(context: context, showPopup: false, updateLocation: true);
        }
        if (type == ServiceType.serviceProvider) {
          isServiceProvider = true;
          setState(() {});
        }

        PartnerController controllers = Provider.of(context, listen: false);
        DashboardController dashboardController = Provider.of<DashboardController>(context, listen: false);
        controllers.fetchCountries(context: context).then((value) {
          countriesData = value;
          if (countriesData.haveData) {
            selectedCountry = countriesData?.first;
          }
        });
        setState(() {});
        controllers.fetchStates(context: context);
        controllers.fetchCities(context: context);
        if (isServiceProvider == true) {
          dashboardController
              .fetchCategories(context: context, searchKey: searchCtrl.text, type: type)
              .then((value) {
            categoryData = value;
            if (mounted) {
              setState(() {});
            }
          });
        }

        if (editMode == true) {
          controllers.fetchPartnerProfile(context: context).then((value) {
            partnerData = value;
            nameCtrl.text = partnerData?.name ?? nameCtrl.text;
            emailCtrl.text = partnerData?.email ?? emailCtrl.text;
            mobileCtrl.text = partnerData?.mobile ?? mobileCtrl.text;
            locAddressCtrl.text = partnerData?.locAddress ?? "";
            addressCtrl.text = partnerData?.address ?? "";
            pinCodeCtrl.text = partnerData?.pincode ?? pinCodeCtrl.text;
            profilePhoto = partnerData?.profilePhoto;
            documentName = partnerData?.documentName ?? KYCDocumentTypes.ssn.value;
            documentNumberCtrl.text = partnerData?.documentNumber ?? "";

            businessNameCtrl.text = partnerData?.businessName ?? "";
            businessEmailCtrl.text = partnerData?.businessEmail ?? "";
            businessMobileCtrl.text = partnerData?.businessMobile ?? "";
            setState(() {});

            selectedCountry = CountriesData(id: partnerData?.countryId, name: partnerData?.countryName);
            selectedState = StatesData(id: partnerData?.stateId, name: partnerData?.stateName);
            selectedCity = CategoryData(id: partnerData?.cityId, name: partnerData?.cityName);
            setState(() {});
            if (isServiceProvider == true) {
              List<CategoryData?>? newCategories = [];
              for (PartnerCategories? data in partnerData?.categories ?? []) {
                newCategories.add(CategoryData(id: data?.id, name: data?.name));
              }
              selectedCategories = newCategories;
              setState(() {});
            }
          });
        }
      },
    );
  }

  String selectedCategoriesName() {
    List categoriesList = [];
    for (CategoryData? data in selectedCategories ?? []) {
      categoriesList.add(data?.name);
    }

    String categories = categoriesList.isEmpty ? "Select Categories" : categoriesList.join(" ,");
    return categories;
  }

  String selectedCategoriesIds() {
    List categoriesList = [];
    for (CategoryData? data in selectedCategories ?? []) {
      categoriesList.add(data?.id);
    }

    String categories = categoriesList.isEmpty ? "" : categoriesList.join(",");
    return categories;
  }

  @override
  Widget build(BuildContext context) {
    LocationController location = Provider.of<LocationController>(context);
    PartnerController controllers = Provider.of<PartnerController>(context);
    DashboardController dashboardController = Provider.of<DashboardController>(context);
    categoryData = dashboardController.categoryData;

    countriesData = controllers.countriesData;
    statesData = controllers.statesData;
    citiesData = controllers.citiesData;
    partnerData = controllers.partnerData;
    debugPrint("selectedServices $type");
    debugPrint("isDirect $isDirect");

    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: isDirect == true ? onAppExit : null,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            editMode == true ? "Update ${type?.value}" : "Join as a ${type?.value}",
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Form(
            key: partnerSignUpKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                GestureDetector(
                  onTap: () {
                    addImages();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          if (image != null)
                            ImageView(
                              height: imageRadius,
                              width: imageRadius,
                              borderRadiusValue: imageRadius,
                              file: image,
                              fit: BoxFit.cover,
                              border: Border.all(color: Colors.grey.shade200),
                              margin: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 12),
                            )
                          else if (profilePhoto?.isNotEmpty == true)
                            ImageView(
                              height: imageRadius,
                              width: imageRadius,
                              borderRadiusValue: 100,
                              networkImage: "$profilePhoto",
                              fit: BoxFit.cover,
                              border: Border.all(color: Colors.grey.shade200),
                              margin: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 12),
                            )
                          else
                            ImageView(
                              height: imageRadius,
                              width: imageRadius,
                              borderRadiusValue: imageRadius,
                              assetImage: AppImages.avatarImage,
                              fit: BoxFit.cover,
                              border: Border.all(color: Colors.grey.shade200),
                              margin: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 12),
                            ),
                          const Positioned(
                            right: -6,
                            bottom: 10,
                            child: Icon(CupertinoIcons.add_circled_solid, size: 24, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    headingText(text: "Partner Type", context: context),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: SizedBox(
                        height: 42,
                        child: ListView.builder(
                          itemCount: PartnerType.values.length,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            var data = PartnerType.values.elementAt(index);
                            return GestureDetector(
                              onTap: () {
                                partnerType = data.value;
                                if (partnerType == PartnerType.self.value) {
                                  documentName = KYCDocumentTypes.ssn.value;
                                } else {
                                  documentName = KYCDocumentTypes.federalTax.value;
                                }
                                setState(() {});
                              },
                              child: imageChips(
                                firstChip: index == 0,
                                text: data.value,
                                selected: partnerType == data.value,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                if (partnerType == PartnerType.business.value)
                  Column(
                    children: [
                      headingText(text: "Business Details", context: context),
                      CustomTextField(
                        controller: businessNameCtrl,
                        prefixIcon: const Icon(Icons.person, color: primaryColor),
                        validator: (val) {
                          return Validator.nameValidator(val);
                        },
                        labelText: "Business Name",
                        hintText: "Business Name",
                        style: textStyle(),
                        margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
                      ),
                      CustomTextField(
                        controller: businessEmailCtrl,
                        style: textStyle(),
                        prefixIcon: const Icon(Icons.email_outlined, color: primaryColor),
                        validator: (val) {
                          return Validator.emailValidator(val);
                        },
                        labelText: "Business Email",
                        hintText: "Business Email",
                        margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
                      ),
                      CustomTextField(
                        controller: businessMobileCtrl,
                        labelText: "Business Mobile Number",
                        style: textStyle(),
                        keyboardType: TextInputType.number,
                        prefixIcon: const Icon(Icons.call, color: primaryColor),
                        inputFormatters: [
                          PhoneNumberFormatter(),
                          LengthLimitingTextInputFormatter(14),
                        ],
                        validator: (val) {
                          return Validator.validateUSAPhoneNumber(val);
                        },
                        onChanged: (val) {
                          if (val.length == 14) {
                            FocusScope.of(context).unfocus();
                          }
                        },
                        hintText: "Enter Business Mobile Number",
                        margin: const EdgeInsets.only(left: 24, right: 24, top: 14),
                      ),
                    ],
                  ),

                headingText(text: "Personal Details", context: context),
                CustomTextField(
                  controller: nameCtrl,
                  prefixIcon: const Icon(Icons.person, color: primaryColor),
                  validator: (val) {
                    return Validator.nameValidator(val);
                  },
                  labelText: "Name",
                  hintText: "Name",
                  style: textStyle(),
                  margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
                ),
                CustomTextField(
                  controller: emailCtrl,
                  style: textStyle(),
                  prefixIcon: const Icon(Icons.email_outlined, color: primaryColor),
                  validator: (val) {
                    return Validator.emailValidator(val);
                  },
                  labelText: "Email",
                  hintText: "Email",
                  margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
                ),
                CustomTextField(
                  controller: mobileCtrl,
                  labelText: "Mobile Number",
                  style: textStyle(),
                  keyboardType: TextInputType.number,
                  prefixIcon: const Icon(Icons.call, color: primaryColor),
                  limit: 10,
                  validator: (val) {
                    return Validator.numberValidator(val);
                  },
                  hintText: "Enter Mobile Number",
                  margin: const EdgeInsets.only(left: 24, right: 24, top: 14),
                ),
                // if (isDirect == true)
                //   CustomTextField(
                //     controller: passwordCtrl,
                //     prefixIcon: const Icon(Icons.lock_outline, color: primaryColor),
                //     validator: (val) {
                //       return Validator.passwordValidator(val);
                //     },
                //     labelText: "Password",
                //     hintText: "Password",
                //     margin: const EdgeInsets.only(left: 24, right: 24, top: 14),
                //   ),
                GestureDetector(
                  onTap: () async {
                    LocationController location = Provider.of<LocationController>(context, listen: false);

                    loadingDialog(
                      context: context,
                      future: location.determinePosition(
                        context: context,
                        showPopup: false,
                        updateLocation: true,
                        forceRequest: true,
                      ),
                    ).then((value) {
                      LocationController location = Provider.of<LocationController>(context, listen: false);

                      if (location.haveLocationAccess == true && location.haveLocationPermission == true) {
                        if (context.mounted) {
                          context
                              .pushNamed(Routs.changeMapLocation, extra: const ChangeMapLocation())
                              .whenComplete(() {
                            if (location.address?.addressLine?.isNotEmpty == true) {
                              locAddressCtrl.text = location.address?.addressLine ?? "";
                              setState(() {});
                            }
                          });
                        }
                      }
                    });
                  },
                  child: CustomTextField(
                    controller: locAddressCtrl,
                    // enabled: locAddressCtrl.text.isEmpty ? false : true,
                    enabled: false,
                    prefixIcon: const Icon(Icons.my_location_rounded, color: primaryColor),
                    suffixIcon: const Icon(Icons.location_on, color: primaryColor),
                    hintText: "Select Address Location",
                    hintStyle: location.address?.addressLine != null ? textStyle() : null,
                    minLines: 1,
                    maxLines: 2,
                    errorStyle: const TextStyle(color: Colors.red),
                    validator: (val) {
                      if (location.address?.addressLine == null) {
                        return "Select Address Location";
                      }
                      return null;
                    },
                    margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
                  ),
                ),

                CustomTextField(
                  controller: addressCtrl,
                  prefixIcon: const Icon(Icons.location_on, color: primaryColor),
                  hintText: "Enter Address",
                  hintStyle: location.address?.addressLine != null ? textStyle() : null,
                  minLines: 1,
                  maxLines: 2,
                  errorStyle: const TextStyle(color: Colors.red),
                  validator: (val) {
                    if (val?.isEmpty == true) {
                      return "Enter Address";
                    }

                    return null;
                  },
                  margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
                ),
                GestureDetector(
                  onTap: () {
                    CustomBottomSheet.show(
                      context: context,
                      isScrollControlled: false,
                      enableDrag: true,
                      constraints: BoxConstraints(minHeight: size.height * 0.6),
                      physics: const ScrollPhysics(),
                      mainAxisSize: MainAxisSize.max,
                      title: "Select Country",
                      body: CountryPicker(
                        selected: selectedCountry,
                        list: countriesData,
                        onChanged: (CountriesData? value) {
                          selectedCountry = value;
                          setState(() {});
                        },
                      ),
                      showTitleDivider: false,
                    );
                  },
                  child: CustomTextField(
                    enabled: false,
                    errorStyle: const TextStyle(color: Colors.red),
                    prefixIcon: const Icon(CupertinoIcons.globe, color: primaryColor),
                    suffixIcon: const Icon(Icons.arrow_drop_down_rounded, color: primaryColor),
                    hintText: selectedCountry?.name ?? "Select Country",
                    hintStyle: selectedCountry != null ? textStyle() : null,
                    validator: (val) {
                      if (selectedCountry == null) {
                        return "Select Country";
                      }
                      return null;
                    },
                    margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    CustomBottomSheet.show(
                      context: context,
                      isScrollControlled: false,
                      enableDrag: true,
                      constraints: BoxConstraints(minHeight: size.height * 0.6),
                      physics: const ScrollPhysics(),
                      mainAxisSize: MainAxisSize.max,
                      title: "Select State",
                      body: StatePicker(
                        selected: selectedState,
                        list: statesData,
                        onChanged: (StatesData? value) {
                          selectedState = value;
                          setState(() {});
                        },
                      ),
                      showTitleDivider: false,
                    );
                  },
                  child: CustomTextField(
                    enabled: false,
                    errorStyle: const TextStyle(color: Colors.red),
                    prefixIcon: const Icon(CupertinoIcons.location_north, color: primaryColor),
                    suffixIcon: const Icon(Icons.arrow_drop_down_rounded, color: primaryColor),
                    hintText: selectedState?.name ?? "Select State",
                    hintStyle: selectedState != null ? textStyle() : null,
                    validator: (val) {
                      if (selectedState == null) {
                        return "Select State";
                      }
                      return null;
                    },
                    margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    CustomBottomSheet.show(
                      context: context,
                      isScrollControlled: false,
                      enableDrag: true,
                      constraints: BoxConstraints(minHeight: size.height * 0.6),
                      physics: const ScrollPhysics(),
                      mainAxisSize: MainAxisSize.max,
                      title: "Select City",
                      body: CityPicker(
                        selected: selectedCity,
                        list: citiesData,
                        onChanged: (CategoryData? value) {
                          selectedCity = value;
                          setState(() {});
                        },
                      ),
                      showTitleDivider: false,
                    );
                  },
                  child: CustomTextField(
                    enabled: false,
                    errorStyle: const TextStyle(color: Colors.red),
                    prefixIcon: const Icon(Icons.location_city, color: primaryColor),
                    suffixIcon: const Icon(Icons.arrow_drop_down_rounded, color: primaryColor),
                    hintText: selectedCity?.name ?? "Select City",
                    hintStyle: selectedCity != null ? textStyle() : null,
                    validator: (val) {
                      if (selectedCity == null) {
                        return "Select City";
                      }
                      return null;
                    },
                    margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
                  ),
                ),

                headingText(text: "${documentName ?? Document} Number", context: context),
                CustomTextField(
                  controller: documentNumberCtrl,
                  prefixIcon: const Icon(Icons.perm_contact_cal_sharp, color: primaryColor),
                  validator: (val) {
                    return validateDocumentNumber(val: val);
                  },
                  labelText: "${documentName ?? Document} Number",
                  hintText: documentName == KYCDocumentTypes.ssn.value
                      ? "Eg :- (111-22-3333)"
                      : "Enter $documentName Id Number",
                  style: textStyle(),
                  margin: const EdgeInsets.only(left: 24, right: 24),
                ),

                if (editMode != true)
                  Column(
                    children: [
                      headingText(text: "Documents", context: context),
                      Container(
                        height: documents.haveData ? 80 : null,
                        padding: const EdgeInsets.only(right: 16, left: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (documents.haveData)
                              Expanded(
                                child: ListView.builder(
                                  itemCount: documents?.length ?? 0,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (BuildContext context, int index) {
                                    PlatformFile? data = documents?.elementAt(index);

                                    return Stack(
                                      children: [
                                        const Column(
                                          children: [
                                            Icon(
                                              Icons.picture_as_pdf,
                                              size: 80,
                                              color: primaryColor,
                                            )
                                          ],
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 10,
                                          child: Container(
                                            height: 16,
                                            width: 16,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            child: Center(
                                              child: IconButton(
                                                onPressed: () async {
                                                  documents?.removeAt(index);
                                                  setState(() {});
                                                },
                                                icon: const Icon(CupertinoIcons.multiply_circle,
                                                    color: Colors.red),
                                                iconSize: 20,
                                                padding: EdgeInsets.zero,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              )
                            else
                              Expanded(
                                child: CustomButton(
                                  height: 40,
                                  text: "Add ${documentName ?? ""} Documents",
                                  backgroundColor: primaryColor,
                                  fontSize: 14,
                                  onPressed: () {
                                    pickDocuments();
                                  },
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 16),
                                ),
                              ),
                            if (documents.haveData)
                              IconButton(
                                onPressed: () async {
                                  pickDocuments();
                                },
                                icon: const Icon(CupertinoIcons.add_circled),
                                iconSize: 26,
                                padding: const EdgeInsets.only(left: 16),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),

                if (editMode != true)
                  Column(
                    children: [
                      headingText(text: "Images", context: context),
                      Container(
                        height: images.haveData ? 120 : null,
                        padding: const EdgeInsets.only(right: 16, left: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (images.haveData)
                              Expanded(
                                child: SizedBox(
                                  height: 120,
                                  child: ListView.builder(
                                    itemCount: images?.length ?? 0,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (BuildContext context, int index) {
                                      File? data = images?.elementAt(index);

                                      return Stack(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              context.pushNamed(Routs.imageOpener,
                                                  extra: ImageOpener(file: data));
                                            },
                                            child: Column(
                                              children: [
                                                ImageView(
                                                  height: 100,
                                                  width: 100,
                                                  fit: BoxFit.cover,
                                                  borderRadiusValue: 12,
                                                  margin:
                                                      EdgeInsets.only(left: index == 0 ? 16 : 0, right: 8),
                                                  file: data,
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (editMode != true)
                                            Positioned(
                                              top: 8,
                                              right: 12,
                                              child: Container(
                                                height: 19,
                                                width: 19,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(30),
                                                ),
                                                child: Center(
                                                  child: IconButton(
                                                    onPressed: () async {
                                                      images?.removeAt(index);
                                                      setState(() {});
                                                    },
                                                    icon: const Icon(CupertinoIcons.multiply_circle,
                                                        color: Colors.red),
                                                    iconSize: 20,
                                                    padding: EdgeInsets.zero,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              )
                            else
                              Expanded(
                                child: CustomButton(
                                  height: 40,
                                  text: "Add Images",
                                  backgroundColor: primaryColor,
                                  fontSize: 14,
                                  onPressed: () {
                                    pickImages();
                                  },
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 16),
                                ),
                              ),
                            if (images.haveData)
                              IconButton(
                                onPressed: () async {
                                  pickImages();
                                },
                                icon: const Icon(CupertinoIcons.add_circled),
                                iconSize: 26,
                                padding: const EdgeInsets.only(left: 16),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                if (editMode == true && partnerData?.serviceImages.haveData == true)
                  Column(
                    children: [
                      headingText(text: "Images", context: context),
                      if (partnerData?.serviceImages.haveData == true)
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            itemCount: partnerData?.serviceImages?.length ?? 0,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              ServiceImages? data =
                                  partnerData?.serviceImages?.elementAt(index) as ServiceImages?;

                              return Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      context.pushNamed(Routs.imageOpener,
                                          extra: ImageOpener(networkImage: "${data?.image}"));
                                    },
                                    child: Column(
                                      children: [
                                        ImageView(
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                          borderRadiusValue: 12,
                                          margin: EdgeInsets.only(left: index == 0 ? 16 : 0, right: 8),
                                          networkImage: "${data?.image}",
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (editMode != true)
                                    Positioned(
                                      top: 8,
                                      right: 12,
                                      child: Container(
                                        height: 19,
                                        width: 19,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        child: Center(
                                          child: IconButton(
                                            onPressed: () async {
                                              documents?.removeAt(index);
                                              setState(() {});
                                            },
                                            icon:
                                                const Icon(CupertinoIcons.multiply_circle, color: Colors.red),
                                            iconSize: 20,
                                            padding: EdgeInsets.zero,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                        ),
                    ],
                  ),

                if (editMode != true)
                  Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24, top: 12),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            agreePolicy = !agreePolicy;
                            setState(() {});
                          },
                          child: Icon(
                            agreePolicy ? Icons.check_box : Icons.check_box_outline_blank,
                            color: primaryColor,
                            size: 20,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            "I agree terms and conditions and privacy policy",
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ),
                      ],
                    ),
                  ),
                CustomButton(
                  height: 45,
                  text: editMode == true ? "Update" : "Submit",
                  backgroundColor: primaryColor,
                  fontSize: 18,
                  onPressed: () {
                    if (editMode == true) {
                      joinAsPartner();
                    } else {
                      joinAsPartner();
                    }
                  },
                  mainAxisAlignment: MainAxisAlignment.center,
                  margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 16),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextStyle textStyle() {
    return const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500);
  }

  joinAsPartner() {
    LocationController location = Provider.of<LocationController>(context, listen: false);

    if (partnerSignUpKey.currentState?.validate() == true &&
        (editMode == true ? true : (documents.haveData && images.haveData))) {
      FocusScope.of(context).unfocus();
      if (editMode == true) {
        return context.read<PartnerController>().editPartnerProfile(
              context: context,
              id: partnerData?.id,
              type: type,
              name: nameCtrl.text,
              email: emailCtrl.text,
              mobile: mobileCtrl.text,
              countryCode: countryCode,
              latitude: "${location.latitude}",
              longitude: "${location.longitude}",
              locAddress: "${location.address?.addressLine}",
              address: addressCtrl.text,
              countryId: "${selectedCountry?.id}",
              stateId: "${selectedState?.id}",
              cityId: "${selectedCity?.id}",
              pinCode: pinCodeCtrl.text,
              categories: selectedCategoriesIds(),
              profilePhoto: image,
              partnerType: partnerType,
              documentName: documentName,
              documentNumber: documentNumberCtrl.text,
              documents: documents,
              images: images,
              businessName: nameCtrl.text,
              businessEmail: businessEmailCtrl.text,
              businessMobile: businessMobileCtrl.text,
            );
      } else {
        return context.read<PartnerController>().joinAsPartner(
              context: context,
              isDirect: isDirect,
              type: type,
              selectedServiceTypes: selectedServiceTypes,
              name: nameCtrl.text,
              email: emailCtrl.text,
              mobile: mobileCtrl.text,
              password: passwordCtrl.text,
              countryCode: countryCode,
              latitude: "${location.latitude}",
              longitude: "${location.longitude}",
              locAddress:
                  locAddressCtrl.text.isEmpty ? "${location.address?.addressLine}" : locAddressCtrl.text,
              address: addressCtrl.text,
              countryId: "${selectedCountry?.id}",
              stateId: "${selectedState?.id}",
              cityId: "${selectedCity?.id}",
              pinCode: pinCodeCtrl.text,
              categories: selectedCategoriesIds(),
              profilePhoto: image,
              partnerType: partnerType,
              documentName: documentName,
              documentNumber: documentNumberCtrl.text,
              documents: documents,
              images: images,
              businessName: nameCtrl.text,
              businessEmail: businessEmailCtrl.text,
              businessMobile: businessMobileCtrl.text,
            );
      }
    } else {
      String? error = "Select All Required Fields";

      if (images.haveData == false) {
        error = "Images are Required";
      }
      if (documents.haveData == false) {
        error = "Documents are Required";
      }
      String? documentNumberError = validateDocumentNumber(val: documentNumberCtrl.text);

      if (documentNumberError != null) {
        error = documentNumberError;
      }
      // }
      // if (location.address == null) {
      //   error = "Address is Required";
      // } else if (selectedCountry == null) {
      //   error = "Country is Required";
      // } else if (selectedState == null) {
      //   error = "State is Required";
      // } else if (selectedCity == null) {
      //   error = "City is Required";
      // } else if (isServiceProvider ? selectedCategories?.isEmpty == true : false) {
      //   error = "Categories are Required";
      // }
      showSnackBar(context: context, text: error, color: Colors.red, icon: Icons.error_outline);
    }
  }

  headingText({
    required String text,
    EdgeInsets? padding,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    required BuildContext context,
  }) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(left: 24, right: 24, top: 14, bottom: 8),
      child: Row(
        children: [
          Text(
            text,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: fontSize ?? 14,
                  color: color,
                  fontWeight: fontWeight,
                ),
          ),
        ],
      ),
    );
  }

  Future<void> updateProfileImage({required ImageSource source}) async {
    File? pickedImg = await FilePickerController().selectCroppedImage(
      source: source,
      context: context,
      cropStyle: CropStyle.rectangle,
      aspectRatioPresets: profilePictureAspectRatioPresets,
    );
    setState(() {
      if (pickedImg != null) {
        image = File(pickedImg.path);
      }
    });
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Future addImages() async {
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
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Change Profile Pic",
                    style: TextStyle(
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
                        updateProfileImage(source: ImageSource.camera);
                      },
                      child: pickImageButton(
                        text: "Camera",
                        icon: Icons.camera,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        updateProfileImage(source: ImageSource.gallery);
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

  Future<void> pickDocuments() async {
    List<String> allowedExtensions = ['pdf', 'doc'];
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc'],
    );

    for (PlatformFile? file in result?.files ?? []) {
      if (file != null && allowedExtensions.contains("${file.extension}")) {
        documents?.add(file);
        setState(() {});
      } else {
        if (context.mounted) {
          showSnackBar(
              context: context, text: "${file?.extension} File Extension not supported", color: Colors.red);
        }
      }
    }
  }

  Future<void> pickImages() async {
    List<File?>? pickedImages =
        await FilePickerController().pickMultipleImage(context: context, title: "Select Images");

    for (var image in pickedImages ?? []) {
      if (image != null) {
        images?.add(image!);
        setState(() {});
      }
    }
  }

  String? validateDocumentNumber({required String? val}) {
    if (val?.isEmpty == true) {
      return "${documentName ?? Document} Number is Required";
    }
    if (documentName == KYCDocumentTypes.ssn.value) {
      return Validator.validateSSN(val);
    } else if (documentName == KYCDocumentTypes.federalTax.value) {
      // return Validator.validateTIN(val);
    }
    return null;
  }
}
