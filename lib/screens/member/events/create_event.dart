import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';

import '../../../core/constant/gradients.dart';
import '../../../utils/widgets/custom_back_button.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../../../utils/widgets/widgets.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  TextEditingController eventNameCtrl = TextEditingController();
  TextEditingController startDateCtrl = TextEditingController();
  TextEditingController startTimeCtrl = TextEditingController();

  TextEditingController endDateCtrl = TextEditingController();
  TextEditingController endTimeCtrl = TextEditingController();

  TextEditingController linkCtrl = TextEditingController();
  TextEditingController cityCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();

  File? image;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading:  CustomBackButton(),
        title: const Text('Create Event'),
      ),
      body: ListView(
        padding: EdgeInsets.only(bottom: size.height * 0.13),
        children: [
          AppTextField(
            controller: eventNameCtrl,
            title: 'Event name',
            hintText: 'Enter Event name',
          ),
          const AppTextField(
            title: 'Event Type*',
            hintText: 'Enter Event Type',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: CustomDropdown(
              title: 'Event Type*',
              hintText: 'Select Event Type',
              listItem: ['Online', 'Offline'],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: CustomDropdown(
              title: 'Type Of Category*',
              hintText: 'Select Event Type',
              listItem: ['Webinar', 'Conferences', 'Workshops', 'Networking Event'],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  title: 'Start Date',
                  hintText: 'dd/mm/yyyy',
                  controller: startDateCtrl,
                  padding: const EdgeInsets.only(top: 10, bottom: 10, left: kPadding, right: kPadding),
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
                      startDateCtrl.text =
                          "${pickedDate.day.toString().padLeft(2, "0")}/${pickedDate.month.toString().padLeft(2, "0")}/${pickedDate.year}";
                    }
                  },
                  readOnly: true,
                ),
              ),
              Expanded(
                child: AppTextField(
                  title: 'Start Time',
                  hintText: 'hh:mm',
                  controller: startTimeCtrl,
                  padding: const EdgeInsets.only(top: 10, bottom: 10, right: kPadding),
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
                      startTimeCtrl.text = '${time.hour}:${time.minute}';
                    }
                  },
                  readOnly: true,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  title: 'End Date',
                  hintText: 'dd/mm/yyyy',
                  controller: endDateCtrl,
                  padding: const EdgeInsets.only(top: 10, bottom: 10, left: kPadding, right: kPadding),
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
                      endDateCtrl.text =
                          "${pickedDate.day.toString().padLeft(2, "0")}/${pickedDate.month.toString().padLeft(2, "0")}/${pickedDate.year}";
                    }
                  },
                  readOnly: true,
                ),
              ),
              Expanded(
                child: AppTextField(
                  title: 'End Time',
                  hintText: 'hh:mm',
                  controller: endTimeCtrl,
                  padding: const EdgeInsets.only(top: 10, bottom: 10, right: kPadding),
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
                      endTimeCtrl.text = '${time.hour}:${time.minute}';
                    }
                  },
                  readOnly: true,
                ),
              ),
            ],
          ),
          AppTextField(
            controller: linkCtrl,
            title: 'Link Paste',
            hintText: 'Paste Link',
          ),
          AppTextField(
            controller: cityCtrl,
            title: 'City',
            hintText: 'Enter City',
          ),
          AppTextField(
            controller: addressCtrl,
            title: 'Address',
            hintText: 'Enter Address',
            minLines: 2,
            maxLines: 6,
          ),
          AppTextField(
            controller: descriptionCtrl,
            title: 'Description',
            hintText: 'Enter Description',
            minLines: 4,
            maxLines: 6,
          ),
          Padding(
            padding: const EdgeInsets.all(kPadding),
            child: GestureDetector(
              onTap: () {
                addImages();
              },
              child: DottedBorder(
                dashPattern: const [4, 4],
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                color: Colors.grey,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: kPadding, vertical: 24),
                  color: Colors.transparent,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          ImageView(
                            height: 50,
                            width: 50,
                            assetImage: '',
                            margin: EdgeInsets.only(bottom: 8),
                          ),
                          Text(
                            'Drop your image here, or browse',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Supports: PNG, JPG',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: kPadding, right: kPadding, top: 8),
            child: Row(
              children: [
                Text(
                  'Select List',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Container(
            height: 55,
            margin: const EdgeInsets.only(top: kPadding, bottom: kPadding, left: kPadding),
            child: ListView.builder(
              itemCount: 10,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  width: 120,
                  margin: const EdgeInsets.only(right: kPadding),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    gradient: inActiveGradient,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Row(
                    children: [
                      ImageView(
                        height: 40,
                        width: 40,
                        borderRadiusValue: 40,
                        isAvatar: true,
                        assetImage: AppAssets.appIcon,
                        margin: EdgeInsets.only(right: 8),
                      ),
                      Text('Ayan'),
                    ],
                  ),
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: kPadding, right: kPadding, top: 8),
            child: Row(
              children: [
                Text(
                  'Select Members to add',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const Row(
            children: [
              Flexible(
                child: CustomTextField(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: ImageView(
                    height: 20,
                    width: 20,
                    borderRadiusValue: 0,
                    color: Colors.white,
                    margin: EdgeInsets.only(left: kPadding, right: kPadding),
                    fit: BoxFit.contain,
                    assetImage: AppAssets.searchIcon,
                  ),
                  margin: EdgeInsets.only(left: kPadding, right: kPadding, top: kPadding, bottom: kPadding),
                ),
              ),
              // GradientButton(
              //   height: 60,
              //   width: 60,
              //   margin: const EdgeInsets.only(left: 8, right: kPadding),
              //   backgroundGradient: blackGradient,
              //   child: const ImageView(
              //     height: 28,
              //     width: 28,
              //     assetImage: AppAssets.filterIcons,
              //     margin: EdgeInsets.zero,
              //   ),
              // )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: kPadding),
            child: Wrap(
              children: List.generate(
                10,
                (index) {
                  return Container(
                    margin: const EdgeInsets.only(right: kPadding, top: kPadding),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: inActiveGradient,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ImageView(
                          height: 40,
                          width: 40,
                          borderRadiusValue: 40,
                          isAvatar: true,
                          assetImage: AppAssets.appIcon,
                          margin: EdgeInsets.only(right: 8),
                        ),
                        Text('Ayaan'),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Column(
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
            onTap: () {
              // context.pushNamed(Routs.questions);
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
        ],
      ),
    );
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
                    'Change Image',
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

class AppTextField extends StatelessWidget {
  final String? title;
  final void Function()? onTap;
  final String? hintText;
  final bool? readOnly;
  final Widget? prefixIcon;
  final double? height;
  final int? minLines;
  final int? maxLines;

  final TextEditingController? controller;
  final EdgeInsets? padding;

  const AppTextField({
    this.title,
    this.hintText,
    this.onTap,
    this.controller,
    this.prefixIcon,
    this.height,
    this.readOnly,
    super.key,
    this.minLines,
    this.maxLines,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: kPadding, vertical: 10),
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
              padding: const EdgeInsets.only(left: kPadding, top: 12),
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

              controller: controller,
              prefixIcon: prefixIcon,
              minLines: minLines,
              maxLines: maxLines,
              hintStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              contentPadding: const EdgeInsets.only(left: 1),
              autofocus: true,
              isDense: true,
              margin: const EdgeInsets.only(left: kPadding, right: kPadding, top: 8, bottom: 12),
              hintText: hintText,
              // margin: const EdgeInsets.only(bottom: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDropdown extends StatelessWidget {
  final String? title;
  final String? hintText;
  final List<String>? listItem;
  final TextEditingController? controller;

  const CustomDropdown({
    this.title,
    this.hintText,
    this.listItem,
    this.controller,
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
              child: DropdownSearch<String>(
                dropdownButtonProps: const DropdownButtonProps(
                    padding: EdgeInsets.only(bottom: 10),
                    icon: Icon(
                      CupertinoIcons.chevron_down,
                      size: 18,
                    )),
                popupProps: PopupProps.menu(
                  menuProps: const MenuProps(
                    backgroundColor: Color(0xFF1B1B1B),
                  ),
                  fit: FlexFit.loose,
                  showSelectedItems: true,
                  disabledItemFn: (String s) => s.startsWith('p'),
                ),
                items: listItem ?? [],
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 7, top: 7),
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
