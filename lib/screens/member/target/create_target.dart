import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import 'package:provider/provider.dart';

import '../../../controllers/member/member_controller/member_controller.dart';
import '../../../core/constant/gradients.dart';
import '../../../core/route/route_paths.dart';
import '../../../utils/widgets/appbar.dart';
import '../../../utils/widgets/custom_back_button.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../../../utils/widgets/widgets.dart';

class CreateTarget extends StatefulWidget {
  const CreateTarget({super.key});

  @override
  State<CreateTarget> createState() => _CreateTargetState();
}

class _CreateTargetState extends State<CreateTarget> {
  TextEditingController currentMonth = TextEditingController();
  TextEditingController endDateCtrl = TextEditingController();
  TextEditingController salesTargetController = TextEditingController();
  File? image;
  var currentDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    var formattedDate = DateFormat('MMM-yyyy').format(currentDate);
    currentMonth.text =formattedDate;
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: const CustomBackButton(),
        title: const Text('Set Your Monthly Target'),
      ),
      body: ListView(
        padding: EdgeInsets.only(bottom: size.height * 0.13),
        children: [
           AppTextField(
            controller: salesTargetController,
            title: 'Sales Target',
            keyboardType: TextInputType.number,
            hintText: 'Enter Sales target',

          ),

          AppTextField(
            title: 'Current Month',
            // hintText: 'dd/mm/yyyy',
            controller: currentMonth,
            readOnly: true,
          ),
          // AppTextField(
          //   title: 'End Date',
          //   hintText: 'dd/mm/yyyy',
          //   controller: endDateCtrl,
          //   onTap: () async {
          //     DateTime? pickedDate = await showDatePicker(
          //       context: context,
          //       initialDate: DateTime.now(),
          //       firstDate: DateTime.now(),
          //       lastDate: DateTime(2101),
          //       builder: (context, child) {
          //         return Theme(
          //           data: Theme.of(context).copyWith(
          //             popupMenuTheme: PopupMenuThemeData(
          //                 shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
          //             cardColor: Colors.white,
          //
          //             colorScheme: Theme.of(context).colorScheme.copyWith(
          //                   primary: Colors.white, // <-- SEE HERE
          //                   onPrimary: Colors.black, // <-- SEE HERE
          //                   onSurface: Colors.white,
          //                 ),
          //
          //             // Input
          //             inputDecorationTheme: const InputDecorationTheme(
          //                 // labelStyle: GoogleFonts.greatVibes(), // Input label
          //                 ),
          //           ),
          //           child: child!,
          //         );
          //       },
          //     );
          //
          //     if (pickedDate != null) {
          //       endDateCtrl.text =
          //           "${pickedDate.day.toString().padLeft(2, "0")}/${pickedDate.month.toString().padLeft(2, "0")}/${pickedDate.year}";
          //     }
          //   },
          //   readOnly: true,
          // ),

          // Padding(
          //   padding: const EdgeInsets.all(kPadding),
          //   child: GestureDetector(
          //     onTap: () {
          //       addImages();
          //     },
          //     child: DottedBorder(
          //       dashPattern: const [4, 4],
          //       borderType: BorderType.RRect,
          //       radius: const Radius.circular(12),
          //       color: Colors.grey,
          //       child: Container(
          //         padding: const EdgeInsets.symmetric(horizontal: kPadding, vertical: 24),
          //         color: Colors.transparent,
          //         child: const Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             Column(
          //               children: [
          //                 ImageView(
          //                   height: 50,
          //                   width: 50,
          //                   assetImage: '',
          //                   margin: EdgeInsets.only(bottom: 8),
          //                 ),
          //                 Text(
          //                   'Drop your image here, or browse',
          //                   style: TextStyle(
          //                     fontSize: 16,
          //                     fontWeight: FontWeight.w500,
          //                   ),
          //                 ),
          //                 Text(
          //                   'Supports: PNG, JPG',
          //                   style: TextStyle(
          //                     fontSize: 12,
          //                     fontWeight: FontWeight.w500,
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
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
            onTap: () async{
              await context.read<MembersController>().addTarget(context: context,
                  salesTarget: salesTargetController.text);
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
  final TextInputType? keyboardType;

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
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPadding, vertical: 10),
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
              maxLines: maxLines,keyboardType:keyboardType ,

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

class CustomeDropdown extends StatelessWidget {
  String? title;
  String? hintText;
  List<String>? listItem;
  TextEditingController? controller;

  CustomeDropdown({
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
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                      left: 7,
                      top: 7,
                    ),
                    border: InputBorder.none,
                    hintText: 'Select Gender',
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
