import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../controllers/guest_controller/guest_controller.dart';
import '../../../controllers/member/leads/leads_controllers.dart';
import '../../../controllers/member/member_auth_controller.dart';
import '../../../controllers/member/member_controller/member_controller.dart';
import '../../../core/config/app_assets.dart';
import '../../../core/constant/gradients.dart';

import '../../../core/services/database/local_database.dart';
import '../../../models/default/default_model.dart';
import '../../../models/member/auth/member_data.dart';
import '../../../models/member/leads/fetchGuestData.dart';
import '../../../utils/widgets/appbar.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../../../utils/widgets/image_view.dart';
import '../../../utils/widgets/widgets.dart';
import '../../guest/guestProfile/guest_edit_profile.dart';
import '../../guest/guestProfile/guest_faq.dart';
import '../goal/create_goal.dart';
import 'add_member_list.dart';

class AddMemberForm extends StatefulWidget {
  final String? guestId;

  const AddMemberForm({super.key, this.guestId});

  @override
  State<AddMemberForm> createState() => _AddMemberFormState();
}

class _AddMemberFormState extends State<AddMemberForm> {
  bool? validate = true;
  bool? disability = false;
  String gender = '';
  String genderHint = 'Select Gender';
  String occupation = '';
  String stateId = '';
  String cityId = '';
  String sponsorId = '';
  String sponsorHint = 'Select Sponsor';
  String facilitatorId = '';
  String product = '';
  String refType = '';
  String refTypeHint = '';
  String countryCode = '91';
  String downlineRank = '';
  File? image;
  final _formKey = GlobalKey<FormState>();
  final switch1 = ValueNotifier<bool>(false);
  TextEditingController dateController = TextEditingController();
  TextEditingController enagicPasswordController = TextEditingController();
  TextEditingController enagicConfirmPasswordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController noOfFamilyController = TextEditingController();
  TextEditingController IllnessController = TextEditingController();
  TextEditingController monthlyController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController facilitatorCOntroller = TextEditingController();
  TextEditingController enagicIdController = TextEditingController();
  TextEditingController countryNameController = TextEditingController();

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (widget.guestId != '') {
        FetchGuestData? model = await context
            .read<ListsControllers>()
            .fetchGuestData(context: context, guestId: widget.guestId ?? '');
        firstNameController.text = model?.data?.firstName ?? '';
        lastNameController.text = model?.data?.lastName ?? '';
        mobileController.text = model?.data?.mobile ?? '';
        emailController.text = model?.data?.email ?? '';
        gender = model?.data?.gender ?? '';
        genderHint = model?.data?.gender ?? '';
        refTypeHint = model?.data?.leadRefType ?? '';
        refType = model?.data?.leadRefType ?? '';
        sponsorHint = model?.data?.sponsorName ?? '';
        sponsorId = model?.data?.sponsorId.toString() ?? '';
        countryNameController.text = model?.data?.countryName ?? '';
        dateController.text = model?.data?.dob ?? '';
        if (model?.data?.disability == 'Yes') {
          disability = true;
        } else {
          disability = false;
        }
        setState(() {});
      }
      await context.read<GuestControllers>().fetchState(
            context: context,
          );
      await context.read<MembersController>().fetchFacilitator(
            context: context,
          );
      await context.read<MembersController>().fetchSponsor(
            context: context,
          );
      await context.read<MembersController>().fetchOccupation(
            context: context,
          );
      await context.read<MembersController>().fetchProduct1(
            context: context,
          );
      await context.read<MembersController>().fetchDownLineRank(
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

  @override
  Widget build(BuildContext context) {
    MemberData? member = context.read<LocalDatabase>().member;
    sponsorHint = member?.firstName ?? '';
    sponsorId = member?.id.toString() ?? '';
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(size.height * 0.07),
          child: CustomAppBar(
            title: 'Add A Team Partner',
            showLeadICon: false,
          )),
      body: Form(
          key: _formKey,
          autovalidateMode: validate == true ? AutovalidateMode.always : AutovalidateMode.disabled,
          child: ListView.builder(
            itemCount: 1,
            padding: EdgeInsets.only(
              bottom: size.height * 0.12,
            ),
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Container(
                  //   height: size.height*0.14,
                  //   decoration: const BoxDecoration(
                  //       shape: BoxShape.circle,
                  //       image: DecorationImage(
                  //           image: AssetImage(AppAssets.memberprofile),
                  //           fit: BoxFit.contain
                  //       )
                  //   ),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ImageView(
                        onTap: () async {
                          await addImages();
                        },
                        height: 100,
                        file: File(image?.path ?? ''),
                        // width: 100,
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
                  CustomTextFieldApp(
                    controller: firstNameController,
                    title: 'First Name',
                    mandatory: '*',
                    hintText: 'Enter First Name',
                  ),
                  CustomTextFieldApp(
                    controller: lastNameController,
                    title: 'Last Name',
                    hintText: 'Enter Last Name',
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
                  CustomTextFieldApp(
                    mandatory: '*',
                    controller: emailController,
                    title: 'Email',
                    hintText: 'email@gmail.com',
                  ),

                  CustomDropdown(
                    onChanged: (v) {
                      gender = v;
                    },
                    title: 'Gender',
                    hintText: genderHint,
                    listItem: const ['Male', 'Female'],
                  ),
                  Consumer<MembersController>(
                    builder: (context, controller, child) {
                      return CustomDropdown(
                        mandatory: '*',
                        showSearchBox: true,
                        hintText: 'Select Product',
                        onChanged: (v) {
                          product = controller.fetchProduct?.data
                                  ?.firstWhere(
                                    (element) {
                                      return element.name == v;
                                    },
                                  )
                                  .id
                                  .toString() ??
                              '';
                        },
                        title: 'Product',
                        listItem: controller.fetchProduct?.data?.map((e) => e.name).toList(),
                      );
                    },
                  ),
                  Consumer<MembersController>(
                    builder: (context, controller, child) {
                      return CustomDropdown(
                        mandatory: '*',
                        showSearchBox: true,
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
                        listItem: controller.fetchSponsorModel?.data?.map((e) => e.name).toList(),
                      );
                    },
                  ),
                  Consumer<MembersController>(
                    builder: (context, controller, child) {
                      return CustomDropdown(
                        mandatory: '*',
                        showSearchBox: true,
                        hintText: 'sales Done By',
                        onChanged: (v) {
                          facilitatorId = controller.fetchFacilitatorModel?.data
                                  ?.firstWhere(
                                    (element) {
                                      return element.name == v;
                                    },
                                  )
                                  .id
                                  .toString() ??
                              '';
                        },
                        title: 'sales Done By',
                        listItem: controller.fetchFacilitatorModel?.data?.map((e) => e.name).toList(),
                      );
                    },
                  ),
                  Consumer<MembersController>(
                    builder: (context, controller, child) {
                      return CustomDropdown(
                        mandatory: '*',
                        showSearchBox: true,
                        hintText: 'Register this applicant as (rank)',
                        onChanged: (v) {
                          downlineRank = v;
                        },
                        title: 'Sponsor’s Down line Rank',
                        listItem: controller.fetchDownlineRan?.data,
                      );
                    },
                  ),
                  CustomTextFieldApp(
                    controller: enagicIdController,
                    maxLength: 11,
                    keyboardType: TextInputType.number,
                    mandatory: '*',
                    title: 'Enagic Id',
                    hintText: 'Enter EnagicId',
                    onChanged: (v) {
                      if (v.isEmpty) {
                        enagicPasswordController.clear();
                      } else {
                        if (v.length == 11) {
                          final random = Random().nextInt(999999);
                          enagicPasswordController.text = random.toString();
                          setState(() {});
                        }
                      }
                    },
                  ),
                  AppTextField(
                    padding: const EdgeInsets.all(9),
                    controller: enagicPasswordController,
                    suffixIconConstraints: const BoxConstraints(minHeight: 10, minWidth: 10),
                    suffixIcon: GestureDetector(
                        onTap: () {
                          if (validate == true) {
                            validate = false;
                          } else {
                            validate = true;
                          }
                          setState(() {});
                        },
                        child: validate == false
                            ? const Icon(
                                Ionicons.eye_outline,
                                color: Colors.white,
                              )
                            : const Icon(
                                Ionicons.eye_off_sharp,
                                color: Colors.white,
                              )),
                    validator: (value) {
                      if (value!.isEmpty || value == null) {
                        return 'Please Enter Enagic Password';
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Enagic Password',
                    title: 'Enter Enagic Password',
                    obscureText: validate,
                    obscuringCharacter: '*',
                  ),
                  // CustomTextFieldApp(
                  //   controller: enagicPasswordController,
                  //   mandatory: '*',
                  //   title: 'Enagic Password',
                  //   hintText: 'Enter Enagic Password',
                  // ),
                  // CustomTextFieldApp(
                  //   mandatory: '*',
                  //   controller: enagicConfirmPasswordController,
                  //   title: 'Confirm Password',
                  //   hintText: 'Enter Confirm Password',
                  //   validator: (v) {
                  //     if(v==enagicPasswordController.text){
                  //       return null;
                  //     }else if(v!.isEmpty){
                  //       return  'Please Enter Confirm Password';
                  //     }
                  //     else{
                  //       return "Password doesn't match";
                  //     }
                  //   },
                  //   onChanged: (v) {
                  //     if(v==enagicPasswordController.text){
                  //       validate=true;
                  //       setState(() {});
                  //     }
                  //   },
                  // ),

                  if (countryCode == '91')
                    Consumer<GuestControllers>(
                      builder: (context, controller, child) {
                        return CustomDropdown(
                          showSearchBox: true,

                          mandatory: '*',

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
                          showSearchBox: true,
                          hintText: 'Select City',
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
                  // CustomTextFieldApp(
                  //   controller: pinCodeController,
                  //   title: 'Pin Code',
                  //   mandatory: '*',
                  //   hintText: 'Enter Pin Code',
                  //   keyboardType: TextInputType.number,
                  //   maxLength: 6,
                  // ),
                  CustomTextFieldApp(
                    // mandatory: '*',
                    height: size.height * 0.06,
                    title: 'Address',
                    hintText: 'Enter Address',
                    controller: addressController,
                  ),
                  CustomDropdown(
                    hintText: 'Select Ref Type ',
                    onChanged: (v) {
                      refType = v ?? '';
                    },
                    // selectedItem: refType,
                    // selectedItem: refType,
                    title: 'Ref Type',
                    listItem: const ['Self', 'Referred'],
                  ),
                  Consumer<MembersController>(
                    builder: (context, controller, child) {
                      return CustomDropdown(
                        hintText: 'Select Occupation',
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
                              dateController.text =
                                  "${pickedDate.day.toString().padLeft(2, "0")}-${pickedDate.month.toString().padLeft(2, "0")}-${pickedDate.year}";
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
                          )),
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
                              enabled: true,
                              disabledOpacity: 0.5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  CustomTextFieldApp(
                    controller: IllnessController,
                    title: 'Any Illness In Family Members',
                    hintText: 'Enter Members',
                  ),

                  Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: CustomTextFieldApp(
                      controller: monthlyController,
                      title: 'Monthly Income',
                      hintText: 'Enter Income',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              );
            },
          )),
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
              if (_formKey.currentState!.validate()) {
                context.read<MemberAuthControllers>().confirmationPopup(
                      context: context,
                      title: 'Are you sure, you want to close this member',
                      onPressed: () async {
                        DefaultModel? model = await context.read<MembersController>().addFacilitatorList(
                            guestId: widget.guestId ?? '',
                            context: context,
                            firstName: firstNameController.text,
                            lastName: lastNameController.text,
                            mobile: mobileController.text,
                            email: emailController.text,
                            enagicId: enagicIdController.text,
                            password: enagicPasswordController.text,
                            gender: gender,
                            leadRefType: refType,
                            occupation: occupation,
                            dob: dateController.text,
                            noOfFamilyMembers: noOfFamilyController.text,
                            illnessInFamily: IllnessController.text,
                            stateId: stateId,
                            cityId: cityId,
                            address: addressController.text,
                            pincode: pinCodeController.text,
                            disability: disability == false ? 'No' : 'Yes',
                            monthlyIncome: monthlyController.text,
                            sponsorId: sponsorId,
                            salesFacilitatorId: facilitatorId,
                            countryCode: countryCode,
                            countryName: countryNameController.text,
                            rank: downlineRank,
                            product: product,
                            file: XFile(image?.path ?? ''));

                        if (model?.status == true) {
                          context.pop();
                        }
                      },
                    );
              }
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
