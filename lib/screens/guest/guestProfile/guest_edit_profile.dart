import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/controllers/guest_controller/guest_controller.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:provider/provider.dart';

import '../../../core/constant/gradients.dart';
import '../../../core/services/database/local_database.dart';
import '../../../models/guest_Model/fetchGuestProfile.dart';
import '../../../utils/widgets/appbar.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../../../utils/widgets/loading_screen.dart';

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
  String? gender='' ;
  String? genderHint='' ;
  String refType = '';
  String refTypeHint = '';
  String occupation = '';
  String occupationHint = '';
  String stateId = '';
  String stateName = '';
  String cityId = '';
  String cityName = '';
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      fetchGuestProfileModel =
          await context.read<GuestControllers>().fetchGuestProfile(
                context: context,
              );
      await context.read<GuestControllers>().fetchState(
            context: context,
          );
      gender = fetchGuestProfileModel?.data?.gender??'';
      genderHint = fetchGuestProfileModel?.data?.gender??'Select Gender';
      refType = fetchGuestProfileModel?.data?.leadRefType??'';
      refTypeHint = fetchGuestProfileModel?.data?.leadRefType ?? 'Select Ref Type';
      occupation = fetchGuestProfileModel?.data?.occupation??'';
      occupationHint = fetchGuestProfileModel?.data?.occupation??'Select Occupation';
      dateControlller.text = fetchGuestProfileModel?.data?.dob ?? '';
      familyMemberController.text = fetchGuestProfileModel?.data?.noOfFamilyMembers.toString()=='null' ? '':fetchGuestProfileModel?.data?.noOfFamilyMembers.toString()??"";
      diseaseController.text = fetchGuestProfileModel?.data?.illnessInFamily ?? '';
      emailController.text = fetchGuestProfileModel?.data?.email ?? '';
      pinCodeController.text = fetchGuestProfileModel?.data?.pincode ?? '';
      addressController.text = fetchGuestProfileModel?.data?.address ?? '';
      stateName = fetchGuestProfileModel?.data?.stateName ?? 'Select State';
      stateId = fetchGuestProfileModel?.data?.stateId.toString()=='null' ? '':fetchGuestProfileModel?.data?.stateId.toString()??'';
      cityId = fetchGuestProfileModel?.data?.cityId.toString()=='null' ? '':fetchGuestProfileModel?.data?.cityId.toString()??'';
      cityName = fetchGuestProfileModel?.data?.cityName?? 'Select City';
      firsNameController.text = fetchGuestProfileModel?.data?.firstName??'';
      lastNameController.text = fetchGuestProfileModel?.data?.lastName??'';
      mobileController.text = fetchGuestProfileModel?.data?.mobile??'';
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    LocalDatabase localDatabase = Provider.of<LocalDatabase>(context, listen: false);
    // firsNameController.text = localDatabase.guest?.firstName ?? '';
    // lastNameController.text = localDatabase.guest?.lastName ?? '';
    // mobileController.text = localDatabase.guest?.mobile ?? '';
    // emailController.text =localDatabase.guest?.email??'';

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
          return controller.fetchGuestProfileLoader==false?
          const LoadingScreen(message: 'Loading Profile...'):ListView(
            padding: EdgeInsets.only(bottom: size.height * 0.13),
            children: [
              CustomTextFieldApp(
                title: 'First Name',
                controller: firsNameController,
                hintText: 'Enter First Name',
              ),
              CustomTextFieldApp(
                controller: lastNameController,
                title: 'Last Name',
                hintText: 'Enter Last Name',
              ),
              CustomDropdown(
                hintText: genderHint,
                onChanged: (v) {
                  gender = v ?? '';
                },
                title: 'Gender',
                listItem: const ['Male', 'Female'],
              ),
              CustomTextFieldApp(
                controller: mobileController,
                title: 'Mobile No.',
                hintText: 'Enter Mobile No.',
                readOnly: true,
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: Text('+91'),
                ),
              ),
              CustomTextFieldApp(
                controller: emailController,
                title: 'Email',
                hintText: 'email@gmail.com',
              ),
              CustomDropdown(
                hintText:refTypeHint,
                onChanged: (v) {
                  refType = v ?? '';
                },
                // selectedItem: refType,
                title: 'Ref Type',
                listItem: const ['Friend', 'Friend'],
              ),
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
                                    shape: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                cardColor: Colors.white,

                                colorScheme: Theme.of(context)
                                    .colorScheme
                                    .copyWith(
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
                hintText:stateName,
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
                listItem:
                    controller.satesModel?.data?.map((e) => e.name).toList(),
              ),
              Consumer<GuestControllers>(
                builder: (context, controller, child) {
                  return CustomDropdown(
                    hintText:cityName ,
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
                    listItem:
                        controller.cityModel?.data?.map((e) => e.name).toList(),
                  );
                },
              ),
              CustomTextFieldApp(
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
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GradientButton(
            height: 70,
            borderRadius: 18,
            backgroundGradient: primaryGradient,
            backgroundColor: Colors.transparent,
            boxShadow: const [],
            margin: const EdgeInsets.only(
                left: kPadding, right: kPadding, bottom: kPadding),
            onTap: () async {
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
                  illnessInFamily: diseaseController.text);
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
              child: Text(
                title ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.start,
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
  String? title;
  String? hintText;
  List? listItem;
  String? selectedItem;
  TextEditingController? controller;
  final void Function(dynamic)? onChanged;

  CustomDropdown({
    this.title,
    this.hintText,
    this.listItem,
    this.controller,
    this.onChanged,
    this.selectedItem,
    super.key,
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
          children: [
            Padding(
              padding: const EdgeInsets.only(left: kPadding, top: 7),
              child: Text(
                title ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child:
              DropdownSearch<String>(
                dropdownButtonProps: const DropdownButtonProps(
                    padding: EdgeInsets.only(bottom: 10),

                    icon: Icon(
                      CupertinoIcons.chevron_down,
                      size: 18,
                    )),
                // selectedItem: selectedItem,
                popupProps: const PopupProps.menu(
                  menuProps: MenuProps(
                    backgroundColor: Color(0xFF1B1B1B),
                  ),
                  fit: FlexFit.loose,
                  // showSelectedItems: true,
                ),
                items: listItem?.cast<String>() ?? [],
                onChanged: onChanged,
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                      left: 7,
                      top: 7,
                    ),
                    border: InputBorder.none,
                    hintText: hintText?? 'Select Gender',
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
