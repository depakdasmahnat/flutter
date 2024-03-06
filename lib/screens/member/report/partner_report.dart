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
import 'package:provider/provider.dart';

import '../../../controllers/member/member_controller/member_controller.dart';
import '../../../controllers/member/network/network_controller.dart';
import '../../../core/config/app_assets.dart';
import '../../../core/constant/constant.dart';
import '../../../models/member/filter/filter_model.dart';
import '../../../models/member/network/pinnacle_list_model.dart';
import '../../../models/member/occupation/fetchOccupationModel.dart';
import '../../../models/member/report/partner_report_model.dart';
import '../../../utils/widgets/custom_bottom_sheet.dart';
import '../../../utils/widgets/image_view.dart';
import '../../../utils/widgets/loading_screen.dart';
import '../../../utils/widgets/multi_filter_picker.dart';
import '../../../utils/widgets/no_data_found.dart';
import '../../../utils/widgets/option_picker.dart';
import 'guest_report_table.dart';

class PartnerReport extends StatefulWidget {
  const PartnerReport({super.key});

  @override
  State<PartnerReport> createState() => _PartnerReportState();
}

class _PartnerReportState extends State<PartnerReport> {
  List<PartnerReportData>? report;
  TextEditingController searchController = TextEditingController();

  Future fetchReport() async {
    report = await context.read<NetworkControllers>().fetchPartnerReport(
          search: searchController.text,
          rank: selectedRank,
          level: level,
          objection: selectedObjections,
          productPrice: productPrice,
          fromDate: startDate,
          toDate: endDate,
          turnover: turnover,
          machineType: selectedMachineTypes,
          profession: selectedOccupations,
        );
  }

  double? level;
  double? productPrice;
  double? turnover;
  String? rank;
  List<Report?>? labels;
  String? selectedRank;
  DateTime? startDate;
  DateTime? endDate;
  FetchOccupationModel? occupationModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      labels = partnerReportColumns();
      setState(() {});
      fetchReport();

