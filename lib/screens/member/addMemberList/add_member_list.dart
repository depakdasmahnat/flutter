import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/config/app_assets.dart';
import '../../../core/constant/gradients.dart';
import '../../../core/route/route_paths.dart';
import '../../../guest/guestProfile/guest_edit_profile.dart';
import '../../../guest/guestProfile/guest_faq.dart';
import '../../../utils/widgets/appbar.dart';
import '../../../utils/widgets/gradient_button.dart';

class AddMemberList extends StatefulWidget {
  const AddMemberList({super.key});

  @override
  State<AddMemberList> createState() => _AddMemberListState();
}

class _AddMemberListState extends State<AddMemberList> {
  final switch1 = ValueNotifier<bool>(true);
  List item =['Hot','Worm','Cold'];
  TextEditingController dateControlller =TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return   Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
          preferredSize:Size.fromHeight(size.height*0.07) ,
          child: CustomAppBar(
            title: 'Add a List',
            showLeadICon: false,
          )),
      body:
      ListView(
        padding: EdgeInsets.only(bottom: size.height*0.12),
        children: [
          Container(
            height: size.height*0.14,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: AssetImage(AppAssets.admemberlist),
                    fit: BoxFit.contain
                )
            ),
          ),
          SizedBox(
            height: size.height*0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppAssets.upload,height: size.height*0.02),
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
          CustomeTextFiled(
            title: 'List First Name',
            hintText: 'Enter First Name',

          ),
          CustomeTextFiled(
            title: 'List Last Name',
            hintText: 'Enter Last Name',

          ),
          CustomeDropdown(
            title: 'Gender',
            listItem: const ['Male','Female'],
          ),
          CustomeTextFiled(
            title: 'List Mobile No.',
            hintText: 'Enter Mobile No.',
            keyboardType: TextInputType.number,

          ),
          CustomeTextFiled(
            title: 'List Email',
            hintText: 'email@gmail.com',

          ),
          CustomeDropdown(
            title: 'List Status',
            listItem: const ['Family','Friend','Professional','Society','Random'],
          ),
          Row(
            children: [
              Expanded(
                child: CustomeTextFiled(
                  title: 'Date of Birth',
                  hintText: 'dd/mm/yyyy',
                  controller: dateControlller,
                  onTap: ()async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            popupMenuTheme: PopupMenuThemeData(shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
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

                    if(pickedDate !=null){
                      dateControlller.text = "${pickedDate.day.toString().padLeft(2,"0")}/${pickedDate.month.toString().padLeft(2,"0")}/${pickedDate.year}";
                    }
                  },
                  readOnly: true,
                ),
              ),
              Expanded(
                child: CustomeTextFiled(
                  title: 'No. of family Members',
                  keyboardType: TextInputType.number,
                  hintText: 'Enter No. of family Members',

                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 9.0),
            child: CustomeText(
              text: 'Lead status',
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            height: size.height*0.06,
            child: Padding(
              padding: const EdgeInsets.only(left: 9.0),
              child: ListView.builder(
                shrinkWrap: true,
               scrollDirection: Axis.horizontal,
                itemCount: item.length,
                itemBuilder: (context, index) {
                return    Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: ShapeDecoration(
                      gradient:  LinearGradient(
                        begin: const Alignment(0.61, -0.79),
                        end: const Alignment(-0.61, 0.79),
                        colors:index==0 ? [const Color(0xFFFF2600), const Color(0xFFFF6130)]:index==1?[const Color(0xFFFDDC9C), const Color(0xFFDDA53B)]: [const Color(0xFF3CDCDC), Color(0xFF12BCBC)],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(39),
                      ),
                    ),
                    child:SizedBox(
                      width: size.width*0.11,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4,bottom: 4),
                          child: CustomeText(
                            text: item[index],fontWeight: FontWeight.w500,fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ) ,
                  ),
                );
              },),
            ),
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
                padding:  const EdgeInsets.all(18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomeText(
                      text: 'Disability',
                    ),
                    AdvancedSwitch(
                      controller: switch1,
                      thumb: Container(
                        decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle
                        ),
                      ) ,
                      inactiveColor: Colors.grey,
                      borderRadius: BorderRadius.all(const Radius.circular(15)),
                      width: size.height*0.06,
                      height: size.height*0.03,
                      enabled: true,
                      disabledOpacity: 0.5,
                    ),
                  ],
                ),
              ),

            ),
          ),
          CustomeTextFiled(
            title: 'Any Illness In Family Members',
            hintText: 'Enter Members',


          ),
          CustomeTextFiled(
            title: 'Monthly Income',
            hintText: 'Enter Income',
            keyboardType: TextInputType.number,

          ),
          CustomeTextFiled(
            title: 'State',
            hintText: 'Enter State',


          ),
          CustomeTextFiled(
            title: 'City',
            hintText: 'Enter City',


          ),
          CustomeTextFiled(
            title: 'Pin Code',
            hintText: 'Enter Pin Code',


          ),
          CustomeTextFiled(
            height: size.height*0.04,
            title: 'Address',
            hintText: 'Enter Address',


          ),
          CustomeTextFiled(
            title: 'Sponsor Name',
            hintText: 'Enter Sponsor Name',


          ),



        ],
      ),
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GradientButton(
            height: 70,
            borderRadius: 18,
            backgroundGradient: primaryGradient,
            backgroundColor: Colors.transparent,
            boxShadow: const [],
            margin: const EdgeInsets.only(left: 16, right: 24),
            onTap: () {
              context.pushNamed(Routs.memberaddForm);
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
          SizedBox(height: size.height*0.02,)
        ],
      ),

    );
  }
}
