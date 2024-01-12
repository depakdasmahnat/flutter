import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:mrwebbeast/core/extensions/normal/build_context_extension.dart';
import 'package:mrwebbeast/core/services/database/local_database.dart';


import '../../../core/constant/colors.dart';

import '../../../utils/validators.dart';
import '../../../utils/widgets/custom_button.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/image_view.dart';
import '../../../utils/widgets/widgets.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  LocalDatabase localDatabase = LocalDatabase();
  late TextEditingController nameCtrl = TextEditingController(text: localDatabase.name ?? '');
  late TextEditingController emailCtrl = TextEditingController(text: localDatabase.email ?? '');
  late TextEditingController mobileCtrl = TextEditingController(text: localDatabase.mobile ?? '');

  late String? profilePhoto = localDatabase.profilePhoto;

  double imageRadius = 110;
  File? image;
  GlobalKey<FormState> editProfileKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        // AuthControllers controllers = Provider.of(context, listen: false);
        // controllers.fetchCountries(context: context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Form(
        key: editProfileKey,
        child: ListView(
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
                      ImageView(
                        height: imageRadius,
                        width: imageRadius,
                        borderRadiusValue: imageRadius,
                        isAvatar: true,
                        file: image,
                        networkImage: profilePhoto,
                        fit: BoxFit.cover,
                        border: Border.all(color: Colors.grey.shade200),
                        margin: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 12),
                      ),
                      Positioned(
                        right: -6,
                        bottom: 10,
                        child: Icon(CupertinoIcons.add_circled_solid, size: 24, color: primaryColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            CustomTextField(
              controller: nameCtrl,
              autofocus: true,
              prefixIcon: Icon(Icons.person, color: context.colorScheme.primary),
              validator: (val) {
                return Validator.nameValidator(val);
              },
              labelText: 'Name',
              hintText: 'Name',
              margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
            ),
            CustomTextField(
              controller: emailCtrl,
              autofocus: true,
              prefixIcon: Icon(Icons.email_outlined, color: context.colorScheme.primary),
              validator: (val) {
                return Validator.emailValidator(val);
              },
              labelText: 'Email',
              hintText: 'Email',
              margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
            ),
            CustomTextField(
              controller: mobileCtrl,
              autofocus: true,
              enabled: false,
              labelText: 'Mobile Number',
              keyboardType: TextInputType.number,
              prefixIcon: Icon(Icons.call, color: context.colorScheme.primary),
              suffixIcon: Icon(Icons.verified_outlined, color: context.colorScheme.primary, size: 20),
              limit: 10,
              validator: (val) {
                return Validator.numberValidator(val);
              },
              hintText: 'Enter Mobile Number',
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
              text: 'Update',
              backgroundColor: context.colorScheme.primary,
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
    );
  }

  updateProfile() {
    if (editProfileKey.currentState?.validate() == true) {
      FocusScope.of(context).unfocus();

      // context.read<AuthControllers>().editProfile(
      //   context: context,
      //   name: nameCtrl.text,
      //   email: emailCtrl.text,
      //   profilePhoto: image,
      // );
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
      String error = 'Enter all required Data';

      showSnackBar(context: context, text: error, color: Colors.red);
    }
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
}
