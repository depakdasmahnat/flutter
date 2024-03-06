import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:mrwebbeast/controllers/guest_controller/guest_controller.dart';
import 'package:provider/provider.dart';

import '../../../controllers/member/member_controller/member_controller.dart';
import '../../../core/config/app_assets.dart';
import '../../../core/constant/constant.dart';
import '../../../core/constant/gradients.dart';
import '../../../core/route/route_paths.dart';

import '../../../core/services/database/local_database.dart';
import '../../../models/member/auth/member_data.dart';
import '../../../utils/widgets/appbar.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../../../utils/widgets/widgets.dart';
import '../../guest/guestProfile/guest_edit_profile.dart';
import '../../guest/guestProfile/guest_faq.dart';
import '../demo/create_demo.dart';

class AddMemberList extends StatefulWidget {
  const AddMemberList({super.key});

  @override
  State<AddMemberList> createState() => _AddMemberListState();
}

class _AddMemberListState extends State<AddMemberList> {
  GlobalKey<DropdownSearchState<String>> dropdownKey = GlobalKey<DropdownSearchState<String>>();
  final switch1 = ValueNotifier<bool>(false);
  List item = ['Hot', 'Worm', 'Cold'];
  int? tabIndex = 0;
  String gender = '';
  String statusSelect = 'Newly Listed';
  String status = 'New';
  String stateId = '';
  String priority = 'Hot';
  String cityId = '';
  String sponsorId = '';
  String refType = '';
  String occupation = '';
  String demoType = '';
  String countryCode = '91';
  File? image;
  bool disability = false;
  TextEditingController dateControlller = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController noOfFamilyController = TextEditingController();
  TextEditingController illnessController = TextEditingController();
  TextEditingController incomeController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController sponsorName = TextEditingController();
  TextEditingController demoDate = TextEditingController();
  TextEditingController demoTime = TextEditingController();
  TextEditingController countryNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<GuestControllers>().fetchState(
            context: context,
          );
      await context.read<MembersController>().fetchSponsor(
            context: context,
          );
      await context.read<MembersController>().fetchOccupation(
            context: context,
          );
    });
    switch1.addListener(() {
      setState(() {
        if (switch1.value) {
          disability = true;
        } else {
          disability = false;
        }
        print("check disablete ${disability}");
      });
    });
  }

  Future<void> updateProfileImage({required ImageSource source}) async {
    final pickedImg = await ImagePicker().pickImage(source: source);
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
                    'Change Profile Pic',
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
                        context: context,
                        text: 'Camera',
                        icon: Icons.camera,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        updateProfileImage(source: ImageSource.gallery);
                      },
                      child: pickImageButton(
                        context: context,
                        text: 'Gallery',
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

  @override
  Widget build(BuildContext context) {
    MemberData? member = context.read<LocalDatabase>().member;
    sponsorName.text = member?.firstName ?? '';
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(size.height * 0.07),
          child: CustomAppBar(
            title: 'Add a Lead',
            showLeadICon: false,
          )),
      body: ListView.builder(
        itemCount: 1,
        padding: EdgeInsets.only(bottom: size.height * 0.12),
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      addImages();
                    },
                    child: Container(
                      height: size.height * 0.14,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
                      child: image != null
                          ? Image.file(File(image?.path ?? ''), fit: BoxFit.contain)
                          : Image.asset(AppAssets.userIcon),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              GestureDetector(
                onTap: () {
                  addImages();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AppAssets.upload, height: size.height * 0.02),
                    const SizedBox(
                      width: 5,
                    ),
                    CustomeText(
                      text: 'Upload Image',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              CustomTextFieldApp(
                controller: firstNameController,
                title: 'First Name',
                mandatory: '*',
                hintText: 'Enter First Name',
              ),
              CustomTextFieldApp(
                controller: lastNameController,
                title: 'Last Name',
                hintText: 'Enter Lead Last Name',
              ),

              CountyTextField(
                title: 'Mobile No.',
                mandatory: '*',
                controller: mobileController,
                onCountryChanged: (v) {
                  countryCode = v.fullCountryCode;
                  countryNameController.text = v.name;
                  print("checl ${v.regionCode}");
                  setState(() {});
                },
              ),
              if (countryCode != '91')
                CustomTextFieldApp(
                  title: 'Country Name',
                  hintText: 'Enter Country Name',
                  controller: countryNameController,
                ),
              CustomTextFieldApp(
                title: ' Email',
                hintText: 'email@gmail.com',
                controller: emailController,
              ),
              CustomDropdown(
                onChanged: (v) {
                  gender = v;
                },
                title: 'Gender',
                listItem: const ['Male', 'Female'],
              ),
              if (countryCode == '91')
                Consumer<GuestControllers>(
                  builder: (context, controller, child) {
                    return CustomDropdown(
                      mandatory: '*',
                      showSearchBox: true,

                      hintText: 'Select State',
                      onChanged: (v) async {
                        stateId = controller.satesModel?.data
                                ?.firstWhere(
                                  (element) {
                                    return element.name == v;
                                  },
                                )
                                .id
                                .toString() ??
                            '';
                        if (stateId.isNotEmpty == true) {
                          await context.read<GuestControllers>().fetchCity(
                                context: context,
                                stateId: stateId,
                              );
                        }
                        print('check state id $stateId');
                      },
                      // selectedItem: stateName,
                      title: 'State',
                      listItem: controller.satesModel?.data?.map((e) => e.name).toList(),
                    );
                  },
                ),
              if (countryCode == '91')
                Consumer<GuestControllers>(
                  builder: (context, controller, child) {
                    return CustomDropdown(
                      mandatory: '*',
                      hintText: 'Select City',
                      showSearchBox: true,
                      onChanged: (v) {
                        cityId = controller.cityModel?.data
                                ?.firstWhere(
                                  (element) {
                                    return element.name == v;
                                  },
                                )
                                .id
                                .toString() ??
                            '';
                      },
                      title: 'City',
                      listItem: controller.cityModel?.data?.map((e) => e.name).toList(),
                    );
                  },
                ),
              // if(countryCode =='91')
              //   CustomTextFieldApp(
              //     title: 'Pin Code',
              //     hintText: 'Enter Pin Code',
              //     mandatory: '*',
              //     controller: pinCodeController,
              //     keyboardType: TextInputType.number,
              //     maxLength: 6,
              //   ),
              CustomTextFieldApp(
                height: size.height * 0.04,
                title: 'Address',
                hintText: 'Enter Address',
                controller: addressController,
              ),
              CustomDropdown(
                title: 'Status',
                hintText: 'Select Lead status',
                onChanged: (v) {
                  if (v == 'Newly Listed') {
                    status = 'New';
                  } else {
                    status = v;
                  }
                  setState(() {});
                },
                selectedItem: statusSelect,
                listItem: const ['Newly Listed', 'Invitation Call', 'Demo Scheduled', 'Follow Up'],
              ),
              if (status == 'Demo Scheduled')
                Column(
                  children: [
                    CustomDropdown(
                      onChanged: (v) {
                        demoType = v;
                      },
                      title: 'Demo Type ',
                      hintText: 'Select Type',
                      listItem: const ['Business', 'Product'],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFieldApp(
                            title: 'Demo Date',
                            hintText: 'dd-mm-yyyy',
                            controller: demoDate,
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2101),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      popupMenuTheme: PopupMenuThemeData(
                                          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                                      cardColor: Colors.white,

                                      colorScheme: Theme.of(context).colorScheme.copyWith(
                                            primary: Colors.white, // <-- SEE HERE
                                            onPrimary: Colors.black, // <-- SEE HERE
                                            onSurface: Colors.white,
                                          ),

                                      // Input
                                      inputDecorationTheme: const InputDecorationTheme(
                                          // labelStyle: GoogleFonts.greatVibes(), // Input label
                                          ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );

                              if (pickedDate != null) {
                                demoDate.text =
                                    "${pickedDate.day.toString().padLeft(2, "0")}-${pickedDate.month.toString().padLeft(2, "0")}-${pickedDate.year}";
                              }
                            },
                          ),
                        ),
                        Expanded(
                          child: CustomTextFieldApp(
                            title: 'Demo Time',
                            hintText: 'hh:mm',
                            readOnly: true,
                            controller: demoTime,
                            onTap: () async {
                              TimeOfDay? time = await showTimePicker(
                                context: context,
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      popupMenuTheme: PopupMenuThemeData(
                                          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                                      cardColor: Colors.white,

                                      colorScheme: Theme.of(context).colorScheme.copyWith(
                                            primary: Colors.white, // <-- SEE HERE
                                            onPrimary: Colors.black, // <-- SEE HERE
                                            onSurface: Colors.white,
                                          ),

                                      // Input
                                      inputDecorationTheme: const InputDecorationTheme(
                                          // labelStyle: GoogleFonts.greatVibes(), // Input label
                                          ),
                                    ),
                                    child: child!,
                                  );
                                },
                                initialTime: TimeOfDay.now(),
                              );

                              if (time != null) {
                                demoTime.text = time.format(context);
                              }
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),

              CustomDropdown(
                hintText: 'Select refType',
                onChanged: (v) {
                  refType = v ?? '';
                },
                // selectedItem: refType,
                title: 'Ref Type',

                listItem: const ['Self', 'Referred'],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 9.0),
                child: CustomeText(
                  text: 'Lead Type',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: size.height * 0.06,
                child: Padding(
                  padding: const EdgeInsets.only(left: 9.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: item.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            tabIndex = index;
                            priority = item[index];
                            print('check $priority');
                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: const Alignment(0.61, -0.79),
                                end: const Alignment(-0.61, 0.79),
                                colors: index == 0
                                    ? [const Color(0xFFFF2600), const Color(0xFFFF6130)]
                                    : index == 1
                                        ? [const Color(0xFFFDDC9C), const Color(0xFFDDA53B)]
                                        : [const Color(0xFF3CDCDC), const Color(0xFF12BCBC)],
                              ),
                              borderRadius: BorderRadius.circular(39),
                              border: tabIndex == index
                                  ? Border.all(color: CupertinoColors.white, width: 2)
                                  : null,
                            ),
                            child: SizedBox(
                              width: size.width * 0.11,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 4, bottom: 4),
                                  child: CustomeText(
                                    text: item[index],
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              Consumer<MembersController>(
                builder: (context, controller, child) {
                  return CustomDropdown(
                    hintText: 'Select Occupation ',
                    onChanged: (v) {
                      var id = controller.fetchOccupationModel?.data?.firstWhere((element) {
                        return element.name == v;
                      }).id;
                      occupation = id.toString();
                    },
                    title: 'Occupation',
                    listItem: controller.fetchOccupationModel?.data?.map((e) {
                      return e.name;
                    }).toList(),
                  );
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextFieldApp(
                      title: 'Date of Birth',
                      hintText: 'dd-mm-yyyy',
                      controller: dateControlller,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2101),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                popupMenuTheme: PopupMenuThemeData(
                                    shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                                cardColor: Colors.white,

                                colorScheme: Theme.of(context).colorScheme.copyWith(
                                      primary: Colors.white, // <-- SEE HERE
                                      onPrimary: Colors.black, // <-- SEE HERE
                                      onSurface: Colors.white,
                                    ),

                                // Input
                                inputDecorationTheme: const InputDecorationTheme(
                                    // labelStyle: GoogleFonts.greatVibes(), // Input label
                                    ),
                              ),
                              child: child!,
                            );
                          },
                        );

                        if (pickedDate != null) {
                          dateControlller.text =
                              "${pickedDate.day.toString().padLeft(2, "0")}-${pickedDate.month.toString().padLeft(2, "0")}-${pickedDate.year}";
                        }
                      },
                      readOnly: true,
                    ),
                  ),
                  Expanded(
                    child: CustomTextFieldApp(
                      title: 'No. of family Members',
                      keyboardType: TextInputType.number,
                      controller: noOfFamilyController,
                      hintText: 'Enter No. of family Members',
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(9),
                child: Container(
                  decoration: ShapeDecoration(
                    color: const Color(0xFF1B1B1B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomeText(
                          text: 'Disability',
                        ),
                        AdvancedSwitch(
                          controller: switch1,
                          thumb: Container(
                            decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                          ),
                          inactiveColor: Colors.grey,
                          borderRadius: const BorderRadius.all(Radius.circular(15)),
                          width: size.height * 0.06,
                          height: size.height * 0.03,
                          // enabled: true,

                          disabledOpacity: 0.5,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              CustomTextFieldApp(
                title: 'Any Illness In Family Members',
                hintText: 'Enter Members',
                controller: illnessController,
              ),
              CustomTextFieldApp(
                title: 'Monthly Income',
                hintText: 'Enter Income',
                controller: incomeController,
                keyboardType: TextInputType.number,
              ),
            ],
          );
        },
      ),
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GradientButton(
            height: 70,
            borderRadius: 18,
            backgroundGradient: primaryGradient,
            backgroundColor: Colors.transparent,
            boxShadow: const [],
            margin: const EdgeInsets.only(left: 16, right: 24),
            onTap: () async {
              await context
                  .read<MembersController>()
                  .addList(
                      context: context,
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                      mobile: mobileController.text,
                      email: emailController.text,
                      gender: gender,
                      leadRefType: 'leadRefType',
                      occupation: 'occupation',
                      dob: dateControlller.text,
                      noOfFamilyMembers: noOfFamilyController.text,
                      illnessInFamily: illnessController.text,
                      stateId: stateId,
                      cityId: cityId,
                      address: addressController.text,
                      pincode: pinCodeController.text,
                      disability: disability == false ? 'No' : 'Yes',
                      monthlyIncome: incomeController.text,
                      sponsorId: '',
                      file: XFile(image?.path ?? ''),
                      leadStatus: status,
                      leadType: priority,
                      demoType: demoType,
                      demoDate: demoDate.text,
                      demoTime: demoTime.text,
                      countryCode: countryCode,
                      countryName: countryNameController.text)
                  .whenComplete(
                () async {
                  await context
                      .read<MembersController>()
                      .fetchLeads(status: 'New', priority: '', page: '1', searchKey: '');
                },
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: GoogleFonts.urbanist().fontFamily,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.02,
          )
        ],
      ),
    );
  }
}

class CountyTextField extends StatefulWidget {
  final String? title;
  final String? mandatory;
  final bool? readOnly;

  void Function(Country)? onCountryChanged;
  final TextEditingController? controller;

  CountyTextField({
    this.title,
    this.controller,
    this.mandatory,
    this.readOnly,
    super.key,
    this.onCountryChanged,
  });

  @override
  State<CountyTextField> createState() => _CountyTextFieldState();
}

class _CountyTextFieldState extends State<CountyTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(9),
      child: Container(
        decoration: ShapeDecoration(
          color: const Color(0xFF1B1B1B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: kPadding, top: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.title ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                    height: 13,
                    child: Text(
                      widget.mandatory ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        height: 1,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14, top: 0),
              child: IntlPhoneField(
                controller: widget.controller,
                decoration: const InputDecoration(hintText: 'Enter Mobile No.', border: InputBorder.none),
                autovalidateMode: AutovalidateMode.disabled,
                initialCountryCode: 'IN',
                // initialValue:'233' ,
                dropdownIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                dropdownIconPosition: IconPosition.trailing,
                disableLengthCheck: true,
                readOnly: widget.readOnly ?? false,
                onCountryChanged: widget.onCountryChanged,
                // onChanged: widget.onChanged
              ),
            ),
          ],
        ),
      ),
    );
  }
}
