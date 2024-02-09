import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaas/controllers/auth/auth_controller.dart';
import 'package:gaas/utils/widgets/custom_button.dart';
import 'package:gaas/utils/widgets/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../core/config/app_images.dart';
import '../../../core/constant/colors.dart';
import '../../../core/services/database/local_database.dart';
import '../../../utils/validators.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/image_view.dart';
import '../../core/constant/formatters.dart';
import '../../route/route_paths.dart';
import '../../utils/file_picker_controller.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  LocalDatabase localDatabase = LocalDatabase();
  late TextEditingController nameCtrl = TextEditingController(text: localDatabase.name ?? "");
  late TextEditingController emailCtrl = TextEditingController(text: localDatabase.email ?? "");
  late TextEditingController mobileCtrl = TextEditingController(text: localDatabase.mobile ?? "");
  late TextEditingController addressCtrl = TextEditingController(text: localDatabase.address ?? "");

  late String? profilePhoto = localDatabase.profilePhoto;

  double imageRadius = 110;
  File? image;
  GlobalKey<FormState> editProfileKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        // controllers.fetchCountries(context: context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              backButton(context: context),
            ],
          ),
          leadingWidth: 50,
          title: const Text(
            "Edit Profile",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        body: Form(
          key: editProfileKey,
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
              CustomTextField(
                controller: nameCtrl,
                autofocus: true,
                prefixIcon: const Icon(Icons.person, color: primaryColor),
                validator: (val) {
                  return Validator.nameValidator(val);
                },
                labelText: "Name",
                hintText: "Name",
                margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
              ),
              CustomTextField(
                controller: emailCtrl,
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
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
                autofocus: true,
                enabled: false,
                labelText: "Mobile Number",
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.call, color: primaryColor),
                suffixIcon: const Icon(Icons.verified_outlined, color: primaryColor, size: 20),
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
                hintText: "Enter Mobile Number",
                margin: const EdgeInsets.only(left: 24, right: 24, top: 14),
              ),

              // CustomTextField(
              //   controller: addressCtrl,
              //   autofocus: true,
              //   minLines: 1,
              //   maxLines: 4,
              //   prefixIcon: const Icon(Icons.location_on, color: primaryColor),
              //   labelText: "Address",
              //   hintText: "Address",
              //   validator: (val) {
              //     return Validator.nameValidator(val);
              //   },
              //   margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
              // ),
              CustomButton(
                height: 45,
                text: "Update",
                backgroundColor: primaryColor,
                fontSize: 18,
                onPressed: () {
                  updateProfile();
                },
                mainAxisAlignment: MainAxisAlignment.center,
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 24),
              )
            ],
          ),
        ),
      ),
    );
  }

  updateProfile() {
    if (editProfileKey.currentState?.validate() == true) {
      FocusScope.of(context).unfocus();

      context.read<AuthControllers>().editProfile(
            context: context,
            name: nameCtrl.text,
            email: emailCtrl.text,
            profilePhoto: image,
          );
    }
  }

  editProfile() async {
    if (editProfileKey.currentState?.validate() == true) {
      // context.read<AuthControllers>().editProfile(
      //   context: context,
      //   fullName: nameController.text,
      //   email: emailController.text,
      //   image: image,
      // );
    } else {
      String error = "Enter all required Data";

      showSnackBar(context: context, text: error, color: Colors.red);
    }
  }

  Future<void> updateProfileImage({required ImageSource source}) async {
    File? pickedImg = await FilePickerController().selectCroppedImage(
      source: source,
      context: context,
      cropStyle: CropStyle.circle,
      aspectRatioPresets: profilePictureAspectRatioPresets,
    );
    setState(() {
      if (pickedImg != null) {
        image = File(pickedImg.path);
      }
    });

    if (context.mounted) {
      context.pop();
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
}
