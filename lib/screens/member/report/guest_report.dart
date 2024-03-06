import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/controllers/member/filter_controller.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/screens/member/network/pinnacle_list_table.dart';
import 'package:mrwebbeast/screens/member/report/partner_report_table.dart';
import 'package:mrwebbeast/screens/member/report/report_label_picker.dart';
import 'package:mrwebbeast/utils/widgets/custom_text_field.dart';
import 'package:mrwebbeast/utils/widgets/gradient_button.dart';
import 'package:mrwebbeast/utils/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../../../controllers/member/member_controller/member_controller.dart';
import '../../../controllers/member/network/network_controller.dart';
import '../../../core/config/app_assets.dart';
import '../../../core/constant/constant.dart';
import '../../../models/member/filter/filter_model.dart';
import '../../../models/member/network/pinnacle_list_model.dart';
import '../../../models/member/occupation/fetchOccupationModel.dart';
import '../../../models/member/report/guest_lead_report.dart';
import '../../../models/member/report/partner_report_model.dart';
import '../../../utils/widgets/custom_bottom_sheet.dart';
import '../../../utils/widgets/image_view.dart';
import '../../../utils/widgets/loading_screen.dart';
import '../../../utils/widgets/multi_filter_picker.dart';
import '../../../utils/widgets/no_data_found.dart';
import '../../../utils/widgets/option_picker.dart';
import 'guest_report_table.dart';

class GuestReport extends StatefulWidget {
  const GuestReport({super.key});

  @override
  State<GuestReport> createState() => _GuestReportState();
}

class _GuestReportState extends State<GuestReport> {
  List<LeadReportData>? report;
  TextEditingController searchController = TextEditingController();
  List<Report?>? labels;

  Future fetchReport() async {
    report = await context.read<NetworkControllers>().fetchGuestReport(
          search: searchController.text,
          objection: selectedObjections,
          profession: selectedOccupations,
        );
  }

  FetchOccupationModel? occupationModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      labels = guestReportColumns();
      setState(() {});
      fetchReport();

      context.read<FilterController>().fetchObjections();

