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
import '../../../models/member/report/guest_lead_report.dart';
import '../../../models/member/report/partner_report_model.dart';

class GuestReportTable extends StatefulWidget {
  /// Creates the home page.
  const GuestReportTable({super.key, this.report, this.verticalScrollPhysics, this.labels});

  final List<Report?>? labels;
  final List<LeadReportData>? report;
  final ScrollPhysics? verticalScrollPhysics;

  @override
  _GuestReportTableState createState() => _GuestReportTableState();
}

class _GuestReportTableState extends State<GuestReportTable> {
  List<Report?>? labels;

  late List<LeadReportData>? report = widget.report;
  late ScrollPhysics? verticalScrollPhysics = widget.verticalScrollPhysics;

  EmployeeDataSource? employeeDataSource;
  late List<LeadReportData>? getPinnacles = widget.report;

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (report != null) {
        labels = widget.labels;
        setState(() {});
        employeeDataSource = EmployeeDataSource(
          employeeData: report,
          labels: labels,
        );
        setState(() {});
      }
    });
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
              if (showColumn(name: GuestTabHeadings.user.value))
                GridColumn(
                  maximumWidth: 50,
                  columnName: GuestTabHeadings.user.value,
                  label: GridHeading(title: GuestTabHeadings.user.value),
                ),
              if (showColumn(name: GuestTabHeadings.name.value))
                GridColumn(
                  columnName: GuestTabHeadings.name.value,
                  label: GridHeading(title: GuestTabHeadings.name.value),
                ),
              if (showColumn(name: GuestTabHeadings.location.value))
                GridColumn(
                  columnName: GuestTabHeadings.location.value,
                  label: GridHeading(title: GuestTabHeadings.location.value),
                ),
              if (showColumn(name: GuestTabHeadings.demoDone.value))
                GridColumn(
                  columnName: GuestTabHeadings.demoDone.value,
                  label: GridHeading(title: GuestTabHeadings.demoDone.value),
                ),
              if (showColumn(name: GuestTabHeadings.pending.value))
                GridColumn(
                  columnName: GuestTabHeadings.pending.value,
                  label: GridHeading(title: GuestTabHeadings.pending.value),
                ),
              if (showColumn(name: GuestTabHeadings.count.value))
                GridColumn(
                  columnName: GuestTabHeadings.count.value,
                  label: GridHeading(title: GuestTabHeadings.count.value),
                ),
              if (showColumn(name: GuestTabHeadings.profile.value))
                GridColumn(
                  columnName: GuestTabHeadings.profile.value,
                  label: GridHeading(title: GuestTabHeadings.profile.value),
                ),
              if (showColumn(name: GuestTabHeadings.profession.value))
                GridColumn(
                  columnName: GuestTabHeadings.profession.value,
                  label: GridHeading(title: GuestTabHeadings.profession.value),
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
    required List<LeadReportData>? employeeData,
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
            if (showColumn(name: GuestTabHeadings.user.value))
              DataGridCell(
                columnName: GuestTabHeadings.user.value,
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
                      networkImage: '${data.profilePhoto}',
                      margin: const EdgeInsets.only(right: 4),
                    ),
                  ],
                ),
              ),
            if (showColumn(name: GuestTabHeadings.name.value))
              DataGridCell(
                columnName: GuestTabHeadings.name.value,
                value: Align(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: GridHeading(
                        title: '${data.firstName ?? defaultText} ${data.lastName ?? ''}',
                      )),
                ),
              ),
            if (showColumn(name: GuestTabHeadings.location.value))
              DataGridCell(
                columnName: GuestTabHeadings.location.value,
                value: Align(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: GridHeading(title: data.address ?? defaultText),
                  ),
                ),
              ),
            if (showColumn(name: GuestTabHeadings.demoDone.value))
              DataGridCell(
                columnName: GuestTabHeadings.demoDone.value,
                value: GridHeading(title: '${data.demoDone ?? defaultText}'),
              ),
            if (showColumn(name: GuestTabHeadings.pending.value))
              DataGridCell(
                columnName: GuestTabHeadings.pending.value,
                value: GridHeading(title: '${data.pending ?? defaultText}'),
              ),
            if (showColumn(name: GuestTabHeadings.count.value))
              DataGridCell(
                columnName: GuestTabHeadings.count.value,
                value: GridHeading(title: '${data.count ?? 0}'),
              ),
            if (showColumn(name: GuestTabHeadings.profile.value))
              DataGridCell(
                columnName: GuestTabHeadings.profile.value,
                value: GridHeading(title: data.profileUpdated ?? defaultText),
              ),
            if (showColumn(name: GuestTabHeadings.profession.value))
              DataGridCell(
                columnName: GuestTabHeadings.profession.value,
                value: GridHeading(title: data.occupation ?? defaultText),
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
