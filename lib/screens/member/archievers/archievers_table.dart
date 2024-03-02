import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import 'package:mrwebbeast/utils/widgets/no_data_found.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../core/constant/constant.dart';
import '../../../models/member/dashboard/achievers_model.dart';

class AchieversTable extends StatefulWidget {
  /// Creates the home page.
  const AchieversTable({super.key, this.achievers});

  final List<AchieversData>? achievers;

  @override
  _AchieversTableState createState() => _AchieversTableState();
}

class _AchieversTableState extends State<AchieversTable> {
  late List<AchieversData>? achievers = widget.achievers;
  EmployeeDataSource? employeeDataSource;

  @override
  void initState() {
    super.initState();
    if (achievers != null) {
      employeeDataSource = EmployeeDataSource(employeeData: achievers);
    }
  }

  @override
  Widget build(BuildContext context) {
    return employeeDataSource != null
        ? SfDataGrid(
            source: employeeDataSource!,
            shrinkWrapRows: true,
            columns: [
              GridColumn(
                maximumWidth: 50,
                columnName: AchieversTableHeadings.rank.value,
                label: GridHeading(title: AchieversTableHeadings.rank.value),
              ),
              GridColumn(
                minimumWidth: 120,
                columnName: AchieversTableHeadings.name.value,
                label: GridHeading(
                  title: AchieversTableHeadings.name.value,
                  mainAxisAlignment: MainAxisAlignment.start,
                ),
              ),
              GridColumn(
                columnName: AchieversTableHeadings.sales.value,
                label: GridHeading(title: AchieversTableHeadings.sales.value),
              ),
              GridColumn(
                columnName: AchieversTableHeadings.demo.value,
                label: GridHeading(title: AchieversTableHeadings.demo.value),
              ),
              GridColumn(
                columnName: AchieversTableHeadings.turnover.value,
                label: GridHeading(title: AchieversTableHeadings.turnover.value),
              ),
              GridColumn(
                minimumWidth: 140,
                columnName: AchieversTableHeadings.appDownloads.value,
                label: GridHeading(title: AchieversTableHeadings.appDownloads.value),
              ),
              GridColumn(
                columnName: AchieversTableHeadings.performance.value,
                label: GridHeading(title: AchieversTableHeadings.performance.value),
              ),
            ],
          )
        : const NoDataFound();
  }
}

class EmployeeDataSource extends DataGridSource {
  String defaultText = '__';

  /// Creates the employee data source class with required details.
  EmployeeDataSource({required List<AchieversData>? employeeData}) {
    _employeeData = employeeData!.map<DataGridRow>(
      (e) {
        return DataGridRow(
          cells: [
            DataGridCell(
              columnName: AchieversTableHeadings.rank.value,
              value: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageView(
                    height: 28,
                    width: 28,
                    assetImage: AppAssets.trophyIcon,
                    margin: EdgeInsets.only(),
                  ),
                ],
              ),
            ),
            DataGridCell(
              columnName: AchieversTableHeadings.name.value,
              value: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ImageView(
                    height: 28,
                    width: 28,
                    borderRadiusValue: 30,
                    isAvatar: true,
                    assetImage: '${e.profilePhoto}',
                    margin: EdgeInsets.zero,
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: GridHeading(title: e.firstName ?? defaultText),
                    ),
                  )
                ],
              ),
            ),
            DataGridCell(
              columnName: AchieversTableHeadings.sales.value,
              value: GridHeading(title: '${e.sales}'),
            ),
            DataGridCell(
              columnName: AchieversTableHeadings.demo.value,
              value: GridHeading(title: '${e.demo}'),
            ),
            DataGridCell(
              columnName: AchieversTableHeadings.turnover.value,
              value: GridHeading(title: '₹${e.turnover}'),
            ),
            DataGridCell(
              columnName: AchieversTableHeadings.appDownloads.value,
              value: GridHeading(title: '${e.appDownloads}'),
            ),
            DataGridCell(
              columnName: AchieversTableHeadings.performance.value,
              value: CircularPercentIndicator(
                radius: 16.0,
                lineWidth: 3,
                percent: (e.performance ?? 0).toDouble() / 100,
                center: Text(
                  '${(e.performance ?? 0).toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                progressColor: statusColor(value: e.level),
              ),
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

enum AchieversTableHeadings {
  rank('Rank'),
  name('Name'),
  sales('Sales'),
  demo('Demo'),
  turnover('Turnover'),
  appDownloads('App Downloads'),
  performance('Performance');

  final String value;

  const AchieversTableHeadings(this.value);
}
