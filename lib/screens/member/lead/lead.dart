import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';


import '../../../core/config/app_assets.dart';
import '../../../core/constant/constant.dart';
import '../../../utils/widgets/appbar.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/image_view.dart';
import '../../guest/guestProfile/guest_faq.dart';

class Lead extends StatefulWidget {
  const Lead({super.key});

  @override
  State<Lead> createState() => _LeadState();
}

class _LeadState extends State<Lead> {
  int tabIndex =0;
  List tabItem =['New Listed','Invitation call','Demo Scheduled','Follow Up','Closing'];
  List item = [
    {
      'image': '08',
      'first': 'Leads\nAdded',
      'second': 'Getting Started',
      'gradiant': primaryGradient,
      'color': const Color(0xFFE1FF41),
    },
    {
      'image': '02',
      'first': 'Demo\nScheduled',
      'second': 'How to Invest',
      'gradiant': null,
      'color': const Color(0xFFE1FF41),
    },
    {
      'image':'04',
      'first': 'Demo\nScheduled',
      'second': 'Payment Meth…',
      'gradiant': null,
      'color': Colors.white,
    },
    {
      'image':'04',
      'first': 'Leads\nClosed',
      'second': 'Payment Meth…',
      'gradiant': null,
      'color': Colors.white,
    }
  ];
  List item1 = [
    {
      'image': '06',
      'first': 'Hot Leads',
      'second': 'Getting Started',
      'gradiant': primaryGradient,
      'color': const Color(0xFFE1FF41),
    },
    {
      'image': '04',
      'first': 'Warm Leads',
      'second': 'How to Invest',
      'gradiant': null,
      'color': const Color(0xFFE1FF41),
    },
    {
      'image':'09',
      'first': 'Cold Leads',
      'second': 'Payment Meth…',
      'gradiant': null,
      'color': Colors.white,
    },


  ];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar:
      PreferredSize(
          preferredSize: Size.fromHeight(size.height * 0.54),
          child: CustomAppBar(
            showLeadICon: false,
            title: 'List',
            bottom:
            PreferredSize(
              preferredSize:  Size.fromHeight(size.height * 0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment(0.00, -1.00),
                        end: Alignment(0, 1),
                        colors: [Color(0xFF3B3B3B), Color(0xFF4A4A4A)],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: SizedBox(
                        height: size.height*0.07,
                        child: ListView.builder(
                          itemCount: tabItem.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              tabIndex =index;
                              setState(() {});
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: size.width*0.3,
                                height:size.width*0.06 ,
                                decoration: ShapeDecoration(
                                  gradient:index ==tabIndex? primaryGradient:null,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Center(child: CustomeText(text: tabItem[index],fontSize: 14,fontWeight: FontWeight.w600,color:index ==tabIndex?Colors.black: Colors.white,))
                                ,
                              ),
                            ),
                          );
                        },),
                      ),
                    )

                  ),
                  SizedBox(
                    height: size.height * 0.13,
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 8),
                      scrollDirection: Axis.horizontal,
                      itemCount: item.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(3),
                          child: Container(
                            width: size.width*0.22,
                            decoration: ShapeDecoration(
                              gradient: index == 0
                                  ? primaryGradient
                                  : index == 1
                                  ? const LinearGradient(colors: [Color(0xFFF3F3F3), Color(0xFFE0E0E0)])
                             : index == 2?const LinearGradient(colors: [Color(0xFFF3F3F3), Color(0xFFE0E0E0)])
                                  :const LinearGradient(colors: [Color(0xFF3B3B3B), Color(0xFF4A4A4A)]),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0,top: 8,bottom: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                               CustomeText(
                                 text:item[index]['image'] ,
                                 fontSize: 31,
                                 fontWeight: FontWeight.w700,
                                 color:index==3?Colors.white   : Colors.black,
                               ),
                                  Text(
                                    item[index]['first'],
                                    style:  TextStyle(
                                      color:index==3?Colors.white :Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: kPadding,top: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CustomeText(
                        text:'Leads Type' ,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color:Colors.white   ,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.13,
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 8),
                      scrollDirection: Axis.horizontal,
                      itemCount: item1.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(3),
                          child: Container(
                            width: size.width*0.3,
                            decoration: ShapeDecoration(
                              gradient: index == 0
                                  ?  const LinearGradient(colors: [Color(0xFFFF2600), Color(0xFFFF6130)])
                                  : index == 1
                                  ? const LinearGradient(colors: [Color(0xFFFDDC9C), Color(0xFFDDA53B)])
                                  : const LinearGradient(colors: [Color(0xFF3CDCDC), Color(0xFF12BCBC)]),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0,top: 8,bottom: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomeText(
                                    text:item1[index]['image'] ,
                                    fontSize: 31,
                                    fontWeight: FontWeight.w700,
                                    color:Colors.white  ,
                                  ),
                                  Text(
                                    item1[index]['first'],
                                    style:  const TextStyle(
                                      color:Colors.white ,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                   Row(
                    children: [
                      const Expanded(
                        child: CustomTextField(
                          hintText: 'Search',
                          readOnly: true,
                          hintStyle: TextStyle(color: Colors.white),
                          prefixIcon: ImageView(
                            height: 20,
                            width: 20,
                            borderRadiusValue: 0,
                            color: Colors.white,
                            margin: EdgeInsets.only(left: kPadding, right: kPadding),
                            fit: BoxFit.contain,
                            assetImage: AppAssets.searchIcon,
                          ),
                          margin: EdgeInsets.only(
                              left: kPadding,
                              right: kPadding,
                              top: kPadding,
                              bottom: kPadding),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: kPadding),
                        child: Container(
                          decoration: ShapeDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment(0.00, -1.00),
                              end: Alignment(0, 1),
                              colors: [Color(0xFF383838), Color(0xFF282828)],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(21.60),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(13),
                            child: Image.asset(AppAssets.filter,height: size.height*0.04,),
                          ),
                        ),
                      )

                    ],
                  )
                ],
              ),
            ),
          )

      ),
      body:
      ListView.builder(
        itemCount: 10,
        padding: EdgeInsets.only(bottom: size.height*0.13),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: kPadding,right: kPadding),
            child: Container(
              decoration: decoration,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child:
                RowCart(
                  tabIndex: tabIndex,
                  listIndex: index,

                )
              ),
            )
          );
        },),
    );
  }
}
class RowCart extends StatelessWidget {
   int? tabIndex;
   int? listIndex;
  RowCart({
    this.tabIndex,
    this.listIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return tabIndex==0?
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              Image.asset(AppAssets.u1),
              const SizedBox(
                width: 5,
              ),
              CustomeText(
                text: 'Ayaan sha',
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),

          CustomeText(
            text: 'Raipur (C.G.)',
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          InkWell(
            onTap: () {

            },
            child: Container(
              decoration: const BoxDecoration(
                  color: Color(0xFFD9D9D9),
                  shape: BoxShape.circle
              ),
              child: Padding(
                padding: const EdgeInsets.all(1),
                child: ImageView(assetImage: AppAssets.call,height: size.height*0.02,color: Colors.black,),
              ) ,
            ),
          ),
          Icon(Icons.more_vert)
        ],
      ):
    tabIndex==1?
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            Image.asset(AppAssets.u1),
            const SizedBox(
              width: 5,
            ),
            CustomeText(
              text: 'Ayaan sha',
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
        CustomeText(
          text: '12/01/24',
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),

        CustomeText(
          text: '04:30 PM',
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),

        CustomeText(
          text: 'Offline',
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),



        InkWell(
          onTap: () {

          },
          child: Container(
            decoration: ShapeDecoration(
              gradient: const LinearGradient(
                begin: Alignment(0.00, -1.00),
                end: Alignment(0, 1),
                colors: [Color(0xFFF3F3F3), Color(0xFFE0E0E0)],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            child:Padding(
              padding: const EdgeInsets.only(left: 18,right: 18,top: 4,bottom: 4),
              child: CustomeText(
                text: 'Demo',fontWeight: FontWeight.w500,fontSize: 10,
                color: Colors.black,
              ),
            ) ,
          ),
        ),


      ],
    ):tabIndex==2?
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            Image.asset(AppAssets.u1),
            const SizedBox(
              width: 5,
            ),
            CustomeText(
              text: 'Ayaan sha',
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
        CustomeText(
          text: 'Raipur (C.G.)',
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),

        InkWell(
          onTap: () {

          },
          child:
          Container(
            decoration: ShapeDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.61, -0.79),
                end: Alignment(-0.61, 0.79),
                colors: [Color(0xFFFF2600), Color(0xFFFF6130)],
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
                    text: listIndex==5 ||listIndex==4?'Warm':'Hot',fontWeight: FontWeight.w500,fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
            ) ,
          ),
        ),
        Icon(Icons.more_vert)


      ],
    ):tabIndex==3?
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            Image.asset(AppAssets.u1),
            const SizedBox(
              width: 5,
            ),
            CustomeText(
              text: 'Ayaan sha',
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
        CustomeText(
          text: 'Raipur (C.G.)',
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),

        InkWell(
          onTap: () {

          },
          child: Container(
            decoration: ShapeDecoration(
              gradient:  LinearGradient(
                begin: const Alignment(0.61, -0.79),
                end: const Alignment(-0.61, 0.79),
                colors:listIndex==5 ||listIndex==4? [const Color(0xFFFDDC9C), const Color(0xFFDDA53B)]:[ const Color(0xFFFF2600), const Color(0xFFFF6130)],
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
                    text: listIndex==5 ||listIndex==4?'Warm':'Hot',fontWeight: FontWeight.w500,fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
            ) ,
          ),
        ),
        InkWell(
          onTap: () {

          },
          child: Container(
            decoration: ShapeDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.00, -1.00),
                end: Alignment(0, 1),
                colors: [Color(0xFFF3F3F3), Color(0xFFE0E0E0)],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            child:Padding(
              padding: const EdgeInsets.only(left: 18,right: 18,top: 4,bottom: 4),
              child: CustomeText(
                text: 'Close',fontWeight: FontWeight.w500,fontSize: 10,
                color: Colors.black,
              ),
            ) ,
          ),
        ),

      ],
    ):tabIndex==4?
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            Image.asset(AppAssets.u1),
            const SizedBox(
              width: 5,
            ),
            CustomeText(
              text: 'Ayaan sha',
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
        CustomeText(
          text: 'Raipur (C.G.)',
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        const Icon(Icons.more_vert)



      ],
    ):Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            Image.asset(AppAssets.u1),
            const SizedBox(
              width: 5,
            ),
            CustomeText(
              text: 'Ayaan sha',
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
        CustomeText(
          text: 'Raipur (C.G.)',
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),

        InkWell(
          onTap: () {

          },
          child: Container(
            decoration: ShapeDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.00, -1.00),
                end: Alignment(0, 1),
                colors: [Color(0xFFF3F3F3), Color(0xFFE0E0E0)],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            child:Padding(
              padding: const EdgeInsets.only(left: 18,right: 18,top: 4,bottom: 4),
              child: CustomeText(
                text: 'View Profile',fontWeight: FontWeight.w500,fontSize: 10,
                color: Colors.black,
              ),
            ) ,
          ),
        ),

      ],
    )
    ;

  }
}
