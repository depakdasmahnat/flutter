import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/screens/guest/guestProfile/guest_faq.dart';
import 'package:provider/provider.dart';

import '../../../controllers/member/member_controller/member_controller.dart';
import '../../../core/constant/constant.dart';
import '../../../utils/widgets/appbar.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../demo/create_demo.dart';

class DemoDoneForm extends StatefulWidget {
 final String? title;
 final String? demoId;
  const DemoDoneForm({super.key,this.title,this.demoId});

  @override
  State<DemoDoneForm> createState() => _DemoDoneFormState();
}

class _DemoDoneFormState extends State<DemoDoneForm> {
  TextEditingController remarkController =TextEditingController();
  bool validate =true;
  int tabIndex =-1;
  int tabIndex1 =-1;
  String priority ='';
  String feedback ='';
  List item1 =['Hot','Worm','Cold'];
  List item =['Will rethink about it','Need to talk with some friends and family','Issue with pyramidal scheme'];
  @override
  Widget build(BuildContext context) {
    print("check demo id ${widget.demoId}");
    Size size = MediaQuery.of(context).size;
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return SizedBox(
          height: size.height * 0.75,
          child: Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(size.height * 0.08),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomAppBar(
                    showLeadICon: true,
                    title: widget.title,
                  ),
                )),
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                autovalidateMode:validate==true ? AutovalidateMode.always: AutovalidateMode.disabled,
                child: ListView(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: item.length??0,
                      itemBuilder: (context, index) {
                      return   Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            tabIndex =index;
                            feedback =item[index];
                            this.setState(() {});
                          },
                          child: Container(
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              gradient: tabIndex==index?primaryGradient:const LinearGradient(colors: [
                                Color(0xFF1B1B1B),
                                Color(0xFF1B1B1B)
                              ])
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(kPadding),
                              child: CustomeText(
                                text: item[index],
                                fontSize: 16,
                                color: tabIndex==index?Colors.black:Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      );
                    },),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: CustomeText(
                        text: 'Lead status',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height:size.height*0.01,
                    ),
                    SizedBox(
                      height: size.height*0.06,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: item1.length,
                        itemBuilder: (context, index) {
                          return   Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                tabIndex1=index;
                                priority =item1[index];
                                setState(() {});
                              },
                              child: Container(
                                decoration:BoxDecoration(
                                  borderRadius: BorderRadius.circular(39),
                                  border:tabIndex1==index? Border.all( color: CupertinoColors.white,width: 2):null,
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
                                        text: item1[index],fontWeight: FontWeight.w500,fontSize: 10,
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
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: CustomeText(
                        text: 'Remark',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height:size.height*0.02,
                    ),
                    AppTextField(
                      controller: remarkController,
                      hintText: 'Comment',
                      height: size.height*0.04,
                  padding: const EdgeInsets.only(left: 10),
                    ),
                    SizedBox(
                      height:size.height*0.04,
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
                        await context.read<MembersController>().demoDoneForm(context: context,
                            demoId: widget.demoId, feedback: feedback, remark: remarkController.text, priority: priority);
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
            )

          ),
        );
      },
    );
  }
}