      context.read<FilterController>().fetchObjections();
      context.read<FilterController>().fetchMachineType();
      context.read<FilterController>().fetchOccupations();
    });
  }

  Future<void> _showDateRangePicker(BuildContext context) async {
    final initialDateRange = DateTimeRange(
      start: startDate ?? DateTime.now().subtract(const Duration(days: 7)),
      end: endDate ?? DateTime.now(),
    );

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      initialDateRange: initialDateRange,
      textDirection: TextDirection.ltr,
    );

    if (picked != null) {
      startDate = picked.start;
      endDate = picked.end;
      fetchReport();
      print('Date range selected: ${picked.start} to ${picked.end}');
    }
  }

  List<FilterData?>? selectedOccupations;
  List<FilterData?>? occupations;
  List<FilterData?>? selectedMachineTypes;
  List<FilterData?>? machineTypes;
  List<FilterData?>? selectedObjections;
  List<FilterData?>? objections;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    FilterController filterController = Provider.of<FilterController>(context);

    occupations = filterController.occupations;
    machineTypes = filterController.machineTypes;
    objections = filterController.objections;
    return Consumer<NetworkControllers>(builder: (context, controller, child) {
      report = controller.partnerReport;
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
                                  onChanged: (val) {
                                    labels = val;
                                    setState(() {});
                                    this.setState(() {});
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
                                labels = partnerReportColumns();
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
                    title: 'Rank',
                    onTap: () {
                      CustomBottomSheet.show(
                        context: context,
                        title: 'Rank Filter',
                        centerTitle: true,
                        showBackButton: true,
                        body: StatefulBuilder(builder: (context, setState) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: kPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                OptionPicker(
                                  selected: selectedRank,
                                  list: levels,
                                  onChanged: (val) {
                                    selectedRank = val;
                                    setState(() {});
                                    this.setState(() {});
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GradientButton(
                                      height: 45,
                                      width: size.width * .42,
                                      backgroundGradient: blackGradient,
                                      onTap: () async {
                                        selectedRank = null;
                                        setState(() {});
                                        this.setState(() {});
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
                                        setState(() {});
                                        this.setState(() {});
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
                                )
                              ],
                            ),
                          );
                        }),
                      );
                    },
                  ),
                  FilterChip(
                    title: 'Level',
                    onTap: () {
                      CustomBottomSheet.show(
                        context: context,
                        title: 'Level Filter',
                        centerTitle: true,
                        showBackButton: true,
                        body: StatefulBuilder(builder: (context, setState) {
                          double? level = this.level ?? 0;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: kPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: kPadding),
                                  child: Text('Level ${level.toInt()}'),
                                ),
                                Slider(
                                  value: level ?? 0,
                                  min: 0,
                                  max: 7,
                                  divisions: 7,
                                  onChanged: (val) {
                                    level = val;
                                    this.level = level;
                                    setState(() {});
                                    this.setState(() {});
                                  },
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: kPadding),
                                  child: Text('0 - 7'),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GradientButton(
                                      height: 45,
                                      width: size.width * .42,
                                      backgroundGradient: blackGradient,
                                      onTap: () async {
                                        this.level = null;
                                        setState(() {});
                                        this.setState(() {});
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
                                        this.level = level;
                                        setState(() {});
                                        this.setState(() {});
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
                                )
                              ],
                            ),
                          );
                        }),
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
                    title: 'Product Price',
                    onTap: () {
                      CustomBottomSheet.show(
                        context: context,
                        title: 'Product Price Filter',
                        centerTitle: true,
                        showBackButton: true,
                        body: StatefulBuilder(builder: (context, setState) {
                          double? productPrice = this.productPrice ?? 0;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: kPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: kPadding),
                                  child: Text('Product Price ${productPrice.toInt()}'),
                                ),
                                Slider(
                                  value: productPrice ?? 0,
                                  min: 0,
                                  max: 200000,
                                  divisions: 200000,
                                  onChanged: (val) {
                                    productPrice = val;
                                    this.productPrice = productPrice;
                                    setState(() {});
                                    this.setState(() {});
                                  },
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: kPadding),
                                  child: Text('0 - 200000'),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GradientButton(
                                      height: 45,
                                      width: size.width * .42,
                                      backgroundGradient: blackGradient,
                                      onTap: () async {
                                        this.productPrice = null;
                                        setState(() {});
                                        this.setState(() {});
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
                                        this.productPrice = productPrice;
                                        setState(() {});
                                        this.setState(() {});
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
                                )
                              ],
                            ),
                          );
                        }),
                      );
                    },
                  ),
                  FilterChip(
                    title: 'Date Range',
                    onTap: () {
                      _showDateRangePicker(context);
                    },
                  ),
                  FilterChip(
                    title: 'Turnover',
                    onTap: () {
                      CustomBottomSheet.show(
                        context: context,
                        title: 'Turnover Filter',
                        centerTitle: true,
                        showBackButton: true,
                        body: StatefulBuilder(builder: (context, setState) {
                          double? turnover = this.turnover ?? 0;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: kPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: kPadding),
                                  child: Text('Turnover ${turnover.toInt()}'),
                                ),
                                Slider(
                                  value: turnover ?? 0,
                                  min: 0,
                                  max: 200000,
                                  divisions: 200000,
                                  onChanged: (val) {
                                    turnover = val;
                                    this.turnover = turnover;
                                    setState(() {});
                                    this.setState(() {});
                                  },
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: kPadding),
                                  child: Text('0 - 200000'),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GradientButton(
                                      height: 45,
                                      width: size.width * .42,
                                      backgroundGradient: blackGradient,
                                      onTap: () async {
                                        this.turnover = null;
                                        setState(() {});
                                        this.setState(() {});
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
                                        this.turnover = turnover;
                                        setState(() {});
                                        this.setState(() {});
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
                                )
                              ],
                            ),
                          );
                        }),
                      );
                    },
                  ),
                  FilterChip(
                    title: 'Machine Type',
                    onTap: () {
                      CustomBottomSheet.show(
                          context: context,
                          title: 'Machine Type Filter',
                          centerTitle: true,
                          showBackButton: true,
                          physics: const BouncingScrollPhysics(),
                          body: StatefulBuilder(builder: (context, setState) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: kPadding),
                              child: MultiFilterPicker(
                                selected: selectedMachineTypes,
                                list: machineTypes,
                                fontSize: 12,
                                onChanged: (val) {
                                  selectedMachineTypes = val;
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
                                  selectedMachineTypes = null;
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
          if (controller.loadingPartnerReport)
            const Expanded(
              child: LoadingScreen(
                message: 'Loading Partner Report View',
              ),
            )
          else if (report.haveData)
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPadding),
              child: PartnerReportTable(
                labels: labels,
                report: report,
              ),
            ))
          else
            const Expanded(
              child: NoDataFound(
                message: 'No Partner Report Found',
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
