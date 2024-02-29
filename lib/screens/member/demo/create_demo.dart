import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import 'package:mrwebbeast/utils/widgets/loading_screen.dart';
import 'package:provider/provider.dart';

import '../../../controllers/member/member_controller/member_controller.dart';
import '../../../core/constant/gradients.dart';
import '../../../models/default/default_model.dart';
import '../../../utils/widgets/custom_back_button.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../../../utils/widgets/widgets.dart';
import '../../guest/guestProfile/guest_edit_profile.dart';
import '../../guest/guestProfile/guest_faq.dart';
import '../events/create_event.dart';

class CreateDemo extends StatefulWidget {
  final String guestId;
  final String? name;
  final String? image;
  final bool? showLeadList;

  const CreateDemo(
      {super.key,
      required this.guestId,
      this.name,
      this.image,
      this.showLeadList});

  @override
  State<CreateDemo> createState() => _CreateDemoState();
}

class _CreateDemoState extends State<CreateDemo> {
  TextEditingController eventNameCtrl = TextEditingController();
  TextEditingController startDateCtrl = TextEditingController();
  TextEditingController startTimeCtrl = TextEditingController();
  TextEditingController commentCtrl = TextEditingController();
  TextEditingController venueCtrl = TextEditingController();
  TextEditingController endDateCtrl = TextEditingController();
  TextEditingController endTimeCtrl = TextEditingController();
  TextEditingController linkCtrl = TextEditingController();
  TextEditingController cityCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  int? tabIndex = 0;
  String typeOfDame = '';
  String guestId = '';
  String priority = '';
  List item = ['Hot', 'Worm', 'Cold'];
  File? image;
  String? sponsorId = '';
  String? memberId = '';
  Set<int> leadIndex = Set<int>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context
          .read<MembersController>()
          .fetchLeads(status: '', priority: '', page: '1');
      await context.read<MembersController>().fetchSponsor(
            context: context,
          );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('check id ${widget.guestId}');
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: const CustomBackButton(),
        title: const Text('Scheduled Demo'),
      ),
      body: ListView(
        padding: EdgeInsets.only(bottom: size.height * 0.13),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: CustomDropdown(
              onChanged: (v) {
                typeOfDame = v;
              },
              title: 'Type of demo*',
              hintText: 'Select type',
              listItem: const ['Business', 'Product'],
            ),
          ),
          AppTextField(
            title: 'Start Date',
            hintText: 'dd-mm-yyyy',
            controller: startDateCtrl,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2101),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      popupMenuTheme: PopupMenuThemeData(
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
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

              if (pickedDate != null) {
                startDateCtrl.text =
                    "${pickedDate.day.toString().padLeft(2, "0")}-${pickedDate.month.toString().padLeft(2, "0")}-${pickedDate.year}";
              }
            },
            readOnly: true,
          ),

          AppTextField(
            title: 'Time',
            hintText: 'hh:mm',
            controller: startTimeCtrl,
            onTap: () async {
              TimeOfDay? time = await showTimePicker(
                context: context,
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      popupMenuTheme: PopupMenuThemeData(
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
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
                initialTime: TimeOfDay.now(),
              );

              if (time != null) {
                startTimeCtrl.text = time.format(context);
              }
            },
            readOnly: true,
          ),
          AppTextField(
            title: 'Venue',
            hintText: 'Enter venue',
            controller: venueCtrl,
          ),
          // AppTextField(
          //   title: 'Remark',
          //   hintText: 'Comment',
          //   controller: commentCtrl,
          // ),
          Padding(
            padding:
                const EdgeInsets.only(left: kPadding, right: kPadding, top: 8),
            child: CustomeText(
              text: 'Select member to add',
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          Consumer<MembersController>(
            builder: (context, controller, child) {
              return Padding(
                padding: const EdgeInsets.only(
                    left: kPadding, right: kPadding, top: 8),
                child: Container(
                  decoration: ShapeDecoration(
                    color: const Color(0xFF1B1B1B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                    ),
                    child: DropdownSearch.multiSelection(
                      dropdownButtonProps: const DropdownButtonProps(
                          padding: EdgeInsets.only(bottom: 10),
                          icon: Icon(
                            CupertinoIcons.chevron_down,
                            size: 18,
                          )),
                      items: controller.fetchSponsorModel?.data
                              ?.map((e) => e.name)
                              .toList() ??
                          [],
                      onChanged: (value) {
                        List id = [];
                        for (var e in value) {
                          id.add(controller.fetchSponsorModel?.data?.firstWhere(
                            (element) {
                              return element.name == e;
                            },
                          ).id);
                        }
                        memberId = id.join('');
                        setState(() {});
                      },
                      popupProps: const PopupPropsMultiSelection.menu(
                        showSearchBox: true,
                        menuProps: MenuProps(
                          backgroundColor: Color(0xFF1B1B1B),
                        ),
                      ),
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                            left: 7,
                            top: 7,
                          ),
                          border: InputBorder.none,
                          hintText: 'Select member',
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: kPadding, right: kPadding, top: 8),
          //   child: CustomeText(
          //     text: 'Lead status',
          //     fontSize: 16,
          //     fontWeight: FontWeight.w400,
          //   ),
          // ),
          //
          // Padding(
          //   padding: const EdgeInsets.only(left: kPadding),
          //   child: SizedBox(
          //     height: size.height * 0.06,
          //     child: Padding(
          //       padding: const EdgeInsets.only(left: 9.0),
          //       child: ListView.builder(
          //         shrinkWrap: true,
          //         scrollDirection: Axis.horizontal,
          //         itemCount: item.length,
          //         itemBuilder: (context, index) {
          //           return Padding(
          //             padding: const EdgeInsets.all(8.0),
          //             child: GestureDetector(
          //               onTap: () {
          //                 priority = item[index];
          //                 tabIndex = index;
          //                 setState(() {});
          //               },
          //               child: Container(
          //                 decoration: BoxDecoration(
          //                     gradient: LinearGradient(
          //                       begin: const Alignment(0.61, -0.79),
          //                       end: const Alignment(-0.61, 0.79),
          //                       colors: index == 0
          //                           ? [const Color(0xFFFF2600), const Color(0xFFFF6130)]
          //                           : index == 1
          //                               ? [const Color(0xFFFDDC9C), const Color(0xFFDDA53B)]
          //                               : [const Color(0xFF3CDCDC), const Color(0xFF12BCBC)],
          //                     ),
          //                     border: tabIndex == index
          //                         ? Border.all(color: CupertinoColors.white, width: 2)
          //                         : null,
          //                     borderRadius: BorderRadius.circular(39)),
          //                 child: SizedBox(
          //                   width: size.width * 0.11,
          //                   child: Center(
          //                     child: Padding(
          //                       padding: const EdgeInsets.only(top: 4, bottom: 4),
          //                       child: CustomeText(
          //                         text: item[index],
          //                         fontWeight: FontWeight.w500,
          //                         fontSize: 10,
          //                         color: Colors.white,
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           );
          //         },
          //       ),
          //     ),
          //   ),
          // ),
          if (widget.showLeadList != true)
            const Padding(
              padding: EdgeInsets.only(left: kPadding, right: kPadding, top: 8),
              child: Row(
                children: [
                  Text(
                    'Select List',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          if (widget.showLeadList != true)
            Padding(
              padding: const EdgeInsets.only(left: kPadding, top: kPadding),
              child: Container(
                width: 30,
                decoration: BoxDecoration(
                  gradient: inActiveGradient,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      ImageView(
                        height: 40,
                        width: 40,
                        borderRadiusValue: 40,
                        isAvatar: true,
                        assetImage: widget.image,
                        margin: const EdgeInsets.only(right: 8),
                      ),
                      Text(widget.name ?? ''),
                    ],
                  ),
                ),
              ),
            ),
          if (widget.showLeadList == true)
            const SizedBox(
              height: 10,
            ),
          if (widget.showLeadList == true)
            const Padding(
              padding: EdgeInsets.only(left: kPadding, right: kPadding, top: 8),
              child: Row(
                children: [
                  Text(
                    'Select Members to add',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          if (widget.showLeadList == true)
            Consumer<MembersController>(
              builder: (context, controller, child) {
                return controller.leadsLoader == false
                    ? const LoadingScreen()
                    : Padding(
                        padding: const EdgeInsets.only(
                            left: kPadding, right: kPadding, top: 8),
                        child: Wrap(
                            children: List.generate(
                          controller.fetchLeadsModel?.data?.length ?? 0 ?? 0,
                          (index) {
                            bool isSelected = leadIndex.contains(index);
                            return GestureDetector(
                              onTap: () {
                                if (isSelected) {
                                  leadIndex.remove(index);
                                } else {
                                  leadIndex.add(index);
                                }
                                guestId = leadIndex.join(',');
                                setState(() {});
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                    right: kPadding, top: kPadding),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  gradient: isSelected
                                      ? primaryGradient
                                      : inActiveGradient,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ImageView(
                                      height: 40,
                                      width: 40,
                                      borderRadiusValue: 40,
                                      isAvatar: true,
                                      networkImage: controller.fetchLeadsModel
                                              ?.data?[index].profilePhoto ??
                                          '',
                                      // assetImage: AppAssets.appIcon,
                                      margin: const EdgeInsets.only(right: 8),
                                    ),
                                    Text(controller.fetchLeadsModel
                                            ?.data?[index].firstName ??
                                        ''),
                                  ],
                                ),
                              ),
                            );
                          },
                        )),
                      );
              },
            ),
          // Consumer<MembersController>(
          // builder: (context, controller, child) {
          //   return   Container(
          //     height: 55,
          //     margin: const EdgeInsets.only(
          //         top: kPadding, bottom: kPadding, left: kPadding),
          //     child:controller.leadsLoader==false?const LoadingScreen()
          //         :
          //     // GridView.count(
          //     //     crossAxisCount: 3,
          //     //     crossAxisSpacing: 4.0,
          //     //
          //     //     children: List.generate(
          //     //         controller.fetchLeadsModel?.data?.length??0, (index) {
          //     //       bool isSelected = leadIndex.contains(index);
          //     //       return Padding(
          //     //         padding: const EdgeInsets.all(8.0),
          //     //         child: GestureDetector(
          //     //           onTap: () {
          //     //
          //     //             if (isSelected) {
          //     //
          //     //               leadIndex.remove(index);
          //     //             } else {
          //     //               leadIndex.add(index);
          //     //             }
          //     //             guestId =leadIndex.join(',');
          //     //             setState(() {});
          //     //           },
          //     //           child: Container(
          //     //             // width: 120,
          //     //             margin: const EdgeInsets.only(right: kPadding),
          //     //             padding: const EdgeInsets.symmetric(horizontal: 8),
          //     //             decoration: BoxDecoration(
          //     //               gradient:isSelected ?primaryGradient :inActiveGradient,
          //     //               borderRadius: BorderRadius.circular(50),
          //     //             ),
          //     //             child:  Row(
          //     //               children: [
          //     //                 const ImageView(
          //     //                   height: 40,
          //     //                   width: 40,
          //     //                   borderRadiusValue: 40,
          //     //                   isAvatar: true,
          //     //                   assetImage: AppAssets.appIcon,
          //     //                   margin: EdgeInsets.only(right: 8),
          //     //                 ),
          //     //                 CustomeText(
          //     //                   text:controller.fetchLeadsModel?.data?[index].firstName??'' ,
          //     //                   color: isSelected? Colors.black:Colors.white,
          //     //                 )
          //     //
          //     //               ],
          //     //             ),
          //     //           ),
          //     //         ),
          //     //       );
          //     //     }
          //     //     )
          //     // )
          //     ListView.builder(
          //       itemCount: controller.fetchLeadsModel?.data?.length??0,
          //       shrinkWrap: true,
          //       scrollDirection: Axis.horizontal,
          //       itemBuilder: (context, index) {
          //         bool isSelected = leadIndex.contains(index);
          //         return
          //           GestureDetector(
          //             onTap: () {
          //
          //               if (isSelected) {
          //
          //                 leadIndex.remove(index);
          //               } else {
          //
          //                 leadIndex.add(index);
          //               }
          //               guestId =leadIndex.join(',');
          //               setState(() {});
          //             },
          //             child: Container(
          //               width: 120,
          //               margin: const EdgeInsets.only(right: kPadding),
          //               padding: const EdgeInsets.symmetric(horizontal: 8),
          //               decoration: BoxDecoration(
          //                 gradient:isSelected ?primaryGradient :inActiveGradient,
          //                 borderRadius: BorderRadius.circular(50),
          //               ),
          //               child:  Row(
          //                 children: [
          //                   const ImageView(
          //                     height: 40,
          //                     width: 40,
          //                     borderRadiusValue: 40,
          //                     isAvatar: true,
          //                     assetImage: AppAssets.appIcon,
          //                     margin: EdgeInsets.only(right: 8),
          //                   ),
          //                   CustomeText(
          //                     text:controller.fetchLeadsModel?.data?[index].firstName??'' ,
          //                     color: isSelected? Colors.black:Colors.white,
          //                   )
          //
          //                 ],
          //               ),
          //             ),
          //           );
          //       },
          //     ),
          //   );
          // },
          //
          // ),

          // const Row(
          //   children: [
          //     Flexible(
          //       child: CustomTextField(
          //         hintText: 'Search',
          //         hintStyle: TextStyle(color: Colors.white),
          //         prefixIcon: ImageView(
          //           height: 20,
          //           width: 20,
          //           borderRadiusValue: 0,
          //           color: Colors.white,
          //           margin: EdgeInsets.only(left: kPadding, right: kPadding),
          //           fit: BoxFit.contain,
          //           assetImage: AppAssets.searchIcon,
          //         ),
          //         margin: EdgeInsets.only(
          //             left: kPadding,
          //             right: kPadding,
          //             top: kPadding,
          //             bottom: kPadding),
          //       ),
          //     ),
          //     // GradientButton(
          //     //   height: 60,
          //     //   width: 60,
          //     //   margin: const EdgeInsets.only(left: 8, right: kPadding),
          //     //   backgroundGradient: blackGradient,
          //     //   child: const ImageView(
          //     //     height: 28,
          //     //     width: 28,
          //     //     assetImage: AppAssets.filterIcons,
          //     //     margin: EdgeInsets.zero,
          //     //   ),
          //     // )
          //   ],
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: kPadding),
          //   child:
          //   Wrap(
          //     children: List.generate(
          //       10,
          //       (index) {
          //         return Container(
          //           margin:
          //               const EdgeInsets.only(right: kPadding, top: kPadding),
          //           padding:
          //               const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          //           decoration: BoxDecoration(
          //             gradient: inActiveGradient,
          //             borderRadius: BorderRadius.circular(50),
          //           ),
          //           child: const Row(
          //             mainAxisSize: MainAxisSize.min,
          //             children: [
          //               ImageView(
          //                 height: 40,
          //                 width: 40,
          //                 borderRadiusValue: 40,
          //                 isAvatar: true,
          //                 assetImage: AppAssets.appIcon,
          //                 margin: EdgeInsets.only(right: 8),
          //               ),
          //               Text('Ayaan'),
          //             ],
          //           ),
          //         );
          //       },
          //     ),
          //   ),
          // ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GradientButton(
            height: 70,
            borderRadius: 18,
            backgroundGradient: primaryGradient,
            backgroundColor: Colors.transparent,
            boxShadow: const [],
            margin: const EdgeInsets.only(
                left: kPadding, right: kPadding, bottom: kPadding),
            onTap: () async {
              DefaultModel? model =   await context.read<MembersController>().scheduledDemo(
                  context: context,
                  guestId: guestId.isEmpty == true ? widget.guestId : guestId,
                  demoType: typeOfDame,
                  date: startDateCtrl.text,
                  time: startTimeCtrl.text,
                  remarks: commentCtrl.text,
                  priority: priority,
                  venue: venueCtrl.text,
                  memberIds: memberId);
              if(model?.status ==true){
                await context.read<MembersController>().fetchLeads(
                    status: 'Invitation Call', priority: '', page: '1');
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
    );
  }

  Future<void> updateProfileImage({required ImageSource source}) async {
    final pickedImg = await ImagePicker().pickImage(source: source);
    setState(() {
      if (pickedImg != null) {
        image = File(pickedImg.path);
      }
    });
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Future addImages() async {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(24),
                topLeft: Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Change Image',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        updateProfileImage(source: ImageSource.camera);
                      },
                      child: pickImageButton(
                        context: context,
                        text: 'Camera',
                        icon: Icons.camera,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        updateProfileImage(source: ImageSource.gallery);
                      },
                      child: pickImageButton(
                        context: context,
                        text: 'Gallery',
                        icon: Icons.photo,
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }
}

class AppTextField extends StatelessWidget {
  final String? title;
  final void Function()? onTap;
  final String? hintText;
  final bool? readOnly;
  final Widget? prefixIcon;
  final double? height;
  final int? minLines;
  final int? maxLines;

  final TextEditingController? controller;
  final EdgeInsets? padding;

  const AppTextField({
    this.title,
    this.hintText,
    this.onTap,
    this.controller,
    this.prefixIcon,
    this.height,
    this.readOnly,
    super.key,
    this.minLines,
    this.maxLines,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: padding ??
          const EdgeInsets.symmetric(horizontal: kPadding, vertical: 10),
      child: Container(
        decoration: ShapeDecoration(
          color: const Color(0xFF1B1B1B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: kPadding, top: 12),
              child: Text(
                title ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            CustomTextField(
              readOnly: readOnly,
              onTap: onTap,

              controller: controller,
              prefixIcon: prefixIcon,
              minLines: minLines,
              maxLines: maxLines,
              hintStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              contentPadding: const EdgeInsets.only(left: 1),
              autofocus: true,
              isDense: true,
              margin: const EdgeInsets.only(
                  left: kPadding, right: kPadding, top: 8, bottom: 12),
              hintText: hintText,
              // margin: const EdgeInsets.only(bottom: 18),
            ),
          ],
        ),
      ),
    );
  }
}

// class CustomDropdown extends StatelessWidget {
//   final String? title;
//   final String? hintText;
//   final List<String>? listItem;
//   final TextEditingController? controller;
//
//   const CustomDropdown({
//     this.title,
//     this.hintText,
//     this.listItem,
//     this.controller,
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Padding(
//       padding: const EdgeInsets.all(9),
//       child: Container(
//         decoration: ShapeDecoration(
//           color: const Color(0xFF1B1B1B),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: kPadding, top: 7),
//               child: Text(
//                 title ?? '',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 10,
//                   fontWeight: FontWeight.w400,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 8.0),
//               child: DropdownSearch<String>(
//                 dropdownButtonProps: const DropdownButtonProps(
//                     padding: EdgeInsets.only(bottom: 10),
//                     icon: Icon(
//                       CupertinoIcons.chevron_down,
//                       size: 18,
//                     )),
//                 popupProps: PopupProps.menu(
//                   menuProps: const MenuProps(
//                     backgroundColor: Color(0xFF1B1B1B),
//                   ),
//                   fit: FlexFit.loose,
//                   showSelectedItems: true,
//                   disabledItemFn: (String s) => s.startsWith('p'),
//                 ),
//                 items: listItem ?? [],
//                 dropdownDecoratorProps: DropDownDecoratorProps(
//                   dropdownSearchDecoration: InputDecoration(
//                     contentPadding: const EdgeInsets.only(left: 7, top: 7),
//                     border: InputBorder.none,
//                     hintText: hintText ?? 'Select Gender',
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
