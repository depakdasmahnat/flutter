import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import 'package:mrwebbeast/utils/widgets/no_data_found.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/member/network/pinnacle_list_model.dart';

class ServicesTable extends StatefulWidget {
  /// Creates the home page.
  const ServicesTable({super.key, this.pinnacleList, this.verticalScrollPhysics});

  final List<PinnacleListData>? pinnacleList;
  final ScrollPhysics? verticalScrollPhysics;

  @override
  _ServicesTableState createState() => _ServicesTableState();
}

class _ServicesTableState extends State<ServicesTable> {
  late List<PinnacleListData>? pinnacles = widget.pinnacleList;
  late ScrollPhysics? verticalScrollPhysics = widget.verticalScrollPhysics;

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
            verticalScrollPhysics: verticalScrollPhysics ?? const BouncingScrollPhysics(),
            source: employeeDataSource!,
            shrinkWrapRows: true,
            columns: [
              GridColumn(
                maximumWidth: 50,
                columnName: ServiceHeadings.no.value,
                label: GridHeading(title: ServiceHeadings.no.value),
              ),
              GridColumn(
                columnName: ServiceHeadings.city.value,
                label: GridHeading(title: ServiceHeadings.city.value),
              ),
              GridColumn(
                columnName: ServiceHeadings.name.value,
                label: GridHeading(title: ServiceHeadings.name.value),
              ),
              GridColumn(
                columnName: ServiceHeadings.number.value,
                label: GridHeading(title: ServiceHeadings.number.value),
              ),
              GridColumn(
                columnName: ServiceHeadings.number2.value,
                label: GridHeading(title: ServiceHeadings.number2.value),
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
              columnName: ServiceHeadings.no.value,
              value: GridHeading(title: '${data.pending ?? defaultText}'),
            ),
            DataGridCell(
              columnName: ServiceHeadings.city.value,
              value: GridHeading(title: '${data.target ?? defaultText}'),
            ),
            DataGridCell(
              columnName: ServiceHeadings.name.value,
              value: Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: GridHeading(title: data.name ?? defaultText),
                ),
              ),
            ),
            DataGridCell(
              columnName: ServiceHeadings.number.value,
              value: GridHeading(title: '${data.conversion ?? 0}%'),
            ),
            DataGridCell(
              columnName: ServiceHeadings.number2.value,
              value: GridHeading(title: '${data.lists ?? defaultText}'),
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

enum ServiceHeadings {
  no('No'),
  city('City'),
  name('Name'),
  number('Number'),
  number2('Number 2');

  final String value;

  const ServiceHeadings(this.value);
}

class ServiceData {
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

  ServiceData({
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
