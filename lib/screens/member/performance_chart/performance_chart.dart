import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';

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
  List d =['d','s''d','s'];
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
      body: ListView(
        children: [
          // Padding(
          //   padding:
          //    const EdgeInsets.only(left: kPadding, right: kPadding, bottom: kPadding),
          //   child: Container(
          //     decoration: ShapeDecoration(
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(18),
          //         ),
          //         gradient: const LinearGradient(
          //             colors: [Color(0xFF1B1B1B), Color(0xFF1B1B1B)])),
          //     child:
          //     ExpansionTile(
          //       iconColor: expend == true ? Colors.black : Colors.white,
          //       trailing: const SizedBox.shrink(),
          //     tilePadding: EdgeInsets.all(0),
          //       leading: const SizedBox.shrink(),
          //       childrenPadding: EdgeInsets.all(0),
          //
          //       onExpansionChanged: (value) {
          //         expend = value;
          //         setState(() {});
          //       },
          //       title: Container(
          //         decoration: BoxDecoration(
          //             gradient: expend == true?primaryGradient:const LinearGradient(
          //                 colors: [Color(0xFF1B1B1B), Color(0xFF1B1B1B)])
          //         ),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Expanded(
          //               child: CustomText1(
          //                 text: 'controller.fetchFaqsModel?.data?[index].question',
          //                 fontSize: 16,
          //                 fontWeight: FontWeight.w600,
          //                 color:
          //                 expend == true  ? Colors.black : Colors.white,
          //               ),
          //             ),
          //           Icon(expend == true?AntDesign.minus:Icons.add)
          //           ],
          //         ),
          //       ),
          //       children: <Widget>[
          //         ListTile(
          //             title: CustomText1(
          //               text: 'controller.fetchFaqsModel?.data?[index].answer',
          //               fontSize: 14,
          //               fontWeight: FontWeight.w400,
          //               color: expend == true
          //                   ? Colors.black
          //                   : Colors.white,
          //             )),
          //       ],
          //     ),
          //   ),
          // )
          Padding(
            padding: const EdgeInsets.only(left: kPadding,right: kPadding),
            child: GestureDetector(
              onTap: () {
                expend =!expend;
                setState(() {});
              },
              child: Container(
                decoration:  BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                    gradient: const LinearGradient(
                        colors: [Color(0xFF1B1B1B), Color(0xFF1B1B1B)])),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                        gradient:expend==true? primaryGradient:null
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CustomText1(
                                text: 'controller.fetchFaqsModel?.data?[index].question',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color:
                                expend == true  ? Colors.black : Colors.white,
                              ),
                            ),
                            Icon(expend == true?AntDesign.minus:Icons.add)
                          ],
                        ),
                      ),
                    ),
                    if( expend == true)
                    ...d.map((e) {
                      return
                        CustomText1(
                          text: 'Invitation call count',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        );
                    },)


                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
