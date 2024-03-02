import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/route/route_paths.dart';
import 'package:mrwebbeast/screens/guest/guestProfile/guest_faq.dart';
import 'package:mrwebbeast/utils/widgets/appbar.dart';
import 'package:provider/provider.dart';

import '../../../controllers/guest_controller/guest_controller.dart';
import '../../../controllers/member/member_controller/member_controller.dart';
import '../../../core/config/app_assets.dart';
import '../../../core/constant/gradients.dart';

import '../../../models/guest_Model/fetchGuestProfile.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../../../utils/widgets/image_view.dart';
import '../../../utils/widgets/loading_screen.dart';
import '../../../utils/widgets/widgets.dart';
import '../../guest/guestProfile/guest_edit_profile.dart';

class MemberEditProfile extends StatefulWidget {
  const MemberEditProfile({super.key});

  @override
  State<MemberEditProfile> createState() => _MemberEditProfileState();
}

class _MemberEditProfileState extends State<MemberEditProfile> {
  final switch1 = ValueNotifier<bool>(true);
  String gender = '';
  String genderHint = '';
  String stateId = '';
  String stateHint = '';
  String cityId = '';
  String cityHint= '';
  String occupation = '';
  String sponsorId = '';
  String sponsorHint = '';
  bool? disability = false;
  File? image;
  String occupationHint = '';
  FetchGuestProfile? fetchGuestProfileModel;
  TextEditingController dateController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController noOfFamilyController = TextEditingController();
  TextEditingController illnessController = TextEditingController();
  TextEditingController monthlyIncomeController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController enagicIdController = TextEditingController();
  TextEditingController enagicPassController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<GuestControllers>().fetchGuestProfile(
            context: context,
          );
      await context.read<GuestControllers>().fetchState(
            context: context,
          );
      // await context.read<MembersController>().fetchFacilitator(
      //   context: context,
      // );
      await context.read<MembersController>().fetchSponsor(
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
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(size.height * 0.07),
          child: CustomAppBar(
            title: 'Edit Profile',
            showLeadICon: false,
          )),
      body: Consumer<GuestControllers>(
        builder: (context, controller, child) {
          firstNameController.text =
              controller.fetchGuestProfileModel?.data?.firstName ?? '';
          lastNameController.text =
              controller.fetchGuestProfileModel?.data?.lastName ?? '';
          mobileController.text =
              controller.fetchGuestProfileModel?.data?.mobile ?? '';
          emailController.text =
              controller.fetchGuestProfileModel?.data?.email ?? '';
          noOfFamilyController.text = controller
                  .fetchGuestProfileModel?.data?.noOfFamilyMembers
                  .toString()=='null' ?'':controller
              .fetchGuestProfileModel?.data?.noOfFamilyMembers
              .toString()??
              '';
          illnessController.text = controller.fetchGuestProfileModel?.data?.illnessInFamily ?? '';
          pinCodeController.text = controller.fetchGuestProfileModel?.data?.pincode ?? '';
          monthlyIncomeController.text = controller.fetchGuestProfileModel?.data?.monthlyIncome ?? '';
          addressController.text = controller.fetchGuestProfileModel?.data?.address ?? '';
          enagicIdController.text = controller.fetchGuestProfileModel?.data?.enagicId ?? '';
          genderHint = controller.fetchGuestProfileModel?.data?.gender ?? '';
          stateId = controller.fetchGuestProfileModel?.data?.stateId.toString()=='null'?'':controller.fetchGuestProfileModel?.data?.stateId.toString()??'';
          stateHint = controller.fetchGuestProfileModel?.data?.stateName ??
              'Select State';
          gender = controller.fetchGuestProfileModel?.data?.gender ?? 'Select Gender';
          cityId = controller.fetchGuestProfileModel?.data?.cityId.toString()=='null' ? '':controller.fetchGuestProfileModel?.data?.cityId.toString()??'';
          sponsorId = controller.fetchGuestProfileModel?.data?.sponsorId.toString()??'';
          sponsorHint = controller.fetchGuestProfileModel?.data?.sponsorName.toString()=='null' ? '':controller.fetchGuestProfileModel?.data?.sponsorName.toString()??'';
          cityHint = controller.fetchGuestProfileModel?.data?.cityName?? 'Select City';
          occupationHint = controller.fetchGuestProfileModel?.data?.occupation ??
              'Select Occupation';
          occupation =
              controller.fetchGuestProfileModel?.data?.occupation ?? '';
          return controller.fetchGuestProfileLoader == false
              ? const LoadingScreen(message: 'Loading Profile...')
              : ListView(
                  padding: EdgeInsets.only(bottom: size.height * 0.12),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ImageView(
                          onTap: () async{
                            await  addImages();
                          },
                          height: 100,

                          file: File(image?.path??''),
                          border: Border.all(color: Colors.white),
                          borderRadiusValue: 50,
                          isAvatar: true,
                          margin: const EdgeInsets.only(left: 8, right: 16),
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AppAssets.upload,
                            height: size.height * 0.02),
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
                    CustomTextFieldApp(
                      controller: firstNameController,
                      title: 'First Name',
                      hintText: 'Enter First Name',
                    ),
                    CustomTextFieldApp(
                      controller: lastNameController,
                      title: 'Last Name',
                      hintText: 'Enter Last Name',
                    ),
                    CustomTextFieldApp(
                      controller: mobileController,
                      title: 'Mobile No.',
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      hintText: 'Enter Mobile No.',
                    ),
                    CustomDropdown(

                      hintText: genderHint,
                      onChanged: (v) {
                        gender = v;
                      },
                      title: 'Gender',
                      listItem: const ['Male', 'Female'],
                    ),
                    CustomTextFieldApp(
                      controller: emailController,
                      title: 'Email',
                      hintText: 'email@gmail.com',
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
                            hintText: 'dd/mm/yyyy',
                            controller: dateController,
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
                                          shape: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                      cardColor: Colors.white,

                                      colorScheme: Theme.of(context)
                                          .colorScheme
                                          .copyWith(
                                            primary:
                                                Colors.white, // <-- SEE HERE
                                            onPrimary:
                                                Colors.black, // <-- SEE HERE
                                            onSurface: Colors.white,
                                          ),

                                      // Input
                                      inputDecorationTheme:
                                          const InputDecorationTheme(
                                              // labelStyle: GoogleFonts.greatVibes(), // Input label
                                              ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );

                              if (pickedDate != null) {
                                dateController.text =
                                    "${pickedDate.day.toString().padLeft(2, "0")}/${pickedDate.month.toString().padLeft(2, "0")}/${pickedDate.year}";
                              }
                            },
                            readOnly: true,
                          ),
                        ),
                        Expanded(
                          child: CustomTextFieldApp(
                            controller: noOfFamilyController,
                            title: 'No. of family Members',
                            keyboardType: TextInputType.number,
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
                                  decoration: const BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle),
                                ),
                                inactiveColor: Colors.grey,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                                width: size.height * 0.06,
                                height: size.height * 0.03,
                                enabled: true,
                                disabledOpacity: 0.5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    CustomTextFieldApp(
                      title: 'Any Illness In Family Members',
                      controller: illnessController,
                      hintText: 'Enter Illness In Family Members',
                    ),
                    CustomTextFieldApp(
                      title: 'Monthly Income',
                      controller: monthlyIncomeController,
                      hintText: 'Enter Income',
                      keyboardType: TextInputType.number,
                    ),
                    CustomDropdown(

                      hintText: stateHint,
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
                      listItem: controller.satesModel?.data
                          ?.map((e) => e.name)
                          .toList(),
                    ),
                    CustomDropdown(

                      hintText:cityHint,
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
                      listItem: controller.cityModel?.data
                          ?.map((e) => e.name)
                          .toList(),
                    ),
                    CustomTextFieldApp(
                      title: 'Pin Code',
                      controller: pinCodeController,
                      hintText: 'Enter Pin Code',
                      keyboardType: TextInputType.number,
                    ),
                    CustomTextFieldApp(
                      controller: addressController,
                      height: size.height * 0.06,
                      title: 'Address',
                      hintText: 'Enter Address',
                    ),
                    CustomTextFieldApp(
                      controller: enagicIdController,
                      title: 'Enagic ID',
                      hintText: 'Enter Enagic ID',
                    ),
                    CustomTextFieldApp(
                      controller: enagicPassController,
                      title: 'Enagic Password',
                      hintText: 'Enter Enagic Password',
                    ),
                    Consumer<MembersController>(
                      builder: (context, controller, child) {
                        return CustomDropdown(

                          hintText: sponsorHint,
                          onChanged: (v) {
                            sponsorId = controller.fetchSponsorModel?.data
                                    ?.firstWhere(
                                      (element) {
                                        return element.name == v;
                                      },
                                    )
                                    .id
                                    .toString() ??
                                '';
                          },
                          title: 'Sponsor',
                          listItem: controller.fetchSponsorModel?.data
                              ?.map((e) => e.name)
                              .toList(),
                        );
                      },
                    ),
                    const CustomTextFieldApp(
                      title: 'Confirm Password',
                      hintText: 'Enter Confirm Password',
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
            margin: const EdgeInsets.only(left: 16, right: 24),
            onTap: () async {
              await context.read<MembersController>().editMemberProfile(
                  context: context,
                  firstName: firstNameController.text,
                  lastName: lastNameController.text,
                  mobile: mobileController.text,
                  email: emailController.text,
                  gender: gender,
                  leadRefType: '',
                  occupation: occupation,
                  dob: dateController.text,
                  noOfFamilyMembers: noOfFamilyController.text,
                  illnessInFamily: illnessController.text,
                  stateId: stateId,
                  cityId: cityId,
                  address: addressController.text,
                  pincode: pinCodeController.text,
                  disability: disability == false ? 'No' : 'Yes',
                  monthlyIncome: monthlyIncomeController.text,
                  sponsorId: sponsorId,
                  salesFacilitatorId: '',
                  // enagicId: enagicIdController.text,
                  // password: enagicPassController.text,
                file: XFile(image?.path??'')
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'SUBMIT',
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
