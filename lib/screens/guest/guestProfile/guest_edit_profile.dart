import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mrwebbeast/controllers/guest_controller/guest_controller.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:provider/provider.dart';

import '../../../controllers/member/member_auth_controller.dart';
import '../../../core/config/app_assets.dart';
import '../../../core/constant/gradients.dart';

import '../../../models/guest_Model/fetchGuestProfile.dart';
import '../../../utils/widgets/appbar.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../../../utils/widgets/image_view.dart';
import '../../../utils/widgets/loading_screen.dart';
import '../../../utils/widgets/widgets.dart';
import '../../member/members/add_member_list.dart';
import 'guest_faq.dart';

class GuestEditProfile extends StatefulWidget {
  const GuestEditProfile({super.key});

  @override
  State<GuestEditProfile> createState() => _GuestEditProfileState();
}

class _GuestEditProfileState extends State<GuestEditProfile> {
  FetchGuestProfile? fetchGuestProfileModel;
  TextEditingController dateControlller = TextEditingController();
  TextEditingController firsNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController familyMemberController = TextEditingController();
  TextEditingController diseaseController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController countryNameController = TextEditingController();
  bool? lastName = true;
  String? gender = '';

  String? genderHint = '';

  String refType = '';
  String refTypeHint = '';
  String occupation = '';
  String occupationHint = '';
  String stateId = '';
  String stateName = '';
  String cityId = '';
  String cityName = '';
  String countryCode = '';
  File? image;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      fetchGuestProfileModel = await context.read<GuestControllers>().fetchGuestProfile(
            context: context,
            member: true,
          );
      await context.read<GuestControllers>().fetchState(
            context: context,
          );
      gender = fetchGuestProfileModel?.data?.gender ?? '';
      genderHint = fetchGuestProfileModel?.data?.gender ?? 'Select Gender';
      refType = fetchGuestProfileModel?.data?.leadRefType ?? '';
      refTypeHint = fetchGuestProfileModel?.data?.leadRefType ?? 'Select Ref Type';
      occupation = fetchGuestProfileModel?.data?.occupation ?? '';
      occupationHint = fetchGuestProfileModel?.data?.occupation ?? 'Select Occupation';
      dateControlller.text = fetchGuestProfileModel?.data?.dob ?? '';
      familyMemberController.text = fetchGuestProfileModel?.data?.noOfFamilyMembers.toString() == 'null'
          ? ''
          : fetchGuestProfileModel?.data?.noOfFamilyMembers.toString() ?? "";
      diseaseController.text = fetchGuestProfileModel?.data?.illnessInFamily ?? '';
      emailController.text = fetchGuestProfileModel?.data?.email ?? '';
      pinCodeController.text = fetchGuestProfileModel?.data?.pincode ?? '';
      addressController.text = fetchGuestProfileModel?.data?.address.toString() == 'null'
          ? ''
          : fetchGuestProfileModel?.data?.address;
      stateName = fetchGuestProfileModel?.data?.stateName ?? 'Select State';
      stateId = fetchGuestProfileModel?.data?.stateId.toString() == 'null'
          ? ''
          : fetchGuestProfileModel?.data?.stateId.toString() ?? '';
      cityId = fetchGuestProfileModel?.data?.cityId.toString() == 'null'
          ? ''
          : fetchGuestProfileModel?.data?.cityId.toString() ?? '';
      cityName = fetchGuestProfileModel?.data?.cityName ?? 'Select City';
      firsNameController.text = fetchGuestProfileModel?.data?.firstName ?? '';

