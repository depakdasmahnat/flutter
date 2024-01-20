import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/core/constant/constant.dart';

import '../../../core/constant/gradients.dart';
import '../../../utils/widgets/appbar.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/gradient_button.dart';

class GuestEditProfile extends StatefulWidget {
  const GuestEditProfile({super.key});

  @override
  State<GuestEditProfile> createState() => _GuestEditProfileState();
}

class _GuestEditProfileState extends State<GuestEditProfile> {
  TextEditingController dateControlller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height * 0.06),
        child: CustomAppBar(
          showLeadICon: true,
          title: 'Edit',
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(bottom: size.height * 0.13),
        children: [
          CustomeTextFiled(
            title: 'First Name',
            hintText: 'Enter First Name',
          ),
          CustomeTextFiled(
            title: 'Last Name',
            hintText: 'Enter Last Name',
          ),
          CustomeDropdown(
            title: 'Gender',
            listItem: const ['Male', 'Female'],
          ),
          CustomeTextFiled(
            title: 'Mobile No.',
            hintText: 'Enter Mobile No.',
            prefixIcon: const Padding(
              padding: EdgeInsets.only(top: 3),
              child: Text('+91'),
            ),
          ),
          CustomeTextFiled(
            title: 'Email',
            hintText: 'email@gmail.com',
          ),
          CustomeDropdown(
            title: 'Ref Type',
            listItem: const ['Friend', 'Friend'],
          ),
          CustomeDropdown(
            title: 'Occupation',
            listItem: const ['Doctor', 'Doctor'],
          ),
          CustomeDropdown(
            title: 'Occupation',
            listItem: const ['Doctor', 'Doctor'],
          ),
          Row(
            children: [
              Expanded(
                child: CustomeTextFiled(
                  title: 'Date of Birth',
                  hintText: 'dd/mm/yyyy',
                  controller: dateControlller,
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
                            inputDecorationTheme: InputDecorationTheme(
                                // labelStyle: GoogleFonts.greatVibes(), // Input label
                                ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (pickedDate != null) {
                      dateControlller.text =
                          "${pickedDate.day.toString().padLeft(2, "0")}/${pickedDate.month.toString().padLeft(2, "0")}/${pickedDate.year}";
                    }
                  },
                  readOnly: true,
                ),
              ),
              Expanded(
                child: CustomeTextFiled(
                  title: 'No. of family Members',
                  hintText: 'Enter No. of family Members',
                ),
              ),
            ],
          ),
          CustomeTextFiled(
            title: 'Any Disease',
            hintText: 'Enter Disease',
          ),
          CustomeDropdown(
            title: 'City',
            listItem: const ['Raipur', 'Bilaspur', 'korba'],
          ),
          CustomeDropdown(
            title: 'Pin Code',
            listItem: const ['492001', '492001', '492001'],
          ),
          CustomeTextFiled(
            title: 'Address',
            hintText: 'Enter Address',
            height: size.height * 0.07,
          ),
        ],
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
            margin: const EdgeInsets.only(left: kPadding, right: kPadding, bottom: kPadding),
            onTap: () {
              // context.pushNamed(Routs.questions);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Continue',
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

class CustomeTextFiled extends StatelessWidget {
  String? title;
  void Function()? onTap;
  String? hintText;
  bool? readOnly;
  Widget? prefixIcon;
  double? height;
  TextEditingController? controller;

  CustomeTextFiled({
    this.title,
    this.hintText,
    this.onTap,
    this.controller,
    this.prefixIcon,
    this.height,
    this.readOnly,
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
              contentPadding: const EdgeInsets.only(left: 1),
              autofocus: true,
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
              padding: EdgeInsets.only(left: 8.0),
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
