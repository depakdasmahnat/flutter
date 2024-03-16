import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';

import 'package:provider/provider.dart';

import '../../../controllers/member/member_controller/member_controller.dart';
import '../../../core/constant/gradients.dart';
import '../../../utils/widgets/custom_back_button.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../../../utils/widgets/widgets.dart';
import '../../guest/guestProfile/guest_edit_profile.dart';
import '../../guest/guestProfile/guest_faq.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  DateTime endDateValidation=DateTime.now();
  bool hideContainer = false;
  String eventType = '';
  String eventMode = '';
  String memberIds = '';
  String members = '';
  String teamMeeting = '';
  TextEditingController eventNameCtrl = TextEditingController();
  TextEditingController startDateCtrl = TextEditingController();
  TextEditingController startTimeCtrl = TextEditingController();

  TextEditingController endDateCtrl = TextEditingController();
  TextEditingController endTimeCtrl = TextEditingController();

  TextEditingController linkCtrl = TextEditingController();
  TextEditingController cityCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
// Set<int> leadIndex = Set<int>();
  Set<int> leadIndex = <int>{};
  File? image;
  String eventModeHint = 'Select Event Type';
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<MembersController>().fetchSponsor(
            context: context,
          );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: const CustomBackButton(),
        title: const Text('Create Event'),
      ),
      body: ListView(
        padding: EdgeInsets.only(bottom: size.height * 0.13),
        children: [
          AppTextField(
            controller: eventNameCtrl,
            title: 'Event name',
            hintText: 'Enter Event name',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: CustomDropdown(

              onChanged: (v) {
                eventType = v;
                eventMode = '';
                hideContainer = false;
                if (eventType == 'Seminar') {
                  eventModeHint = 'Offline';
                  eventMode = 'Offline';
                  hideContainer = true;
                }
                if (eventType == 'Webinar') {
                  eventModeHint = 'Online';
                  eventMode = 'Online';
                  hideContainer = true;
                }
                setState(() {});
              },
              title: 'Event Type*',
              hintText: 'Select Event Type',
              listItem: const [
                'Event',
                'Seminar',
                'Webinar',
                'Meeting',
                'Down Line Meeting'
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),

            child: IgnorePointer(
              ignoring: hideContainer,
              child: CustomDropdown(

                onChanged: (v) {
                  eventMode = v;
                  setState(() {});
                },
                title: 'Event Mode*',
                hintText: eventModeHint,
                listItem: const ['Online', 'Offline'],
              ),
            ),
          ),
          if (eventMode == 'Online' || eventMode == 'Webinar')
            AppTextField(
              controller: linkCtrl,
              title: 'Link Paste',
              hintText: 'Paste Link',
            ),
          if (eventMode == 'Offline')
            AppTextField(
              controller: cityCtrl,
              title: 'Location',
              hintText: 'Enter Location',
            ),
          if (eventType == 'Meeting')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: CustomDropdown(

                onChanged: (v) {
                  members = v;
                  setState(() {});
                },
                title: 'Meeting Type',
                hintText: 'Select Meeting Type',
                listItem: const ['One Two One', 'Team Meeting'],
              ),
            ),
          if (members == 'One Two One')
            Consumer<MembersController>(
              builder: (context, controller, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: CustomDropdown(
// showSearchBox: true,

                    onChanged: (v) {
                      teamMeeting = controller.fetchSponsorModel?.data
                              ?.firstWhere(
                                (element) {
                                  return element.name == v;
                                },
                              )
                              .id
                              .toString() ??
                          '';
                      setState(() {});
                    },
                    title: 'Members',
                    hintText: 'Select Members',
                    listItem: controller.fetchSponsorModel?.data
                        ?.map((e) => e.name)
                        .toList(),
                  ),
                );
              },
            ),
          if (members == 'Team Meeting')
            Consumer<MembersController>(
              builder: (context, controller, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Container(
                    decoration: ShapeDecoration(
                      color: const Color(0xFF1B1B1B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: kPadding, top: 7),
                          child: Text(
                            'Members',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
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
                                id.add(controller.fetchSponsorModel?.data
                                    ?.firstWhere(
                                  (element) {
                                    return element.name == e;
                                  },
                                ).id);
                              }
                              teamMeeting = id.join('');
                              setState(() {});
                            },
                            popupProps: const PopupPropsMultiSelection.menu(
                              showSearchBox: true,
                              menuProps: MenuProps(
                                backgroundColor: Color(0xFF1B1B1B),
                              ),
                            ),
                            dropdownDecoratorProps:
                                const DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                  left: 7,
                                  top: 7,
                                ),
                                border: InputBorder.none,
                                hintText: 'Select Gender',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          if (eventType == 'Down Line Meeting')
            AppTextField(
              title: 'Down line',
              hintText: 'All Down Line Member',
              controller: startDateCtrl,
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: kPadding, right: kPadding),
              readOnly: true,
            ),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  title: 'Start Date',
                  hintText: 'dd-mm-yyyy',
                  controller: startDateCtrl,
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, left: kPadding, right: kPadding),
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


                            inputDecorationTheme: const InputDecorationTheme(

                                ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (pickedDate != null) {
                      endDateValidation =pickedDate;
                      startDateCtrl.text = "${pickedDate.day.toString().padLeft(2, "0")}-${pickedDate.month.toString().padLeft(2, "0")}-${pickedDate.year}";
                      setState(() {});
                    }
                  },
                  readOnly: true,
                ),
              ),
              Expanded(
                child: AppTextField(
                  title: 'Start Time',
                  hintText: 'hh:mm',
                  controller: startTimeCtrl,
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, right: kPadding),
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


                            inputDecorationTheme: const InputDecorationTheme(

                                ),
                          ),
                          child: child!,
                        );
                      },
                      initialTime: TimeOfDay.now(),
                    );

                    if (time != null) {
                      startTimeCtrl.text = '${time.hour}:${time.minute}';
                    }
                  },
                  readOnly: true,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  title: 'End Date',
                  hintText: 'dd-mm-yyyy',
                  controller: endDateCtrl,
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, left: kPadding, right: kPadding),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: endDateValidation,
                      firstDate: endDateValidation,
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


                            inputDecorationTheme: const InputDecorationTheme(
 // Input label
                                ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (pickedDate != null) {
                      endDateCtrl.text =
                          // "${pickedDate.day.toString().padLeft(2, "0")}/${pickedDate.month.toString().padLeft(2, "0")}/${pickedDate.year}";
                      "${pickedDate.day.toString().padLeft(2, "0")}-${pickedDate.month.toString().padLeft(2, "0")}-${pickedDate.year}";
                    }
                  },
                  readOnly: true,
                ),
              ),
              Expanded(
                child: AppTextField(
                  title: 'End Time',
                  hintText: 'hh:mm',
                  controller: endTimeCtrl,
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, right: kPadding),
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
                            inputDecorationTheme: const InputDecorationTheme(),
                          ),
                          child: child!,
                        );
                      },
                      initialTime: TimeOfDay.now(),
                    );

                    if (time != null) {
                      endTimeCtrl.text = '${time.hour}:${time.minute}';
                    }
                  },
                  readOnly: true,
                ),
              ),
            ],
          ),

          AppTextField(
            controller: descriptionCtrl,
            title: 'Description',
            hintText: 'Enter Description',
            minLines: 4,
            maxLines: 6,
          ),
          Padding(
            padding: const EdgeInsets.all(kPadding),
            child: GestureDetector(
              onTap: () {
                addImages();
              },
              child: DottedBorder(
                dashPattern: const [4, 4],
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                color: Colors.grey,
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: kPadding, vertical: 24),
                    color: Colors.transparent,
                    child: image == null
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  ImageView(
                                    height: 50,
                                    margin: EdgeInsets.only(bottom: 8),
                                  ),
                                  Text(
                                    'Drop your image here, or browse',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Supports: PNG, JPG',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : ImageView(
                            file: File(image?.path ?? ''),
                            fit: BoxFit.cover,
                          )),
              ),
            ),
          ),

          Padding(
            padding:
            const EdgeInsets.only(left: kPadding, right: kPadding, top: 8),
            child: CustomeText(
              text: 'Select Members to add',
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
                        memberIds = id.join('');
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

//           Padding(
//             padding: const EdgeInsets.only(left: kPadding),
//             child: Consumer<MembersController>(
//               builder: (context, controller, child) {
//                 return controller.sponsorLoader == false
//                     ? const LoadingScreen()
//                     : Wrap(
//                         children: List.generate(
//                         controller.fetchSponsorModel?.data?.length ?? 0,
//                         (index) {
//                           bool isSelected = leadIndex.contains(index);
//                           return GestureDetector(
//                             onTap: () {
//                               if (isSelected) {
//                                 leadIndex.remove(index);
//                               } else {
//                                 leadIndex.add(index);
//                               }
//                               memberIds = leadIndex.join(',');
//                               setState(() {});
//                             },
//                             child: Container(
//                               margin: const EdgeInsets.only(
//                                   right: kPadding, top: kPadding),
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 8),
//                               decoration: BoxDecoration(
//                                 gradient: isSelected
//                                     ? primaryGradient
//                                     : inActiveGradient,
//                                 borderRadius: BorderRadius.circular(50),
//                               ),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   ImageView(
//                                     height: 40,
//                                     width: 40,
//                                     borderRadiusValue: 40,
//                                     isAvatar: true,
// // networkImage: controller.fetchSponsorModel?.data?[index].profilePhoto??'',
//                                     assetImage: AppAssets.appIcon,
//                                     margin: const EdgeInsets.only(right: 8),
//                                   ),
//                                   Text(controller.fetchSponsorModel
//                                           ?.data?[index].name ??
//                                       ''),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ));
//               },
//             ),
//           ),
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
            onTap: ()async {
            await  context.read<MembersController>().createEvent(
                    context: context,
                    name: eventNameCtrl.text,
                    eventType: eventType,
                    meetingLink: linkCtrl.text,
                    city: cityCtrl.text,
                    description: descriptionCtrl.text,
                    startDate: startDateCtrl.text,
                    startTime: startTimeCtrl.text,
                    endDate: endDateCtrl.text,
                    endTime: endTimeCtrl.text,
                    memberIds: teamMeeting,
                    file: XFile(image?.path ?? ''),
                    mode: eventMode,
                    meetingType: members,
                  );

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
        setState(() {});
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
