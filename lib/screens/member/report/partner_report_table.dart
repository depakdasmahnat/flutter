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
import 'guest_report_table.dart';

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
              if (showColumn(name: PartnerTabHeadings.user.value))
                GridColumn(
                  maximumWidth: 50,
                  columnName: PartnerTabHeadings.user.value,
                  label: GridHeading(title: PartnerTabHeadings.user.value),
                ),
              if (showColumn(name: PartnerTabHeadings.name.value))
                GridColumn(
                  columnName: PartnerTabHeadings.name.value,
                  label: GridHeading(title: PartnerTabHeadings.name.value),
                ),
              if (showColumn(name: PartnerTabHeadings.location.value))
                GridColumn(
                  columnName: PartnerTabHeadings.location.value,
                  label: GridHeading(title: PartnerTabHeadings.location.value),
                ),
              if (showColumn(name: PartnerTabHeadings.target.value))
                GridColumn(
                  columnName: PartnerTabHeadings.target.value,
                  label: GridHeading(title: PartnerTabHeadings.target.value),
                ),
              if (showColumn(name: PartnerTabHeadings.pending.value))
                GridColumn(
                  columnName: PartnerTabHeadings.pending.value,
                  label: GridHeading(title: PartnerTabHeadings.pending.value),
                ),
              if (showColumn(name: PartnerTabHeadings.conversion.value))
                GridColumn(
                  columnName: PartnerTabHeadings.conversion.value,
                  label: GridHeading(title: PartnerTabHeadings.conversion.value),
                ),
              if (showColumn(name: PartnerTabHeadings.demo.value))
                GridColumn(
                  columnName: PartnerTabHeadings.demo.value,
                  label: GridHeading(title: PartnerTabHeadings.demo.value),
                ),
              if (showColumn(name: PartnerTabHeadings.training.value))
                GridColumn(
                  columnName: PartnerTabHeadings.training.value,
                  label: GridHeading(title: PartnerTabHeadings.training.value),
                ),
              if (showColumn(name: PartnerTabHeadings.performance.value))
                GridColumn(
                  columnName: PartnerTabHeadings.performance.value,
                  label: GridHeading(title: PartnerTabHeadings.performance.value),
                ),
              if (showColumn(name: PartnerTabHeadings.call.value))
                GridColumn(
                  columnName: PartnerTabHeadings.call.value,
                  label: GridHeading(title: PartnerTabHeadings.call.value),
                ),
              if (showColumn(name: PartnerTabHeadings.rank.value))
                GridColumn(
                  columnName: PartnerTabHeadings.rank.value,
                  label: GridHeading(title: PartnerTabHeadings.rank.value),
                ),
              if (showColumn(name: PartnerTabHeadings.turnover.value))
                GridColumn(
                  columnName: PartnerTabHeadings.turnover.value,
                  label: GridHeading(title: PartnerTabHeadings.turnover.value),
                ),
              if (showColumn(name: PartnerTabHeadings.appDownloads.value))
                GridColumn(
                  columnName: PartnerTabHeadings.appDownloads.value,
                  label: GridHeading(title: PartnerTabHeadings.appDownloads.value),
                ),
              if (showColumn(name: PartnerTabHeadings.lists.value))
                GridColumn(
                  columnName: PartnerTabHeadings.lists.value,
                  label: GridHeading(title: PartnerTabHeadings.lists.value),
                ),
              if (showColumn(name: PartnerTabHeadings.sales.value))
                GridColumn(
                  columnName: PartnerTabHeadings.sales.value,
                  label: GridHeading(title: PartnerTabHeadings.sales.value),
                ),
              if (showColumn(name: PartnerTabHeadings.level.value))
                GridColumn(
                  columnName: PartnerTabHeadings.level.value,
                  label: GridHeading(title: PartnerTabHeadings.level.value),
                ),
              if (showColumn(name: PartnerTabHeadings.downLines.value))
                GridColumn(
                  columnName: PartnerTabHeadings.downLines.value,
                  label: GridHeading(title: PartnerTabHeadings.downLines.value),
                ),
              if (showColumn(name: PartnerTabHeadings.levelCompletion.value))
                GridColumn(
                  columnName: PartnerTabHeadings.levelCompletion.value,
                  label: GridHeading(title: PartnerTabHeadings.levelCompletion.value),
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
            if (showColumn(name: PartnerTabHeadings.user.value))
              DataGridCell(
                columnName: PartnerTabHeadings.user.value,
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
            if (showColumn(name: PartnerTabHeadings.name.value))
              DataGridCell(
                columnName: PartnerTabHeadings.name.value,
                value: Align(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: GridHeading(title: data.name ?? defaultText),
                  ),
                ),
              ),
            if (showColumn(name: PartnerTabHeadings.location.value))
              DataGridCell(
                columnName: PartnerTabHeadings.location.value,
                value: Align(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: GridHeading(title: data.location ?? defaultText),
                  ),
                ),
              ),
            if (showColumn(name: PartnerTabHeadings.target.value))
              DataGridCell(
                columnName: PartnerTabHeadings.target.value,
                value: GridHeading(title: '${data.target ?? defaultText}'),
              ),
            if (showColumn(name: PartnerTabHeadings.pending.value))
              DataGridCell(
                columnName: PartnerTabHeadings.pending.value,
                value: GridHeading(title: '${data.pending ?? defaultText}'),
              ),
            if (showColumn(name: PartnerTabHeadings.conversion.value))
              DataGridCell(
                columnName: PartnerTabHeadings.conversion.value,
                value: GridHeading(title: '${data.conversion ?? 0}%'),
              ),
            if (showColumn(name: PartnerTabHeadings.demo.value))
              DataGridCell(
                columnName: PartnerTabHeadings.demo.value,
                value: GridHeading(title: '${data.demo ?? defaultText}'),
              ),
            if (showColumn(name: PartnerTabHeadings.training.value))
              DataGridCell(
                columnName: PartnerTabHeadings.training.value,
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
            if (showColumn(name: PartnerTabHeadings.performance.value))
              DataGridCell(
                columnName: PartnerTabHeadings.performance.value,
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
            if (showColumn(name: PartnerTabHeadings.call.value))
              DataGridCell(
                columnName: PartnerTabHeadings.call.value,
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
            if (showColumn(name: PartnerTabHeadings.rank.value))
              DataGridCell(
                columnName: PartnerTabHeadings.rank.value,
                value: GridHeading(title: data.rank ?? defaultText),
              ),
            if (showColumn(name: PartnerTabHeadings.turnover.value))
              DataGridCell(
                columnName: PartnerTabHeadings.turnover.value,
                value: GridHeading(title: '${data.turnovers ?? defaultText}'),
              ),
            if (showColumn(name: PartnerTabHeadings.appDownloads.value))
              DataGridCell(
                columnName: PartnerTabHeadings.appDownloads.value,
                value: GridHeading(title: '${data.appDownloads ?? defaultText}'),
              ),
            if (showColumn(name: PartnerTabHeadings.lists.value))
              DataGridCell(
                columnName: PartnerTabHeadings.lists.value,
                value: GridHeading(title: '${data.lists ?? defaultText}'),
              ),
            if (showColumn(name: PartnerTabHeadings.sales.value))
              DataGridCell(
                columnName: PartnerTabHeadings.sales.value,
                value: GridHeading(title: '${data.sales ?? defaultText}'),
              ),
            if (showColumn(name: PartnerTabHeadings.level.value))
              DataGridCell(
                columnName: PartnerTabHeadings.level.value,
                value: GridHeading(title: '${data.level ?? defaultText}'),
              ),
            if (showColumn(name: PartnerTabHeadings.downLines.value))
              DataGridCell(
                columnName: PartnerTabHeadings.downLines.value,
                value: GridHeading(title: '${data.downline ?? defaultText}'),
              ),
            if (showColumn(name: PartnerTabHeadings.levelCompletion.value))
              DataGridCell(
                columnName: PartnerTabHeadings.levelCompletion.value,
                value: GridHeading(title: '${data.levelCompletion ?? defaultText}'),
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

