import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/screens/guest/guestProfile/guest_faq.dart';
import 'package:mrwebbeast/utils/widgets/loading_screen.dart';
import 'package:provider/provider.dart';

import '../../../controllers/member/leads/leads_controllers.dart';
import '../../../controllers/member/member_controller/member_controller.dart';
import '../../../core/constant/constant.dart';
import '../../../models/default/default_model.dart';
import '../../../utils/widgets/appbar.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../demo/create_demo.dart';

class DemoDoneForm extends StatefulWidget {
 final String? title;
 final String? demoId;
 final String? date;
 final String? time;
 final bool? apiCall;
  const DemoDoneForm({super.key,this.title,this.demoId,this.apiCall,this.date,this.time});

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
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<ListsControllers>().fetchObject(context: context);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
 print("check api calling ${widget.date}");
 print("check api calling ${widget.time}");
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
                  shrinkWrap: true,
                  children: [
                    Consumer<ListsControllers>(
                      builder: (context, controller, child) {
                        return controller.fetchObjectLoader==false?const LoadingScreen():  ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.fetchObjectModel?.data?.length??0,
                          itemBuilder: (context, index) {
                            return   Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {

                                  controller.addIndex(index);
                                  feedback =controller.fetchObjectModel?.data?[index].id.toString()??'';
                                  this.setState(() {});
                                },
                                child: Container(
                                  decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      gradient: controller.tabIndex==index?primaryGradient:const LinearGradient(colors: [
                                        Color(0xFF1B1B1B),
                                        Color(0xFF1B1B1B)
                                      ])
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(kPadding),
                                    child: CustomeText(
                                      text: controller.fetchObjectModel?.data?[index].name,
                                      fontSize: 16,
                                      color: controller.tabIndex==index?Colors.black:Colors.white,
                                      fontWeight:controller.tabIndex==index?FontWeight.w600: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },);
                      },

                    ),
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
                        if(widget.apiCall==true){
                          DefaultModel? model = await context.read<MembersController>().demoDoneForm(context: context,
                              demoId: widget.demoId, feedback: feedback, remark: remarkController.text, priority: priority);
                          if(model?.status==true){


                            await context.read<MembersController>().fetchLeads(status: 'Follow Up', priority: '', page: '1',searchKey: '');
                          }
                        }else{
                          DefaultModel? model=   await context.read<ListsControllers>().rescheduledCall(
                              context: context,
                              guestId: widget.demoId.toString()??'',
                              reason: remarkController.text,
                              date: widget.date??'',
                              time: widget.time??'',
                              LMSStep: 'Demo Scheduled ',
                              priority: priority,
                              demoRescheduleRemark: feedback);
                          if(model?.status==true){
                            context.pop();
                            context.pop();
                            await context.read<MembersController>().fetchLeads(status: 'Demo Scheduled', priority: '', page: '1',searchKey: '');
                          }
                          // await context.read<MembersController>().demoDoneForm(context: context,
                          //     demoId: widget.demoId, feedback: feedback, remark: remarkController.text, priority: priority);
                        }

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
