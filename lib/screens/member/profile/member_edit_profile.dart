import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/route/route_paths.dart';
import 'package:mrwebbeast/screens/guest/guestProfile/guest_faq.dart';
import 'package:mrwebbeast/utils/widgets/appbar.dart';

import '../../../core/config/app_assets.dart';
import '../../../core/constant/gradients.dart';

import '../../../utils/widgets/gradient_button.dart';
import '../../guest/guestProfile/guest_edit_profile.dart';

class MemberEditProfile extends StatefulWidget {
  const MemberEditProfile({super.key});

  @override
  State<MemberEditProfile> createState() => _MemberEditProfileState();
}

class _MemberEditProfileState extends State<MemberEditProfile> {
  final switch1 = ValueNotifier<bool>(true);
  TextEditingController dateControlller =TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return
      Scaffold(
        resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
          preferredSize:Size.fromHeight(size.height*0.07) ,
          child: CustomAppBar(
            title: 'Edit Profile',
            showLeadICon: false,
          )),
      body: ListView(
        padding: EdgeInsets.only(bottom: size.height*0.12),
         children: [
          Container(
            height: size.height*0.14,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(AppAssets.memberprofile),
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
           const CustomTextFieldApp(
             title: 'First Name',
             hintText: 'Enter First Name',

           ),
           const CustomTextFieldApp(
             title: 'Last Name',
             hintText: 'Enter Last Name',

           ),
           CustomeDropdown(
             title: 'Gender',
             listItem: const ['Male','Female'],
           ),
           const CustomTextFieldApp(
             title: 'Email',
             hintText: 'email@gmail.com',

           ),
           const CustomTextFieldApp(
             title: 'Occupation',
             hintText: 'Enter Your Occupation',

           ),
           const CustomTextFieldApp(
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
                             inputDecorationTheme: const InputDecorationTheme(
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
               const Expanded(
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
                       decoration: const BoxDecoration(
                         color: Colors.black,
                        shape: BoxShape.circle
                       ),
                      ) ,
                       inactiveColor: Colors.grey,
                       borderRadius: const BorderRadius.all(Radius.circular(15)),
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
           const CustomTextFieldApp(
             title: 'Any Illness In Family Members',
             hintText: 'Enter Members',


           ),

           const CustomTextFieldApp(
             title: 'Monthly Income',
             hintText: 'Enter Income',
             keyboardType: TextInputType.number,

           ),
           const CustomTextFieldApp(
             title: 'State',
             hintText: 'Enter State',


           ),
           const CustomTextFieldApp(
             title: 'City',
             hintText: 'Enter City',
           ),
           const CustomTextFieldApp(
             title: 'Pin Code',
             hintText: 'Enter Pin Code',
             keyboardType: TextInputType.number,
           ),
           CustomTextFieldApp(
             height: size.height*0.06,
             title: 'Address',
             hintText: 'Enter Address',

           ),
           const CustomTextFieldApp(

             title: 'Enagic ID',
             hintText: 'Enter Enagic ID',

           ),
           const CustomTextFieldApp(
             title: 'Enagic Password',
             hintText: 'Enter Enagic Password',
           ),
           const CustomTextFieldApp(
             title: 'Confirm Password',
             hintText: 'Enter Confirm Password',
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
             margin: const EdgeInsets.only(left: 16, right: 24),
             onTap: () {
               context.pushNamed(Routs.memberaddList);
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
           SizedBox(height: size.height*0.02,)
         ],
       ),

    );
  }
}
