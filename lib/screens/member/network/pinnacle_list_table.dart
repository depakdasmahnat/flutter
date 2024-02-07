import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import 'package:mrwebbeast/utils/widgets/no_data_found.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/member/network/pinnacle_list_model.dart';

class NetworkPinnacleTable extends StatefulWidget {
  /// Creates the home page.
  const NetworkPinnacleTable({super.key, this.pinnacleList});

  final List<PinnacleListData>? pinnacleList;

  @override
  _NetworkPinnacleTableState createState() => _NetworkPinnacleTableState();
}

class _NetworkPinnacleTableState extends State<NetworkPinnacleTable> {
  late List<PinnacleListData>? pinnacles = widget.pinnacleList;
  EmployeeDataSource? employeeDataSource;
  late List<PinnacleListData>? getPinnacles = widget.pinnacleList;

  @override
  void initState() {
    super.initState();
    if (pinnacles != null) {
      employeeDataSource = EmployeeDataSource(employeeData: pinnacles);
    }
  }

  @override
  Widget build(BuildContext context) {
    return employeeDataSource != null
        ? SfDataGrid(
            footerHeight: 100,
            footer: const SizedBox(),
            source: employeeDataSource!,
            shrinkWrapRows: true,
            columns: [
              GridColumn(
                maximumWidth: 50,
                columnName: PinnaclesHeadings.user.value,
                label: GridHeading(title: PinnaclesHeadings.user.value),
              ),
              GridColumn(
                columnName: PinnaclesHeadings.name.value,
                label: GridHeading(title: PinnaclesHeadings.name.value),
              ),
              GridColumn(
                columnName: PinnaclesHeadings.target.value,
                label: GridHeading(title: PinnaclesHeadings.target.value),
              ),
              GridColumn(
                columnName: PinnaclesHeadings.pending.value,
                label: GridHeading(title: PinnaclesHeadings.pending.value),
              ),
              GridColumn(
                columnName: PinnaclesHeadings.conversion.value,
                label: GridHeading(title: PinnaclesHeadings.conversion.value),
              ),
              GridColumn(
                columnName: PinnaclesHeadings.leads.value,
                label: GridHeading(title: PinnaclesHeadings.leads.value),
              ),
              GridColumn(
                columnName: PinnaclesHeadings.demo.value,
                label: GridHeading(title: PinnaclesHeadings.demo.value),
              ),
              GridColumn(
                columnName: PinnaclesHeadings.training.value,
                label: GridHeading(title: PinnaclesHeadings.training.value),
              ),
              GridColumn(
                columnName: PinnaclesHeadings.progress.value,
                label: GridHeading(title: PinnaclesHeadings.progress.value),
              ),
              GridColumn(
                columnName: PinnaclesHeadings.call.value,
                label: GridHeading(title: PinnaclesHeadings.call.value),
              ),
              GridColumn(
                columnName: PinnaclesHeadings.achievement.value,
                label: GridHeading(title: PinnaclesHeadings.achievement.value),
              ),
            ],
          )
        : const NoDataFound();
  }
}

class EmployeeDataSource extends DataGridSource {
  String defaultText = '__';

  /// Creates the employee data source class with required details.
  EmployeeDataSource({required List<PinnacleListData>? employeeData}) {
    _employeeData = employeeData!.map<DataGridRow>(
      (data) {
        return DataGridRow(
          cells: [
            DataGridCell(
              columnName: PinnaclesHeadings.user.value,
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
            DataGridCell(
              columnName: PinnaclesHeadings.name.value,
              value: GridHeading(title: data.name ?? defaultText),
            ),
            DataGridCell(
              columnName: PinnaclesHeadings.target.value,
              value: GridHeading(title: '${data.target ?? defaultText}'),
            ),
            DataGridCell(
              columnName: PinnaclesHeadings.pending.value,
              value: GridHeading(title: '${data.pending ?? defaultText}'),
            ),
            DataGridCell(
              columnName: PinnaclesHeadings.conversion.value,
              value: GridHeading(title: '${data.conversion ?? 0}%'),
            ),
            DataGridCell(
              columnName: PinnaclesHeadings.leads.value,
              value: GridHeading(title: '${data.lists ?? defaultText}'),
            ),
            DataGridCell(
              columnName: PinnaclesHeadings.demo.value,
              value: GridHeading(title: '${data.demo ?? defaultText}'),
            ),
            DataGridCell(
              columnName: PinnaclesHeadings.training.value,
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
            DataGridCell(
              columnName: PinnaclesHeadings.progress.value,
              value: CircularPercentIndicator(
                radius: 16.0,
                lineWidth: 3,
                percent: (data.progress ?? 0).toDouble() / 100,
                center: Text(
                  '${(data.progress ?? 0).toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                progressColor: statusColor(value: data.training),
              ),
            ),
            DataGridCell(
              columnName: PinnaclesHeadings.call.value,
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
            DataGridCell(
              columnName: PinnaclesHeadings.achievement.value,
              value: GridHeading(title: data.achievement ?? defaultText),
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

enum PinnaclesHeadings {
  user('User'),
  name('Name'),
  target('Target'),
  pending('Pending'),
  conversion('Conversion'),
  leads('Leads'),
  demo('Demo'),
  training('Training'),
  progress('Progress'),
  call('Call'),
  achievement('Achievement');

  final String value;

  const PinnaclesHeadings(this.value);
}

class PinnacleData {
  final String? profilePic;
  final String? name;
  final num? target;
  final num? pending;
  final num? conversion;
  final num? leads;
  final num? demo;
  final num? training;
  final num? progress;
  final String call;
  final String achievement;

  PinnacleData({
    required this.profilePic,
    required this.name,
    required this.target,
    required this.pending,
    required this.conversion,
    required this.leads,
    required this.demo,
    required this.training,
    required this.progress,
    required this.call,
    required this.achievement,
  });
}
