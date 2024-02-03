import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/app_assets.dart';
import '../../../core/constant/gradients.dart';
import '../../../utils/widgets/appbar.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../../guest/guestProfile/guest_edit_profile.dart';
import '../../guest/guestProfile/guest_faq.dart';

class AddMemberForm extends StatefulWidget {
  const AddMemberForm({super.key});

  @override
  State<AddMemberForm> createState() => _AddMemberFormState();
}

class _AddMemberFormState extends State<AddMemberForm> {
  bool? validate = false;
  final _formKey = GlobalKey<FormState>();
  final switch1 = ValueNotifier<bool>(true);
  TextEditingController dateControlller = TextEditingController();
  TextEditingController enagicPasswordController = TextEditingController();
  TextEditingController enagicConfirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(size.height * 0.07),
          child: CustomAppBar(
            title: 'Add a Members',
            showLeadICon: false,
          )),
      body: Form(
        key: _formKey,
        // autovalidateMode: validate==true ? AutovalidateMode.always : AutovalidateMode.disabled,
        autovalidateMode: AutovalidateMode.disabled,
        child: ListView(
          padding: EdgeInsets.only(bottom: size.height * 0.12),
          children: [
            Container(
              height: size.height * 0.14,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: AssetImage(AppAssets.memberprofile), fit: BoxFit.contain)),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Row(
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
            CustomTextFieldApp(
              title: 'First Name',
              hintText: 'Enter First Name',
            ),
            CustomTextFieldApp(
              title: 'Last Name',
              hintText: 'Enter Last Name',
            ),
            CustomDropdown(
              title: 'Gender',
              listItem: const ['Male', 'Female'],
            ),
            CustomTextFieldApp(
              title: 'Mobile No.',
              hintText: 'Enter Mobile No.',
              keyboardType: TextInputType.number,
            ),
            CustomTextFieldApp(
              title: 'Email',
              hintText: 'email@gmail.com',
            ),
            CustomTextFieldApp(
              title: 'Occupation',
              hintText: 'Enter Your Occupation',
            ),
            CustomTextFieldApp(
              title: 'Occupation',
              hintText: 'Enter Your Occupation',
            ),
            Row(
              children: [
                Expanded(
                  child: CustomTextFieldApp(
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
                  child: CustomTextFieldApp(
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
                          decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                        ),
                        inactiveColor: Colors.grey,
                        borderRadius: BorderRadius.all(const Radius.circular(15)),
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
              hintText: 'Enter Members',
            ),
            CustomTextFieldApp(
              title: 'Monthly Income',
              hintText: 'Enter Income',
              keyboardType: TextInputType.number,
            ),
            CustomTextFieldApp(
              title: 'State',
              hintText: 'Enter State',
            ),
            CustomTextFieldApp(
              title: 'City',
              hintText: 'Enter City',
            ),
            CustomTextFieldApp(
              title: 'Pin Code',
              hintText: 'Enter Pin Code',
              keyboardType: TextInputType.number,
            ),
            CustomTextFieldApp(
              height: size.height * 0.06,
              title: 'Address',
              hintText: 'Enter Address',
            ),
            CustomTextFieldApp(
              title: 'Sponsor Name',
              hintText: 'Enter Sponsor Name',
            ),
            CustomTextFieldApp(
              title: 'Sales Facilitator',
              hintText: 'Enter Sales Facilitator Name',
            ),
            CustomTextFieldApp(
              controller: enagicPasswordController,
              title: 'Enagic Password',
              hintText: 'Enter Enagic Password',
            ),
            CustomTextFieldApp(
              controller: enagicConfirmPasswordController,
              title: 'Confirm Password',
              hintText: 'Enter Confirm Password',
              validator: (v) {
                if (v == enagicPasswordController.text) {
                  return null;
                } else if (v!.isEmpty) {
                  return 'Please Enter Confirm Password';
                } else {
                  return "Password doesn't match";
                }
              },
              onChanged: (v) {
                if (v == enagicPasswordController.text) {
                  validate = true;
                  setState(() {});
                }
              },
            ),
          ],
        ),
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
            onTap: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data')),
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