      mobileController.text = fetchGuestProfileModel?.data?.mobile ?? '';
      countryCode = fetchGuestProfileModel?.data?.countryCode ?? '91';
      countryNameController.text =fetchGuestProfileModel?.data?.country ?? '';
      if (fetchGuestProfileModel?.data?.lastName.toString() == 'null') {
        lastName = false;
        setState(() {});
      } else {
        lastNameController.text = fetchGuestProfileModel?.data?.lastName.toString()=='null' ? '':fetchGuestProfileModel?.data?.lastName.toString()??'';
      }
    });
    super.initState();
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
    // LocalDatabase localDatabase = Provider.of<LocalDatabase>(context, listen: false);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(size.height * 0.06),
          child: CustomAppBar(
            showLeadICon: true,
            title: 'Edit',
          )),
      body: Consumer<GuestControllers>(
        builder: (context, controller, child) {
          return controller.fetchGuestProfileLoader == false
              ? const LoadingScreen(message: 'Loading Profile...')
              : ListView(
                  padding: EdgeInsets.only(bottom: size.height * 0.13),
                  children: [
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // image==null?
                        // fetchGuestProfileModel?.data?.profilePhoto==null?
                        // ImageView(
                        //   onTap: () async{
                        //     await  addImages();
                        //   },
                        //   height: 100,
                        //   width: 100,
                        //   file: File(image?.path??''),
                        //
                        //   border: Border.all(color: Colors.white),
                        //   borderRadiusValue: 50,
                        //   isAvatar: true,
                        //   margin: const EdgeInsets.only(left: 8, right: 16),
                        //   fit: BoxFit.cover,
                        // ):
                        // ImageView(
                        //   onTap: () async{
                        //     await  addImages();
                        //   },
                        //   height: 100,
                        //   width: 100,
                        //   networkImage: fetchGuestProfileModel?.data?.profilePhoto,
                        //   border: Border.all(color: Colors.white),
                        //   borderRadiusValue: 50,
                        //   isAvatar: true,
                        //   margin: const EdgeInsets.only(left: 8, right: 16),
                        //   fit: BoxFit.cover,
                        // ):
                        // ImageView(
                        //   onTap: () async{
                        //     await  addImages();
                        //   },
                        //   height: 100,
                        //   width: 100,
                        //   networkImage: fetchGuestProfileModel?.data?.profilePhoto,
                        //   border: Border.all(color: Colors.white),
                        //   borderRadiusValue: 50,
                        //   isAvatar: true,
                        //   margin: const EdgeInsets.only(left: 8, right: 16),
                        //   fit: BoxFit.cover,
                        // )
                        ImageView(
                          onTap: () async {
                            await addImages();
                          },
                          height: 100,
                          width: 100,
                          file: File(image?.path ?? ''),
                          networkImage:
                              image == null ? fetchGuestProfileModel?.data?.profilePhoto ?? '' : null,
                          border: Border.all(color: Colors.white),
                          borderRadiusValue: 50,
                          isAvatar: true,
                          margin: const EdgeInsets.only(left: 8, right: 16),
                          fit: BoxFit.cover,
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        await addImages();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(AppAssets.upload, height: size.height * 0.02),
                          const SizedBox(
                            width: 5,
                          ),
                          CustomeText(
                            text: 'Upload image',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    CustomTextFieldApp(
                      title: 'First Name',
                      mandatory: '*',
                      controller: firsNameController,
                      hintText: 'Enter First Name',
                      readOnly: true,
                    ),
                    CustomTextFieldApp(
                      controller: lastNameController,
                      title: 'Last Name',
                      hintText: 'Enter Last Name',
                      readOnly: lastName,
                    ),
                    CustomDropdown(
                      hintText: genderHint,
                      onChanged: (v) {
                        gender = v ?? '';
                      },
                      title: 'Gender',
                      listItem: const ['Male', 'Female'],
                    ),
                    CountyTextField(
                      title: 'Mobile No.',
                      mandatory: '*',
                      controller: mobileController,
                      onCountryChanged: (v) {
                        debugPrint('countryCode ${v.flag}');
                        countryCode = v.fullCountryCode;
                        countryNameController.text = v.name;
                        setState(() {});
                      },
                    ),
                    if (countryCode != '91')
                      CustomTextFieldApp(
                        title: 'Country Name',
                        hintText: 'Enter Country Name',
                        controller: countryNameController,
                      ),
                    // CustomTextFieldApp(
                    //   controller: mobileController,
                    //   mandatory: '*',
                    //   title: 'Mobile No.',
                    //   hintText: 'Enter Mobile No.',
                    //   readOnly: true,
                    //   prefixIcon: Padding(
                    //     padding: EdgeInsets.only(top: 3),
                    //     child: Text(countryCode),
                    //   ),
                    // ),
                    CustomTextFieldApp(
                      controller: emailController,
                      mandatory: '*',
                      title: 'Email',
                      hintText: 'email@gmail.com',
                    ),
                    // CustomDropdown(
                    //   hintText: refTypeHint,
                    //
                    //   onChanged: (v) {
                    //     refType = v ?? '';
                    //   },
                    //   // selectedItem: refType,
                    //   title: 'Ref Type',
                    //   listItem: const ['Friend', 'Family', 'Professional', 'Society', 'Random'],
                    // ),
                    CustomDropdown(
                      hintText: occupationHint,
                      onChanged: (v) {
                        occupation = v ?? '';
                      },
                      title: 'Occupation',
                      listItem: const ['Doctor', 'Doctor'],
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
                                firstDate: DateTime(1750),
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
                            keyboardType: TextInputType.number,
                            controller: familyMemberController,
                            title: 'No. of family Members',
                            hintText: 'Enter No. of family Members',
                          ),
                        ),
                      ],
                    ),
                    CustomTextFieldApp(
                      controller: diseaseController,
                      title: 'Any Disease',
                      hintText: 'Enter Disease',
                    ),
                    CustomDropdown(
                      mandatory: '*',
                      hintText: stateName,
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

                      },
                      // selectedItem: stateName,
                      title: 'State',
                      listItem: controller.satesModel?.data?.map((e) => e.name).toList(),
                    ),
                    Consumer<GuestControllers>(
                      builder: (context, controller, child) {
                        return CustomDropdown(
                          mandatory: '*',
                          hintText: cityName,
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
                    CustomTextFieldApp(
                      mandatory: '*',
                      controller: pinCodeController,
                      title: 'Pin Code',
                      hintText: 'Pin Code',
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                    ),
                    CustomTextFieldApp(
                      controller: addressController,
                      title: 'Address',
                      hintText: 'Enter Address',
                      height: size.height * 0.07,
                    ),
                  ],
                );
        },
      ),
      bottomSheet:
      Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GradientButton(
            height: 70,
            borderRadius: 18,
            backgroundGradient: primaryGradient,
            backgroundColor: Colors.transparent,
            boxShadow: const [],
            margin: const EdgeInsets.only(left: kPadding, right: kPadding, bottom: kPadding),
            onTap: () async {
              await context.read<MemberAuthControllers>().confirmationPopup(
                    context: context,
                    title: 'Confirm Changes',
                    content: 'Are you sure you want to submit the updated profile information ',
                    onPressed: () async {
                      await context.read<GuestControllers>().editProfile(
                          context: context,
                          firstName: firsNameController.text,
                          lastName: lastNameController.text,
                          email: emailController.text,
                          gender: gender,
                          leadRefType: refType,
                          occupation: occupation,
                          dob: dateControlller.text,
                          familyMembers: familyMemberController.text,
                          stateId: stateId,
                          cityId: cityId,
                          pincode: pinCodeController.text,
                          address: addressController.text,
                          illnessInFamily: diseaseController.text,
                          file: XFile(image?.path ?? ''));
                    },
                  );

              // context.pushNamed(Routs.questions);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Submit',
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
        ],
      ),
    );
  }
}

