import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mrwebbeast/controllers/member/member_auth_controller.dart';
import 'package:mrwebbeast/controllers/member/member_controller/member_controller.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import 'package:provider/provider.dart';

import '../../../core/constant/gradients.dart';
import '../../../models/member/create_goal/fetchGoalForEditModel.dart';
import '../../../utils/widgets/custom_back_button.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../../../utils/widgets/widgets.dart';
import '../../guest/guestProfile/guest_edit_profile.dart';

class CreateGoal extends StatefulWidget {
  final String? type;
  final String? goalId;
  const CreateGoal({super.key, this.type, this.goalId});
  @override
  State<CreateGoal> createState() => _CreateGoalState();
}
class _CreateGoalState extends State<CreateGoal> {
  FetchGoalForEditModel? fetchGoalForEditModel;
  String goalType = '';
  String networkImageForGoal = '';
  String goalTypeHint = 'Select Goal Type';
  TextEditingController startDateCtrl = TextEditingController();
  TextEditingController endDateCtrl = TextEditingController();
  TextEditingController goalNameCtrl = TextEditingController();
  TextEditingController goalTypeCtrl = TextEditingController();
  TextEditingController disCtrl = TextEditingController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.read<MembersController>().fetchGoalCategory();
      if (widget.type == 'Edit') {
        fetchGoalForEditModel = await context
            .read<MembersController>()
            .fetchGoalForEdit(goalId: widget.goalId ?? '');
        goalNameCtrl.text = fetchGoalForEditModel?.data?.name ?? '';
        goalTypeHint = fetchGoalForEditModel?.data?.type ?? '';
        startDateCtrl.text = fetchGoalForEditModel?.data?.startDate ?? '';
        endDateCtrl.text = fetchGoalForEditModel?.data?.endDate ?? '';
        disCtrl.text = fetchGoalForEditModel?.data?.description ?? '';
        networkImageForGoal = fetchGoalForEditModel?.data?.image ?? '';
        goalType = fetchGoalForEditModel?.data?.typeId ?? '';
        image = File(networkImageForGoal ?? '');
        setState(() {});
      }
    });
    super.initState();
  }
  File? image;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: const CustomBackButton(),
        title: Text(widget.type == 'Edit' ? 'Edit Goal' : 'Create Goal'),
      ),
      body: ListView(
        padding: EdgeInsets.only(bottom: size.height * 0.13),
        children: [
          AppTextField(
            controller: goalNameCtrl,
            title: 'Goal name',
            hintText: 'Enter Goal name',
          ),
          Consumer<MembersController>(
            builder: (context, controller, child) {
              return Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: CustomDropdown(
                  context: context,
                  controller: goalTypeCtrl,
                  onChanged: (v) {
                    var id = controller.fetchGoalCategoryModel?.data
                        ?.firstWhere(
                          (element) {
                            return element.name == v;
                          },
                        ).id.toString();
                    goalType = id ?? '';
                  },
                  title: 'Goal Type',
                  hintText: goalTypeHint,
                  listItem: controller.fetchGoalCategoryModel?.data
                      ?.map((e) => e.name)
                      .toList(),
                ),
              );
            },
          ),
          AppTextField(
            title: 'Start Date',
            hintText: 'dd-mm-yyyy',
            controller: startDateCtrl,
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
                              borderRadius: BorderRadius.circular(10))),
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
                    "${pickedDate.day.toString().padLeft(2, "0")}-${pickedDate.month.toString().padLeft(2, "0")}-${pickedDate.year}";
              }
            },
            readOnly: true,
          ),
          AppTextField(
            title: 'End Date',
            hintText: 'dd-mm-yyyy',
            controller: endDateCtrl,
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
                              borderRadius: BorderRadius.circular(10))),
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
                    "${pickedDate.day.toString().padLeft(2, "0")}-${pickedDate.month.toString().padLeft(2, "0")}-${pickedDate.year}";
              }
            },
            readOnly: true,
          ),
          AppTextField(
            controller: disCtrl,
            title: 'Description',
            hintText: 'Enter Description',
            minLines: 6,
            maxLines: 8,
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: kPadding, vertical: 24),
                    color: Colors.transparent,
                    child: networkImageForGoal == ''
                        ? ImageView(
                            file: File(image?.path ?? ''),
                            borderRadiusValue: 10,
                          )
                        : ImageView(
                            networkImage: networkImageForGoal,
                            borderRadiusValue: 10,
                          )

                    ),
              ),
            ),
          )
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
            margin: const EdgeInsets.only(
                left: kPadding, right: kPadding, bottom: kPadding),
            onTap: () async {
              context.read<MemberAuthControllers>().confirmationPopup(
                title: 'Are you sure, you want to create this goal!',
                context: context,
                onPressed: () async{
                  if (widget.type == 'Edit') {
                    await context.read<MembersController>().updateGoal(
                        context: context,
                        name: goalNameCtrl.text,
                        goalType: goalType,
                        startDate: startDateCtrl.text,
                        endDate: endDateCtrl.text,
                        description: disCtrl.text,
                        file: XFile(image?.path ?? ''),
                        goalId: widget.goalId ?? '');
                  } else {
                    await context.read<MembersController>().addGoal(
                        context: context,
                        name: goalNameCtrl.text,
                        goalType: goalType,
                        startDate: startDateCtrl.text,
                        endDate: endDateCtrl.text,
                        description: disCtrl.text,
                        file: XFile(image?.path ?? ''));
                  }
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
        ],
      ),
    );
  }
  Future<void> updateProfileImage({required ImageSource source}) async {
    final pickedImg = await ImagePicker().pickImage(source: source);
    setState(() {
      if (pickedImg != null) {
        image = File(pickedImg.path);
        networkImageForGoal = '';

        setState(() {});
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
  final EdgeInsetsGeometry? padding;
  final void Function()? onTap;
  final String? hintText;
  final bool? readOnly;
  final Widget? prefixIcon;
  final double? height;
  final int? minLines;
  final int? maxLines;
  final Widget? suffixIcon;
  final bool? obscureText;
  final String? obscuringCharacter;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final BoxConstraints? suffixIconConstraints;
  final void Function(String)? onFieldSubmitted;

  const AppTextField({
    this.title,
    this.padding,
    this.hintText,
    this.onTap,
    this.controller,
    this.prefixIcon,
    this.height,
    this.readOnly,
    super.key,
    this.minLines,
    this.maxLines,
    this.obscureText,
    this.obscuringCharacter,
    this.validator,
    this.onChanged,
    this.suffixIcon,
    this.suffixIconConstraints,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding:padding?? const EdgeInsets.symmetric(horizontal: kPadding, vertical: 10),
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
              validator: validator,
              onChanged: onChanged,
              suffixIcon: suffixIcon,
              suffixIconConstraints: suffixIconConstraints,
              onFieldSubmitted: onFieldSubmitted,

              controller: controller,
              prefixIcon: prefixIcon,
              minLines: minLines,
              maxLines: maxLines,
              obscureText: obscureText,
              obscuringCharacter: obscuringCharacter,
              hintStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              contentPadding: const EdgeInsets.only(left: 1),
              autofocus: true,
              isDense: true,
              margin: const EdgeInsets.only(
                  left: kPadding, right: kPadding, top: 8, bottom: 12),
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
