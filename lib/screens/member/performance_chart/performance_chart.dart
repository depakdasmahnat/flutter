import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/utils/widgets/loading_screen.dart';
import 'package:provider/provider.dart';

import '../../../controllers/member/member_controller/member_controller.dart';
import '../../../core/constant/constant.dart';
import '../../../utils/widgets/appbar.dart';
import '../../guest/guest_check_demo/guest_check_demo_step2.dart';

class PerformanceChart extends StatefulWidget {
  const PerformanceChart({super.key});

  @override
  State<PerformanceChart> createState() => _PerformanceChartState();
}

class _PerformanceChartState extends State<PerformanceChart> {
  bool expend = false;
  int? tabIndex =-1;
  Color? inactiveColor =const Color(0xFFBEBEBE);
  List d =['d','s''d','s'];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<MembersController>().fetchPerformanceChart();

    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(size.height * 0.08),
          child: CustomAppBar(
            showLeadICon: true,
            title: 'Performance Chart',
          )),
      body: Consumer<MembersController>(
        builder: (context, controller, child) {
          return   controller.performanceLoader==false? const LoadingScreen():  ListView.builder(
            itemCount: controller.getPerformanceChart?.data?.length??0,
            itemBuilder: (context, index) {
              return   Padding(
                padding: const EdgeInsets.only(left: kPadding,right: kPadding,bottom: kPadding),
                child: GestureDetector(
                  onTap: () {
                    // expend =!expend;
                    if(tabIndex ==index){
                      tabIndex=-1;
                    }else{
                      tabIndex =index;
                    }

                    setState(() {});
                  },
                  child: Container(
                    decoration:  BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: const LinearGradient(
                            colors: [Color(0xFF1B1B1B), Color(0xFF1B1B1B)])),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              gradient:tabIndex ==index? primaryGradient:null
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: kPadding,right: kPadding,top: 12,bottom: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: CustomText1(
                                    text: '${controller.getPerformanceChart?.data?[index].rankName} Performance Chart',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color:
                                    tabIndex ==index  ? Colors.black : Colors.white,
                                  ),
                                ),
                                Icon(tabIndex ==index?AntDesign.minus:Icons.add,color:tabIndex ==index  ? Colors.black : Colors.white,)
                              ],
                            ),
                          ),
                        ),
                        if( tabIndex ==index&&controller.getPerformanceChart?.data?[index].indexes?.isNotEmpty==true)
                          ...?controller.getPerformanceChart?.data?[index].indexes?.map((e) {
                            return
                              Padding(
                                padding: const EdgeInsets.only(left: kPadding,right: kPadding,),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText1(
                                          text:e.title,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                        CircleAvatar(
                                          minRadius: 14,
                                          maxRadius: 14,
                                          backgroundColor: inactiveColor,
                                          child: CustomText1(
                                            text: e.value,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w100,
                                          ),
                                        )
                                      ],
                                    ),
                                    const Divider(
                                      thickness: 1,
                                      color: Color(0xFF424242),
                                    ),

                                  ],
                                ),
                              );
                          },)


                      ],
                    ),
                  ),
                ),
              );
            },);
        },


      ),
    );
  }
}
