import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/controllers/guest_controller/guest_controller.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/screens/guest/guestProfile/guest_faq.dart';
import 'package:mrwebbeast/screens/member/goal/create_goal.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../controllers/member/member_controller/member_controller.dart';
import '../../../core/constant/constant.dart';
import '../../../models/default/default_model.dart';
import '../../../utils/validators.dart';
import '../../../utils/widgets/custom_back_button.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../../../utils/widgets/widgets.dart';

class ModelDialogBox extends StatefulWidget {
 final String guestId;
 final String feedback;
 final bool changePopUp;
   const ModelDialogBox({super.key,required this.guestId,required this.feedback,required this.changePopUp});
  @override
  State<ModelDialogBox> createState() => _ModelDialogBoxState();
}
class _ModelDialogBoxState extends State<ModelDialogBox> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  TextEditingController remarkController=TextEditingController();
  TextEditingController enagicIdController=TextEditingController();
  TextEditingController enagicPassController=TextEditingController();
  TextEditingController enagicConPassController=TextEditingController();
  List item =['Hot','Worm','Cold'];
  bool validate =true;
  String priority='Hot';
  int? tabIndex=0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(

          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              begin: Alignment(0.00, -1.00),
              end: Alignment(0, 1),
              colors: [Color(0xFF1B1B1B), Color(0xFF282828)],
            ),
          ),
          child:
          Padding(
            padding: const EdgeInsets.only(left: kPadding,),
            child: widget.changePopUp==false?
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(''),
                      CustomeText(
                        text: 'Remark',
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: CupertinoColors.white,
                      ),
                      const CustomBackButton(
                        padding: EdgeInsets.all(8),
                        icon: AntDesign.close,
                      )
                    ],
                  ),
                ),
                CustomeText(
                  text: 'Lead status',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(
                  height:size.height*0.01,
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
                        return   Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              tabIndex=index;
                              priority =item[index];
                              setState(() {});
                            },
                            child: Container(
                              decoration:BoxDecoration(
                                borderRadius: BorderRadius.circular(39),
                                border:tabIndex==index? Border.all( color: CupertinoColors.white,width: 2):null,
                                gradient:  LinearGradient(
                                  begin: const Alignment(0.61, -0.79),
                                  end: const Alignment(-0.61, 0.79),
                                  colors:index==0 ? [const Color(0xFFFF2600), const Color(0xFFFF6130)]:index==1?[const Color(0xFFFDDC9C), const Color(0xFFDDA53B)]: [const Color(0xFF3CDCDC), const Color(0xFF12BCBC)],
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
                          ),
                        );
                      },),
                  ),
                ),
                SizedBox(
                  height:size.height*0.01,
                ),
                CustomeText(
                  text: 'Remark',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                AppTextField(
                  controller: remarkController,
                  hintText: 'Comment',
                  height: size.height*0.04,
                ),
                SizedBox(
                  height:size.height*0.02,
                ),
                GradientButton(
                  height: 70,
                  borderRadius: 18,
                  blur: 10,
                  backgroundGradient: primaryGradient,
                  backgroundColor: Colors.transparent,
                  boxShadow: const [],
                  margin: const EdgeInsets.only(left: 16, right: 24),
                  onTap: () async{
                             await context.read<MembersController>().updateLeadPriority(context: context,
                                 guestId: widget.guestId, feedback: widget.feedback, priority: priority, remark: remarkController.text);
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
               SizedBox(
                 height:size.height*0.04,
               )
              ],
            ):
            Form(
              key:_form ,
              // autovalidateMode:validate==true ? AutovalidateMode.always: AutovalidateMode.disabled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(''),
                        Column(
                          children: [
                            CustomeText(
                              text: 'Enagic ID',
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: CupertinoColors.white,
                            ),
                            CustomeText(
                              text: 'Enter enagic ID and enagic password',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: CupertinoColors.white,
                            ),
                          ],
                        ),
                        const CustomBackButton(
                          padding: EdgeInsets.all(8),
                          icon: AntDesign.close,
                        )
                      ],
                    ),
                  ),
                  // CustomeText(
                  //   text: 'Lead status',
                  //   fontSize: 16,
                  //   fontWeight: FontWeight.w400,
                  // ),
                  // SizedBox(
                  //   height:size.height*0.01,
                  // ),
                  // SizedBox(
                  //   height: size.height*0.06,
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(left: 9.0),
                  //     child: ListView.builder(
                  //       shrinkWrap: true,
                  //       scrollDirection: Axis.horizontal,
                  //       itemCount: item.length,
                  //       itemBuilder: (context, index) {
                  //         return   Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: GestureDetector(
                  //             onTap: () {
                  //               tabIndex=index;
                  //               priority =item[index];
                  //               setState(() {});
                  //             },
                  //             child: Container(
                  //               decoration:BoxDecoration(
                  //                 borderRadius: BorderRadius.circular(39),
                  //                 border:tabIndex==index? Border.all( color: CupertinoColors.white,width: 2):null,
                  //                 gradient:  LinearGradient(
                  //                   begin: const Alignment(0.61, -0.79),
                  //                   end: const Alignment(-0.61, 0.79),
                  //                   colors:index==0 ? [const Color(0xFFFF2600), const Color(0xFFFF6130)]:index==1?[const Color(0xFFFDDC9C), const Color(0xFFDDA53B)]: [const Color(0xFF3CDCDC), const Color(0xFF12BCBC)],
                  //                 ),
                  //               ),
                  //               child:SizedBox(
                  //                 width: size.width*0.11,
                  //                 child: Center(
                  //                   child: Padding(
                  //                     padding: const EdgeInsets.only(top: 4,bottom: 4),
                  //                     child: CustomeText(
                  //                       text: item[index],fontWeight: FontWeight.w500,fontSize: 10,
                  //                       color: Colors.white,
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ) ,
                  //             ),
                  //           ),
                  //         );
                  //       },),
                  //   ),
                  // ),
                  SizedBox(
                    height:size.height*0.01,
                  ),

                  AppTextField(
                    controller: enagicIdController,
                    hintText: 'Enter Enagic ID',
                    validator:
                    (value) {
                      if(value!.isEmpty || value ==null){
                        return 'Please Enter Enagic ID ';
                      }else{
                        return null;
                      }

                    },
                    onFieldSubmitted: (v) {
                      final random = Random().nextInt(999999);
                      enagicPassController.text =random.toString();
                      setState(() {});

                    },
                    onChanged: (v) {
                      if(v.isEmpty){
                        enagicPassController.clear();
                      }

                    },

                    title:'Enagic ID' ,
                    height: size.height*0.04,
                  ),
                  SizedBox(
                    height:size.height*0.02,
                  ),
                  AppTextField(
                    controller: enagicPassController,
                    suffixIconConstraints: const BoxConstraints(
                        minHeight: 10,
                        minWidth: 10
                    ),
                    suffixIcon:GestureDetector(
                        onTap: () {
                          if(validate==true){
                            validate=false;
                          }else{
                            validate=true;
                          }
                          setState(() {

                          });
                        },
                        child: validate==false? const Icon(Ionicons.eye_outline,color: Colors.white,):const Icon(Ionicons.eye_off_sharp,color: Colors.white,)),
                    validator: (value) {
                      if(value!.isEmpty || value ==null){
                        return 'Please Enter Enagic Password';
                      }else{
                        return null;
                      }

                    },
                    hintText: 'Enagic Password',
                    title:'Enter Enagic Password' ,
                    obscureText: validate,
                    obscuringCharacter: '*',
                  ),
                  SizedBox(
                    height:size.height*0.02,
                  ),

                  GradientButton(
                    height: 70,
                    borderRadius: 18,
                    blur: 10,
                    backgroundGradient: primaryGradient,
                    backgroundColor: Colors.transparent,
                    boxShadow: const [],
                    margin: const EdgeInsets.only(left: 16, right: 24),
                    onTap: () async{
                      if (_form.currentState?.validate() == true) {
                        DefaultModel? responseData=await context.read<MembersController>().leadClose(context: context,
                            guestId: widget.guestId, enagicId: enagicIdController.text, password: enagicPassController.text);
                        if(responseData?.status==true){
                          Share.share('Enagic Id - $enagicIdController  , Password-$enagicPassController',);
                        }

                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Save & Send',
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
                    height:size.height*0.04,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class ModelDialogBox1 extends StatefulWidget {

  const ModelDialogBox1({super.key,});
  @override
  State<ModelDialogBox1> createState() => _ModelDialogBox1State();
}
class _ModelDialogBox1State extends State<ModelDialogBox1> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<MembersController>().fetchReferral(context: context);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Consumer<MembersController>(
      builder: (context, controller, child) {

        return  Scaffold(
          backgroundColor: Colors.transparent,
          body:  Center(
            child: Container(

              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: primaryGradient
              ),
              child:
              Padding(
                  padding: const EdgeInsets.only(left: kPadding,),
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(''),
                            CustomeText(
                              text: 'Invite a Leads',
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: CupertinoColors.black,
                            ),
                            const CustomBackButton(
                              padding: EdgeInsets.all(8),
                              icon: AntDesign.close,
                            )
                          ],
                        ),
                      ),
                      CustomeText(
                        textAlign: TextAlign.center,
                        text: 'Lorem Ipsum is simply dummy text of the printing\nand typesetting industry. ',
                        fontWeight: FontWeight.w400,fontSize: 14,
                        color: Colors.black,
                      ),
                      SizedBox(
                        height: size.height*0.07,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,

                        children: [
                          SizedBox(
                            height: size.height*0.07,
                            width: size.width*0.4,
                            child: GestureDetector(
                              onTap: () {
                                Clipboard.setData( ClipboardData(text: controller.generateReferralModel?.data?.referCode??''));
                                showSnackBar(context: context,  color: Colors.green, text: 'Copy ${controller.generateReferralModel?.data?.referCode}');
                              },
                              child: DottedBorder(

                                  dashPattern: [10],
                                  borderType:
                                  BorderType.RRect,
                                  radius:
                                  const Radius.circular(30),
                                  child:Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          gradient: primaryGradient
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(kPadding),
                                        child:controller.generateRefLoader==false?const Center(
                                          child: CupertinoActivityIndicator(
                                              radius: 15, color: CupertinoColors.black),
                                        )  : Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.asset(AppAssets.group,height: size.height*0.04,),
                                            const SizedBox(width: 10,),
                                            CustomeText(

                                              text: controller.generateReferralModel?.data?.referCode,
                                              fontSize: 17,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ],
                                        ),
                                      )
                                  )

                              ),
                            ),
                          ),
                          GradientButton(
                            borderRadius: 30,
                            width: size.width*0.4,
                            backgroundColor: Colors.black,
                            boxShadow: const [],
                            // margin: const EdgeInsets.only(left: 16, right: 24),
                            onTap: () {
                              Share.share('${controller.generateReferralModel?.data?.message}',);

                            },
                            child: Padding(
                              padding: const EdgeInsets.all(kPadding),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Invite Leads',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: GoogleFonts.urbanist().fontFamily,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      )

                    ],
                  )


              ),
            ),
          ),
        );
      },


    );
  }
}



