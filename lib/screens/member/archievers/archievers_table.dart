import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import 'package:mrwebbeast/utils/widgets/no_data_found.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

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
                label: GridHeading(title: AchieversTableHeadings.name.value),
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
                columnName: AchieversTableHeadings.closing.value,
                label: GridHeading(title: AchieversTableHeadings.closing.value),
              ),
              GridColumn(
                minimumWidth: 140,
                columnName: AchieversTableHeadings.appDownloads.value,
                label: GridHeading(title: AchieversTableHeadings.appDownloads.value),
              ),
              GridColumn(
                columnName: AchieversTableHeadings.level.value,
                label: GridHeading(title: AchieversTableHeadings.level.value),
              ),
              GridColumn(
                minimumWidth: 140,
                columnName: AchieversTableHeadings.achievement.value,
                label: GridHeading(title: AchieversTableHeadings.achievement.value),
              ),
            ],
          )
        : const NoDataFound();
  }
}

class EmployeeDataSource extends DataGridSource {
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
                children: [
                  ImageView(
                    height: 28,
                    width: 28,
                    borderRadiusValue: 30,
                    isAvatar: true,
                    assetImage: '${e.profile_pic}',
                    margin: const EdgeInsets.only(right: 4),
                  ),
                  GridHeading(title: '${e.firstName}'),
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
              columnName: AchieversTableHeadings.closing.value,
              value: GridHeading(title: '${e.closing}'),
            ),
            DataGridCell(
              columnName: AchieversTableHeadings.appDownloads.value,
              value: GridHeading(title: '${e.appDownloads}'),
            ),
            DataGridCell(
              columnName: AchieversTableHeadings.level.value,
              value: GridHeading(title: '${e.level}'),
            ),
            DataGridCell(
              columnName: AchieversTableHeadings.achievement.value,
              value: GridHeading(title: '${e.achievement}'),
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
  const GridHeading({super.key, this.title});

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8),
      alignment: Alignment.center,
      child: Row(
        children: [
          Text(
            '$title',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
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
  closing('Closing'),
  appDownloads('App Downloads'),
  level('Level'),
  achievement('Achievement');

  final String value;

  const AchieversTableHeadings(this.value);
}