      context.read<FilterController>().fetchOccupations();
    });
  }

  List<FilterData?>? selectedOccupations;
  List<FilterData?>? occupations;

  List<FilterData?>? selectedObjections;
  List<FilterData?>? objections;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    FilterController filterController = Provider.of<FilterController>(context);

    occupations = filterController.occupations;
    objections = filterController.objections;
    return Consumer<NetworkControllers>(builder: (context, controller, child) {
      report = controller.guestReport;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            hintText: 'Search',
            controller: searchController,
            autofocus: false,
            hintStyle: const TextStyle(color: Colors.white),
            prefixIcon: ImageView(
              height: 20,
              width: 20,
              borderRadiusValue: 0,
              color: Colors.white,
              margin: const EdgeInsets.only(left: kPadding, right: kPadding),
              fit: BoxFit.contain,
              assetImage: AppAssets.searchIcon,
              onTap: () {
                fetchReport();
              },
            ),
            onEditingComplete: () {
              fetchReport();
            },
            margin: const EdgeInsets.only(left: kPadding, right: kPadding, bottom: kPadding, top: kPadding),
          ),
          Container(
            height: 32,
            margin: const EdgeInsets.only(bottom: kPadding),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: kPadding),
                children: [
                  FilterChip(
                    title: 'Report Labels',
                    onTap: () {
                      CustomBottomSheet.show(
                        context: context,
                        physics: const BouncingScrollPhysics(),
                        title: 'Report Labels Filter',
                        centerTitle: true,
                        showBackButton: true,
                        body: StatefulBuilder(builder: (context, setState) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: kPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ReportLabelPicker(
                                  list: labels,
                                  onChanged: (val) async {
                                    labels = val;
                                    setState(() {});
                                    this.setState(() {});
                                    await fetchReport();
                                  },
                                ),
                              ],
                            ),
                          );
                        }),
                        bottomNavBarHeight: 60,
                        bottomNavBar: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GradientButton(
                              height: 45,
                              width: size.width * .42,
                              backgroundGradient: blackGradient,
                              onTap: () async {
                                labels = guestReportColumns();

                                setState(() {});
                                fetchReport();

                                context.pop();
                              },
                              margin: const EdgeInsets.only(top: kPadding, left: kPadding),
                              child: const Center(
                                child: Text(
                                  'Clear',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            GradientButton(
                              height: 45,
                              width: size.width * .42,
                              backgroundGradient: primaryGradient,
                              onTap: () async {
                                setState(() {});

                                context.pop();
                                await fetchReport();
                              },
                              margin: const EdgeInsets.only(top: kPadding, right: kPadding),
                              child: const Center(
                                child: Text(
                                  'Apply',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  FilterChip(
                    title: 'Objections',
                    onTap: () {
                      CustomBottomSheet.show(
                          context: context,
                          title: 'Objections Filter',
                          centerTitle: true,
                          showBackButton: true,
                          physics: const BouncingScrollPhysics(),
                          body: StatefulBuilder(builder: (context, setState) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: kPadding),
                              child: MultiFilterPicker(
                                selected: selectedObjections,
                                list: objections,
                                fontSize: 12,
                                onChanged: (val) {
                                  selectedObjections = val;
                                  setState(() {});
                                  this.setState(() {});
                                },
                              ),
                            );
                          }),
                          bottomNavBarHeight: 60,
                          bottomNavBar: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GradientButton(
                                height: 45,
                                width: size.width * .42,
                                backgroundGradient: blackGradient,
                                onTap: () async {
                                  selectedObjections = null;
                                  setState(() {});
                                  context.pop();
                                  await fetchReport();
                                },
                                margin: const EdgeInsets.only(top: kPadding, left: kPadding),
                                child: const Center(
                                  child: Text(
                                    'Clear',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              GradientButton(
                                height: 45,
                                width: size.width * .42,
                                backgroundGradient: primaryGradient,
                                onTap: () async {
                                  context.pop();
                                  await fetchReport();
                                },
                                margin: const EdgeInsets.only(top: kPadding, right: kPadding),
                                child: const Center(
                                  child: Text(
                                    'Apply',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ));
                    },
                  ),
                  FilterChip(
                    title: 'Profession',
                    onTap: () {
                      CustomBottomSheet.show(
                          context: context,
                          title: 'Profession Filter',
                          centerTitle: true,
                          showBackButton: true,
                          physics: const BouncingScrollPhysics(),
                          body: StatefulBuilder(builder: (context, setState) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: kPadding),
                              child: MultiFilterPicker(
                                selected: selectedOccupations,
                                list: occupations,
                                fontSize: 12,
                                onChanged: (val) async {
                                  selectedOccupations = val;
                                  setState(() {});
                                  this.setState(() {});
                                  await fetchReport();
                                },
                              ),
                            );
                          }),
                          bottomNavBarHeight: 60,
                          bottomNavBar: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GradientButton(
                                height: 45,
                                width: size.width * .42,
                                backgroundGradient: blackGradient,
                                onTap: () async {
                                  selectedOccupations = null;
                                  setState(() {});
                                  context.pop();
                                  await fetchReport();
                                },
                                margin: const EdgeInsets.only(top: kPadding, left: kPadding),
                                child: const Center(
                                  child: Text(
                                    'Clear',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              GradientButton(
                                height: 45,
                                width: size.width * .42,
                                backgroundGradient: primaryGradient,
                                onTap: () async {
                                  context.pop();
                                  await fetchReport();
                                },
                                margin: const EdgeInsets.only(top: kPadding, right: kPadding),
                                child: const Center(
                                  child: Text(
                                    'Apply',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ));
                    },
                  ),
                ],
              ),
            ),
          ),
          if (controller.loadingGuestReport)
            const Expanded(
              child: LoadingScreen(
                message: 'Loading Guest Report View',
              ),
            )
          else if (report.haveData)
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPadding),
              child: GuestReportTable(
                labels: labels,
                report: report,
              ),
            ))
          else
            const Expanded(
              child: NoDataFound(
                message: 'No Guest Report Found',
              ),
            ),
        ],
      );
    });
  }
}

class FilterChip extends StatelessWidget {
  const FilterChip({
    super.key,
    required this.title,
    required this.onTap,
  });

  final String title;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GradientButton(
      height: 32,
      borderRadius: 50,
      backgroundGradient: blackGradient,
      margin: const EdgeInsets.only(right: kPadding),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kPadding),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTabBar extends StatelessWidget {
  final String tab;
  final String selectedTab;
  final double? height;
  final double? width;
  final bool? alwaysShowLabel;

  final GestureTapCallback? onTap;
  final EdgeInsets? imageMargin;

  const CustomTabBar({
    super.key,
    required this.tab,
    required this.selectedTab,
    this.height,
    this.width,
    this.alwaysShowLabel = false,
    this.onTap,
    this.imageMargin,
  });

  @override
  Widget build(BuildContext context) {
    bool selected = selectedTab == tab;
    return GestureDetector(
      onTap: onTap ?? () {},
      child: GradientButton(
        padding: const EdgeInsets.symmetric(horizontal: kPadding, vertical: 8),
        borderRadius: 50,
        blur: 10,
        height: height ?? 50,
        width: width ?? (selected == true ? null : 50),
        backgroundGradient: selected == true ? primaryGradient : null,
        backgroundColor: selected == true ? null : Colors.grey.withOpacity(0.3),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 6),
            child: Text(
              '$tab Report',
              style: TextStyle(
                fontSize: 12,
                color: selected ? Colors.black : Colors.white,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