class ModelDialogBoxForBanner extends StatefulWidget {
  final String eventID;

  const ModelDialogBoxForBanner({super.key,required this.eventID,});
  @override
  State<ModelDialogBoxForBanner> createState() => _ModelDialogBoxForBannerState();
}
class _ModelDialogBoxForBannerState extends State<ModelDialogBoxForBanner> {
  String nameType ='';
  int tabIndex=-1;
  List item =['I Will  Attend','Attend with others','Not interested'];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            // height: size.height*0.4,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),

            ),
            child:
             Padding(
              padding: const EdgeInsets.all(kPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [CustomBackButton(
                      icon: AntDesign.close,
                    )],
                  ),
                  CustomeText(
                    text: 'Do you want to Attend',
                    fontSize: 32,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  CustomeText(
                    text: 'this event',
                    fontSize: 32,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(
                    height: size.height*0.05,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: item.length??0,
                    itemBuilder: (context, index) {
                    return    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: GradientButton(
                        height: 70,
                        borderRadius: 18,
                        blur: 10,
                        backgroundGradient:tabIndex==index?primaryGradient: inActiveGradient,
                        backgroundColor: Colors.transparent,
                        boxShadow: const [],
                        margin: const EdgeInsets.only(left: 16, right: 24),
                        onTap: () async{
                          nameType =item[index];
                          tabIndex =index;
                          setState(() {});
                          print(" ecent id ${widget.eventID}");
                        await  context.read<GuestControllers>().attendEvent(context: context, eventId: widget.eventID, feedback: nameType);
                          ;

                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item[index],
                              style: TextStyle(
                                color:tabIndex==index?Colors.black: Colors.white,
                                fontFamily: GoogleFonts.urbanist().fontFamily,
                                fontWeight:tabIndex==index?FontWeight.w800 :FontWeight.w600,
                                fontSize:tabIndex==index? 19:16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },)


                ],
              )

            ),

          ),
        ),
      ),
    );
  }
}



