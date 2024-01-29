import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/screens/guest/guestProfile/guest_faq.dart';
import 'package:mrwebbeast/screens/member/goal/create_goal.dart';
import 'package:provider/provider.dart';

import '../../../controllers/member/member_controller/member_controller.dart';
import '../../../core/constant/constant.dart';
import '../../../utils/widgets/custom_back_button.dart';
import '../../../utils/widgets/gradient_button.dart';

class ModelDialogBox extends StatefulWidget {
 final String guestId;
 final String status;
   ModelDialogBox({super.key,required this.guestId,required this.status});
  @override
  State<ModelDialogBox> createState() => _ModelDialogBoxState();
}
class _ModelDialogBoxState extends State<ModelDialogBox> {
  TextEditingController remarkController=TextEditingController();
  List item =['Hot','Worm','Cold'];
  String priority='';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  SizedBox(
      height:size.height*0.3 ,
      child: Scaffold(
        body: Center(
          child: Container(

            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
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
                  CustomeText(
                    text: 'Lead status',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
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
                            child: GestureDetector(
                              onTap: () {
                                priority =item[index];
                              },
                              child: Container(
                                decoration: ShapeDecoration(
                                  gradient:  LinearGradient(
                                    begin: const Alignment(0.61, -0.79),
                                    end: const Alignment(-0.61, 0.79),
                                    colors:index==0 ? [const Color(0xFFFF2600), const Color(0xFFFF6130)]:index==1?[const Color(0xFFFDDC9C), const Color(0xFFDDA53B)]: [const Color(0xFF3CDCDC), const Color(0xFF12BCBC)],
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
                            ),
                          );
                        },),
                    ),
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
                  GradientButton(
                    height: 70,
                    borderRadius: 18,
                    blur: 10,
                    backgroundGradient: primaryGradientTransparent,
                    backgroundColor: Colors.transparent,
                    boxShadow: const [],
                    margin: const EdgeInsets.only(left: 16, right: 24),
                    onTap: () async{
                               await context.read<MembersController>().updateLeadStatus(context: context,
                                   guestId: widget.guestId, status: widget.status, priority: priority, remark: remarkController.text);

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
            ),
          ),
        ),
      ),
    );
  }
}




