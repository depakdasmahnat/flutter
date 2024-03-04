import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import 'package:mrwebbeast/utils/widgets/no_data_found.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/member/network/pinnacle_list_model.dart';
import '../../../models/member/report/partner_report_model.dart';

class PartnerReportTable extends StatefulWidget {
  /// Creates the home page.
  const PartnerReportTable({super.key, this.report, this.verticalScrollPhysics, this.labels});

  final List<Report?>? labels;
  final List<PartnerReportData>? report;
  final ScrollPhysics? verticalScrollPhysics;

  @override
  _PartnerReportTableState createState() => _PartnerReportTableState();
}

class _PartnerReportTableState extends State<PartnerReportTable> {
  late List<Report?>? labels = widget.labels;
  late List<PartnerReportData>? pinnacles = widget.report;
  late ScrollPhysics? verticalScrollPhysics = widget.verticalScrollPhysics;

  EmployeeDataSource? employeeDataSource;
  late List<PartnerReportData>? getPinnacles = widget.report;

  bool showColumn({required String name}) {
    bool status = false;
    var data =
        labels?.where((element) => ((element?.name == name) && (element?.isSelected == true))).toList();
    if (data.haveData) {
      status = true;
    }

    return status;
  }

  @override
  void initState() {
    super.initState();
    if (pinnacles != null) {
      employeeDataSource = EmployeeDataSource(
        employeeData: pinnacles,
        labels: labels,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return employeeDataSource != null
        ? SfDataGrid(
            footerHeight: 100,
            footer: const SizedBox(),
            verticalScrollPhysics: verticalScrollPhysics ?? const BouncingScrollPhysics(),
            source: employeeDataSource!,
            shrinkWrapRows: true,
            columns: [
              if (showColumn(name: PartnerHeadings.user.value))
                GridColumn(
                  maximumWidth: 50,
                  columnName: PartnerHeadings.user.value,
                  label: GridHeading(title: PartnerHeadings.user.value),
                ),
              if (showColumn(name: PartnerHeadings.name.value))
                GridColumn(
                  columnName: PartnerHeadings.name.value,
                  label: GridHeading(title: PartnerHeadings.name.value),
                ),
              if (showColumn(name: PartnerHeadings.target.value))
                GridColumn(
                  columnName: PartnerHeadings.target.value,
                  label: GridHeading(title: PartnerHeadings.target.value),
                ),
              if (showColumn(name: PartnerHeadings.pending.value))
                GridColumn(
                  columnName: PartnerHeadings.pending.value,
                  label: GridHeading(title: PartnerHeadings.pending.value),
                ),
              if (showColumn(name: PartnerHeadings.conversion.value))
                GridColumn(
                  columnName: PartnerHeadings.conversion.value,
                  label: GridHeading(title: PartnerHeadings.conversion.value),
                ),
              if (showColumn(name: PartnerHeadings.lists.value))
                GridColumn(
                  columnName: PartnerHeadings.lists.value,
                  label: GridHeading(title: PartnerHeadings.lists.value),
                ),
              if (showColumn(name: PartnerHeadings.demo.value))
                GridColumn(
                  columnName: PartnerHeadings.demo.value,
                  label: GridHeading(title: PartnerHeadings.demo.value),
                ),
              if (showColumn(name: PartnerHeadings.training.value))
                GridColumn(
                  columnName: PartnerHeadings.training.value,
                  label: GridHeading(title: PartnerHeadings.training.value),
                ),
              if (showColumn(name: PartnerHeadings.performance.value))
                GridColumn(
                  columnName: PartnerHeadings.performance.value,
                  label: GridHeading(title: PartnerHeadings.performance.value),
                ),
              if (showColumn(name: PartnerHeadings.call.value))
                GridColumn(
                  columnName: PartnerHeadings.call.value,
                  label: GridHeading(title: PartnerHeadings.call.value),
                ),
              if (showColumn(name: PartnerHeadings.rank.value))
                GridColumn(
                  columnName: PartnerHeadings.rank.value,
                  label: GridHeading(title: PartnerHeadings.rank.value),
                ),
            ],
          )
        : const NoDataFound();
  }
}

class EmployeeDataSource extends DataGridSource {
  String defaultText = '__';

  /// Creates the employee data source class with required details.
  EmployeeDataSource({
    required List<PartnerReportData>? employeeData,
    required List<Report?>? labels,
  }) {
    bool showColumn({required String name}) {
      bool status = false;
      var data =
          labels?.where((element) => ((element?.name == name) && (element?.isSelected == true))).toList();
      if (data.haveData) {
        status = true;
      }

      return status;
    }

    _employeeData = employeeData!.map<DataGridRow>(
      (data) {
        return DataGridRow(
          cells: [
            if (showColumn(name: PartnerHeadings.user.value))
              DataGridCell(
                columnName: PartnerHeadings.user.value,
                value: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ImageView(
                      height: 30,
                      width: 30,
                      isAvatar: true,
                      borderRadiusValue: 30,
                      backgroundColor: Colors.grey.shade300,
                      fit: BoxFit.cover,
                      networkImage: '${data.profilePic}',
                      margin: const EdgeInsets.only(right: 4),
                    ),
                  ],
                ),
              ),
            if (showColumn(name: PartnerHeadings.name.value))
              DataGridCell(
                columnName: PartnerHeadings.name.value,
                value: Align(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: GridHeading(title: data.name ?? defaultText),
                  ),
                ),
              ),
            if (showColumn(name: PartnerHeadings.target.value))
              DataGridCell(
                columnName: PartnerHeadings.target.value,
                value: GridHeading(title: '${data.target ?? defaultText}'),
              ),
            if (showColumn(name: PartnerHeadings.pending.value))
              DataGridCell(
                columnName: PartnerHeadings.pending.value,
                value: GridHeading(title: '${data.pending ?? defaultText}'),
              ),
            if (showColumn(name: PartnerHeadings.conversion.value))
              DataGridCell(
                columnName: PartnerHeadings.conversion.value,
                value: GridHeading(title: '${data.conversion ?? 0}%'),
              ),
            if (showColumn(name: PartnerHeadings.lists.value))
              DataGridCell(
                columnName: PartnerHeadings.lists.value,
                value: GridHeading(title: '${data.lists ?? defaultText}'),
              ),
            if (showColumn(name: PartnerHeadings.demo.value))
              DataGridCell(
                columnName: PartnerHeadings.demo.value,
                value: GridHeading(title: '${data.demo ?? defaultText}'),
              ),
            if (showColumn(name: PartnerHeadings.training.value))
              DataGridCell(
                columnName: PartnerHeadings.training.value,
                value: CircularPercentIndicator(
                  radius: 16.0,
                  lineWidth: 3,
                  percent: (data.training ?? 0).toDouble() / 100,
                  center: Text(
                    '${(data.training ?? 0).toInt()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  progressColor: statusColor(value: data.training),
                ),
              ),
            if (showColumn(name: PartnerHeadings.performance.value))
              DataGridCell(
                columnName: PartnerHeadings.performance.value,
                value: CircularPercentIndicator(
                  radius: 16.0,
                  lineWidth: 3,
                  percent: (data.performace ?? 0).toDouble() / 100,
                  center: Text(
                    '${(data.performace ?? 0).toInt()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  progressColor: statusColor(value: data.training),
                ),
              ),
            if (showColumn(name: PartnerHeadings.call.value))
              DataGridCell(
                columnName: PartnerHeadings.call.value,
                value: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ImageView(
                      height: 30,
                      width: 30,
                      isAvatar: true,
                      backgroundColor: Colors.white,
                      borderRadiusValue: 50,
                      color: Colors.black,
                      assetImage: AppAssets.call,
                      onTap: () {
                        launchUrl(Uri.parse('tel:${data.call}'));
                      },
                      padding: const EdgeInsets.all(8),
                    ),
                  ],
                ),
              ),
            if (showColumn(name: PartnerHeadings.rank.value))
              DataGridCell(
                columnName: PartnerHeadings.rank.value,
                value: GridHeading(title: data.rank ?? defaultText),
              ),
          ],
        );
      },
    ).toList();
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return e.value;
    }).toList());
  }
}

class GridHeading extends StatelessWidget {
  const GridHeading({super.key, this.title, this.mainAxisAlignment});

  final String? title;
  final MainAxisAlignment? mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
        children: [
          Text(
            '$title',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}

class Report {
  final String name;
  bool isSelected;
  bool isLocked;

  Report({required this.name, this.isSelected = false, this.isLocked = false});
}