class ModelDialogBoxForRescheduled extends StatefulWidget {
  final String eventID;

  const ModelDialogBoxForRescheduled({super.key,required this.eventID,});
  @override
  State<ModelDialogBoxForRescheduled> createState() => _ModelDialogBoxForRescheduledState();
}
class _ModelDialogBoxForRescheduledState extends State<ModelDialogBoxForRescheduled> {
  String nameType ='';
  int tabIndex=-1;
  List item =['I Will  Attend','Attend with others','Not interested'];
  Color? pupUpTextColor =const Color(0xFFA0A0A0);
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return  Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(35),
        child: Center(
          child: Container(
            // height: size.height*0.4,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF1C1C1C),
              borderRadius: BorderRadius.circular(18),

            ),
            child:
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: size.height*0.02,
                ),
                CustomeText(
                  text: 'No answer',
                  fontSize: 18,
                  color:pupUpTextColor,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(
                  height: size.height*0.02,
                ),
                const Divider(
                  thickness: 2,
                  color: Color(0xFF212121),
                ),
                SizedBox(
                  height: size.height*0.02,
                ),
                CustomeText(
                  text: 'Could not connect',
                  fontSize: 18,
                  color:pupUpTextColor,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(
                  height: size.height*0.02,
                ),
                const Divider(
                  thickness: 2,
                  color: Color(0xFF212121),
                ),
                SizedBox(
                  height: size.height*0.02,
                ),
                GestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: CustomeText(

                    text: 'Call back request',
                    fontSize: 18,
                    color:pupUpTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: size.height*0.02,
                ),
                const Divider(
                  thickness: 2,
                  color: Color(0xFF212121),
                )


              ],
            ),

          ),
        ),
      ),
    );
  }
}


