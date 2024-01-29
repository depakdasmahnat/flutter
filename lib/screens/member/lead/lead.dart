import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controllers/member/member_controller/member_controller.dart';
import '../../../core/config/app_assets.dart';
import '../../../core/constant/constant.dart';
import '../../../core/route/route_paths.dart';
import '../../../utils/widgets/appbar.dart';
import '../../../utils/widgets/custom_back_button.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/image_view.dart';
import '../../guest/guestProfile/guest_faq.dart';
import '../demo/create_demo.dart';
import 'model_dailog_box.dart';

class Lead extends StatefulWidget {
  const Lead({super.key});

  @override
  State<Lead> createState() => _LeadState();
}

class _LeadState extends State<Lead> {
  int tabIndex = 0;

  List tabItem = [
    'New Listed',
    'Invitation call',
    'Demo Scheduled',
    'Follow Up',
    'Closing'
  ];
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
      'image': '04',
      'first': 'Demo\nScheduled',
      'second': 'Payment Meth…',
      'gradiant': null,
      'color': Colors.white,
    },
    {
      'image': '04',
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
      'image': '09',
      'first': 'Cold Leads',
      'second': 'Payment Meth…',
      'gradiant': null,
      'color': Colors.white,
    },
  ];
  String status ='';
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context
          .read<MembersController>()
          .fetchLeads(status: '', priority: '', page: '1');
    });
    super.initState();
  }
  void _showPopupMenu() async {

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<MembersController>(
      builder: (context, controller, child) {
        return Scaffold(
          appBar: controller.leadsLoader == false
              ? PreferredSize(
                  preferredSize: Size.fromHeight(size.height * 0.54),
                  child: const Center(
                    child: CupertinoActivityIndicator(
                        radius: 15, color: CupertinoColors.white),
                  ),
                )
              : PreferredSize(
                  preferredSize: Size.fromHeight(size.height * 0.54),
                  child: CustomAppBar(
                    showLeadICon: false,
                    title: 'List',
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(size.height * 0.5),
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
                                  colors: [
                                    Color(0xFF3B3B3B),
                                    Color(0xFF4A4A4A)
                                  ],
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Center(
                                child: SizedBox(
                                  height: size.height * 0.07,
                                  child: ListView.builder(
                                    itemCount: tabItem.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () async{
                                          tabIndex = index;
                                          status    =tabItem[index];
                                          await context
                                              .read<MembersController>()
                                              .fetchLeads(status: status, priority: '', page: '1');
                                          setState(() {});
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: size.width * 0.3,
                                            height: size.width * 0.06,
                                            decoration: ShapeDecoration(
                                              gradient: index == tabIndex
                                                  ? primaryGradient
                                                  : null,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: Center(
                                                child: CustomeText(
                                              text: tabItem[index],
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: index == tabIndex
                                                  ? Colors.black
                                                  : Colors.white,
                                            )),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(left:kPadding,top: 8),
                            child: SizedBox(
                                height: size.height * 0.13,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    physics: const NeverScrollableScrollPhysics(),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(3),
                                        child: Container(
                                          width: size.width * 0.22,
                                          decoration: ShapeDecoration(
                                            gradient: primaryGradient,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, top: 8, bottom: 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CustomeText(
                                                  text:
                                                      '${controller.fetchLeadsModel?.stats?.new1}',
                                                  fontSize: 31,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                ),
                                                const Text(
                                                  'Leads\nAdded',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(3),
                                        child: Container(
                                          width: size.width * 0.22,
                                          decoration: ShapeDecoration(
                                            gradient: const LinearGradient(colors: [
                                              Color(0xFFF3F3F3),
                                              Color(0xFFE0E0E0)
                                            ]),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, top: 8, bottom: 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CustomeText(
                                                  text: '${controller.fetchLeadsModel?.stats?.invitationCall}',
                                                  fontSize: 31,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                ),
                                                const Text(
                                                  'Demo\nScheduled',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(3),
                                        child: Container(
                                          width: size.width * 0.22,
                                          decoration: ShapeDecoration(
                                            gradient: const LinearGradient(colors: [
                                              Color(0xFFF3F3F3),
                                              Color(0xFFE0E0E0)
                                            ]),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, top: 8, bottom: 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CustomeText(
                                                  text: '${controller.fetchLeadsModel?.stats?.followup}',
                                                  fontSize: 31,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                ),
                                                const Text(
                                                  'Demo\nDone',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(3),
                                        child: Container(
                                          width: size.width * 0.22,
                                          decoration: ShapeDecoration(
                                            gradient: const LinearGradient(colors: [
                                              Color(0xFF3B3B3B),
                                              Color(0xFF4A4A4A)
                                            ]),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, top: 8, bottom: 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CustomeText(
                                                  text: '${controller.fetchLeadsModel?.stats?.closed}',
                                                  fontSize: 31,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                                const Text(
                                                  'Leads\nClosed',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: kPadding, top: 8),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: CustomeText(
                                text: 'Leads Type',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:kPadding,top: 8),
                            child: SizedBox(
                                height: size.height * 0.13,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: Container(
                                        width: size.width * 0.3,
                                        decoration: ShapeDecoration(
                                          gradient: const LinearGradient(colors: [
                                            Color(0xFFFF2600),
                                            Color(0xFFFF6130)
                                          ]),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, top: 8, bottom: 8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CustomeText(
                                                text: '${controller.fetchLeadsModel?.stats?.hot}',
                                                fontSize: 31,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                              const Text(
                                                'Hot Leads',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: Container(
                                        width: size.width * 0.3,
                                        decoration: ShapeDecoration(
                                          gradient: const LinearGradient(colors: [
                                            Color(0xFFFDDC9C),
                                            Color(0xFFDDA53B)
                                          ]),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, top: 8, bottom: 8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CustomeText(
                                                text: '${controller.fetchLeadsModel?.stats?.warm}',
                                                fontSize: 31,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                              const Text(
                                                'Warn Leads',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: Container(
                                        width: size.width * 0.3,
                                        decoration: ShapeDecoration(
                                          gradient: const LinearGradient(colors: [
                                            Color(0xFF3CDCDC),
                                            Color(0xFF12BCBC)
                                          ]),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, top: 8, bottom: 8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CustomeText(
                                                text: '${controller.fetchLeadsModel?.stats?.cold}',
                                                fontSize: 31,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                              const Text(
                                                'Cold Leads',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
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
                                    margin: EdgeInsets.only(
                                        left: kPadding, right: kPadding),
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
                                child: GestureDetector(
                                  onTap:() async{

                                  },
                                  child: Container(
                                    decoration: ShapeDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment(0.00, -1.00),
                                        end: Alignment(0, 1),
                                        colors: [
                                          Color(0xFF383838),
                                          Color(0xFF282828)
                                        ],
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(21.60),
                                      ),
                                    ),
                                    child:
                                    PopupMenuButton(
                                      child: Padding(
                                        padding: const EdgeInsets.all(13),
                                        child: Image.asset(AppAssets.filter,height: size.height*0.04,),
                                      ),
                                      onSelected: (value) async{
                                        await context
                                            .read<MembersController>()
                                            .fetchLeads(status: status, priority: value, page: '1');
                                      },
                                      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                                        const PopupMenuItem(
                                          value: 'Newest',
                                          child: Text('Newest'),
                                        ),
                                        const PopupMenuItem(
                                          value: 'Oldest',
                                          child: Text('Oldest'),
                                        ),
                                        const PopupMenuItem(
                                          value: 'Today',
                                          child: Text('Today'),
                                        ), const PopupMenuItem(
                                          value: 'Hot',
                                          child: Text('Hot'),
                                        ),const PopupMenuItem(
                                          value: 'Cold',
                                          child: Text('Cold'),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )),
          body: ListView.builder(
            itemCount: controller.fetchLeadsModel?.data?.length??0,
            padding: EdgeInsets.only(bottom: size.height * 0.13),
            itemBuilder: (context, index) {
              return Padding(
                  padding:
                      const EdgeInsets.only(left: kPadding, right: kPadding),
                  child: Container(
                    decoration: decoration,
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: RowCart(
                          tabIndex: tabIndex,
                          listIndex: index,
                          guestId:controller.fetchLeadsModel?.data?[index].id.toString()  ,
                          image:controller.fetchLeadsModel?.data?[index].profilePhoto ,
                          name: controller.fetchLeadsModel?.data?[index].firstName,
                          city: controller.fetchLeadsModel?.data?[index].cityName,
                          phone: controller.fetchLeadsModel?.data?[index].mobile,
                          date:controller.fetchLeadsModel?.data?[index].demoDate ,
                          time:controller.fetchLeadsModel?.data?[index].demoTime  ,
                          priority:controller.fetchLeadsModel?.data?[index].priority ,
                        )),
                  ));
            },
          ),
        );
      },
    );
  }
}

class RowCart extends StatelessWidget {
  int? tabIndex;
  int? listIndex;
  String? guestId;
  String? image;
  String? name;
  String? city;
  String? phone;
  String? date;
  String? time;
  String? priority;
  RowCart({
    this.tabIndex,
    this.listIndex,
    this.guestId,
    this.image,
    this.name,
    this.city,
    this.phone,
    this.date,
    this.time,
    this.priority,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List item =['Hot','Worm','Cold'];
    Size size = MediaQuery.of(context).size;

    return tabIndex == 0
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  image==null? Image.asset(AppAssets.u1): Image.network(image??'',height: size.height*0.04,),
                  const SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                    width: size.width*0.12,
                    child: CustomeText(
                      text: name??'',
                      maxLines: 1,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              CustomeText(
                text: city??'',
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              Container(
                decoration: const BoxDecoration(
                    color: Color(0xFFD9D9D9), shape: BoxShape.circle),
                child: GestureDetector(
                   onTap: () async{
                     await context.read<MembersController>().callUser(
                       mobileNo: phone
                     );
                   },
                  child: Padding(
                    padding: const EdgeInsets.all(1),
                    child: ImageView(
                      assetImage: AppAssets.call,
                      height: size.height * 0.02,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              PopupMenuButton(
                // clipBehavior: Clip.antiAlias,
                onSelected: (value) async{
                  print('check menu ${guestId}');
               await   showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => ModelDialogBox(guestId:guestId??'' ,status: 'Invitation Call',)
                  );
                 // await context.pushNamed(Routs.modelDialogBox,extra: ModelDialogBox(guestId: '1',));

                },

                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  const PopupMenuItem(
                    value: 'Interested',
                    child: Text('Interested'),
                  ),
                  const PopupMenuItem(
                    value: 'Not confirm',
                    child: Text('Not confirm'),
                  ),
                ],
                child: const Icon(Icons.more_vert),
              ),

            ],
          )
        : tabIndex == 1
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      // image==null?
                      // Image.asset(AppAssets.u1):Image.network(image??'',height: size.height*0.04,width:size.width*0.04 ,),
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: size.width*0.12,
                        child: CustomeText(
                          text: name??'',
                           maxLines: 1,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  CustomeText(
                    text: date??'',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  CustomeText(
                    text: time??'',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  CustomeText(
                    text: 'Offline',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  GestureDetector(
                    onTap: () {
                      context.pushNamed(Routs.createDemo,extra: CreateDemo(guestId: guestId??'',));
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
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 18, right: 18, top: 4, bottom: 4),
                        child: CustomeText(
                          text: 'Demo',
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : tabIndex == 2
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          image==null?
                          Image.asset(AppAssets.u1):Image.network(image??''),
                          const SizedBox(
                            width: 5,
                          ),
                          CustomeText(
                            text:name??'',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      CustomeText(
                        text: city??'',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          decoration: ShapeDecoration(
                            gradient:  LinearGradient(
                              begin: const Alignment(0.61, -0.79),
                              end: const Alignment(-0.61, 0.79),
                              colors:priority=='Hot'? [const Color(0xFFFF2600), const Color(0xFFFF6130)]:
                              priority=='Warm'?
                              [const Color(0xFFFDDC9C), const Color(0xFFDDA53B)]:[const Color(0xFF3CDCDC), const Color(0xFF12BCBC)],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(39),
                            ),
                          ),
                          child: SizedBox(
                            width: size.width * 0.11,
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 4),
                                child: CustomeText(
                                  text: priority??'',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Icon(Icons.more_vert)
                    ],
                  )
                : tabIndex == 3
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              image==null?
                              Image.asset(AppAssets.u1):Image.network(image??''),
                              const SizedBox(
                                width: 5,
                              ),
                              CustomeText(
                                text:name??'',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                          CustomeText(
                            text: city??'',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          InkWell(
                            onTap: () {},
                            child: Container(
                              decoration: ShapeDecoration(
                                gradient: LinearGradient(
                                  begin: const Alignment(0.61, -0.79),
                                  end: const Alignment(-0.61, 0.79),
                                  colors:priority=='Warm'? [
                                          const Color(0xFFFDDC9C),
                                          const Color(0xFFDDA53B)
                                        ]
                                      :priority=='Hot'? [
                                          const Color(0xFFFF2600),
                                          const Color(0xFFFF6130)
                                        ]:[const Color(0xFF3CDCDC), const Color(0xFF12BCBC)],
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(39),
                                ),
                              ),
                              child: SizedBox(
                                width: size.width * 0.11,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4, bottom: 4),
                                    child: CustomeText(
                                      text: priority??'',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: Container(
                              decoration: ShapeDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment(0.00, -1.00),
                                  end: Alignment(0, 1),
                                  colors: [
                                    Color(0xFFF3F3F3),
                                    Color(0xFFE0E0E0)
                                  ],
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 18, right: 18, top: 4, bottom: 4),
                                child: CustomeText(
                                  text: 'Close',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : tabIndex == 4
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  image==null?
                                  Image.asset(AppAssets.u1):Image.network(image??''),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  CustomeText(
                                    text: name??'',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                              CustomeText(
                                text: city??"",
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              const Icon(Icons.more_vert)
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  image==null?
                                  Image.asset(AppAssets.u1):Image.network(image??''),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  CustomeText(
                                    text: name??'',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                              CustomeText(
                                text:city??"",
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  decoration: ShapeDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment(0.00, -1.00),
                                      end: Alignment(0, 1),
                                      colors: [
                                        Color(0xFFF3F3F3),
                                        Color(0xFFE0E0E0)
                                      ],
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 18, right: 18, top: 4, bottom: 4),
                                    child: CustomeText(
                                      text: 'View Profile',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
  }
}