class CustomTextFieldApp extends StatelessWidget {
  final String? title;
  final String? mandatory;
  final Function()? onTap;
  final String? hintText;
  final bool? readOnly;
  final Widget? prefixIcon;
  final double? height;

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final int? maxLength;

  const CustomTextFieldApp({
    this.title,
    this.mandatory,
    this.hintText,
    this.onTap,
    this.controller,
    this.prefixIcon,
    this.height,
    this.readOnly,
    this.keyboardType,
    super.key,
    this.validator,
    this.onChanged,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                    title ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                    height: 13,
                    child: Text(
                      mandatory ?? '',
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
            CustomTextField(
              readOnly: readOnly,
              onTap: onTap,
              height: height ?? size.height * 0.03,
              controller: controller,
              prefixIcon: prefixIcon,
              keyboardType: keyboardType,
              contentPadding: const EdgeInsets.only(left: 1),
              autofocus: true,
              maxLength: maxLength,
              hintText: hintText,
              validator: validator,
              onChanged: onChanged,

              // margin: const EdgeInsets.only(bottom: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDropdown extends StatelessWidget {
  Key? dropDownkey;
  String? title;
  String? hintText;
  String? mandatory;
  List? listItem;
  String? selectedItem;
  bool? showSearchBox;
  TextEditingController? controller;
  EdgeInsetsGeometry? padding;
  final void Function(dynamic)? onChanged;

  CustomDropdown({
    this.title,
    this.dropDownkey,
    this.hintText,
    this.listItem,
    this.controller,
    this.onChanged,
    this.selectedItem,
    this.mandatory,
    this.showSearchBox,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: padding??const EdgeInsets.all(9),
      child: Container(
     
        decoration: BoxDecoration(
          color: const Color(0xFF1B1B1B),
          borderRadius: BorderRadius.circular(16)
        ),
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: kPadding, top: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title ?? '',
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
                      mandatory ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
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
              padding: const EdgeInsets.only(left: 8.0),
              child:
              DropdownSearch<String>(
                key:dropDownkey ,
                dropdownButtonProps: const DropdownButtonProps(
                    padding: EdgeInsets.only(bottom: 10),
                    icon: Icon(
                      CupertinoIcons.chevron_down,
                      size: 16,
                    )),
                // selectedItem: selectedItem,
                popupProps: PopupProps.menu(
                  showSearchBox: showSearchBox ?? false,
                  menuProps: MenuProps(
                    backgroundColor: Color(0xFF1B1B1B),
                  ),
                  fit: FlexFit.loose,
                  // showSelectedItems: true,
                ),
                selectedItem: selectedItem,
                items: listItem?.cast<String>() ?? [],
                onChanged: onChanged,
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(

                    contentPadding: const EdgeInsets.only(
                      left: 7,
                      top: 7,
                     
                    ),

                    constraints: BoxConstraints.loose(Size.fromHeight(size.height*0.055)),
                    border: InputBorder.none,

                    
                    hintText: hintText ?? 'Select Gender',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
