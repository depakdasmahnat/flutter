import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class AchieversTable extends StatefulWidget {
  /// Creates the home page.
  const AchieversTable({super.key});

  @override
  _AchieversTableState createState() => _AchieversTableState();
}

class _AchieversTableState extends State<AchieversTable> {
  List<Employee> employees = <Employee>[];
  late EmployeeDataSource employeeDataSource;

  @override
  void initState() {
    super.initState();
    employees = getEmployeeData();
    employeeDataSource = EmployeeDataSource(employeeData: employees);
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      source: employeeDataSource,
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
    );
  }

  List<Employee> getEmployeeData() {
    return [
      Employee(
        rank: AppAssets.trophyIcon,
        profilePic: AppAssets.avatarImage,
        name: 'John Doe',
        sales: 150,
        demo: 20,
        closing: 10,
        appDownloads: 500,
        level: 3,
        achievement: 'Top Performer',
      ),
      Employee(
        rank: AppAssets.trophyIcon,
        profilePic: AppAssets.avatarImage,
        name: 'Alice Smith',
        sales: 100,
        demo: 15,
        closing: 5,
        appDownloads: 300,
        level: 2,
        achievement: 'Exceeded Targets',
      ),
      Employee(
        rank: AppAssets.trophyIcon,
        profilePic: AppAssets.avatarImage,
        name: 'John Doe',
        sales: 150,
        demo: 20,
        closing: 10,
        appDownloads: 500,
        level: 3,
        achievement: 'Top Performer',
      ),
      Employee(
        rank: AppAssets.trophyIcon,
        profilePic: AppAssets.avatarImage,
        name: 'Alice Smith',
        sales: 100,
        demo: 15,
        closing: 5,
        appDownloads: 300,
        level: 2,
        achievement: 'Exceeded Targets',
      ),
      Employee(
        rank: AppAssets.trophyIcon,
        profilePic: AppAssets.avatarImage,
        name: 'John Doe',
        sales: 150,
        demo: 20,
        closing: 10,
        appDownloads: 500,
        level: 3,
        achievement: 'Top Performer',
      ),
      Employee(
        rank: AppAssets.trophyIcon,
        profilePic: AppAssets.avatarImage,
        name: 'Alice Smith',
        sales: 100,
        demo: 15,
        closing: 5,
        appDownloads: 300,
        level: 2,
        achievement: 'Exceeded Targets',
      ),
      Employee(
        rank: AppAssets.trophyIcon,
        profilePic: AppAssets.avatarImage,
        name: 'John Doe',
        sales: 150,
        demo: 20,
        closing: 10,
        appDownloads: 500,
        level: 3,
        achievement: 'Top Performer',
      ),
      Employee(
        rank: AppAssets.trophyIcon,
        profilePic: AppAssets.avatarImage,
        name: 'Alice Smith',
        sales: 100,
        demo: 15,
        closing: 5,
        appDownloads: 300,
        level: 2,
        achievement: 'Exceeded Targets',
      ),
      Employee(
        rank: AppAssets.trophyIcon,
        profilePic: AppAssets.avatarImage,
        name: 'John Doe',
        sales: 150,
        demo: 20,
        closing: 10,
        appDownloads: 500,
        level: 3,
        achievement: 'Top Performer',
      ),
      Employee(
        rank: AppAssets.trophyIcon,
        profilePic: AppAssets.avatarImage,
        name: 'Alice Smith',
        sales: 100,
        demo: 15,
        closing: 5,
        appDownloads: 300,
        level: 2,
        achievement: 'Exceeded Targets',
      ),
      Employee(
        rank: AppAssets.trophyIcon,
        profilePic: AppAssets.avatarImage,
        name: 'John Doe',
        sales: 150,
        demo: 20,
        closing: 10,
        appDownloads: 500,
        level: 3,
        achievement: 'Top Performer',
      ),
      Employee(
        rank: AppAssets.trophyIcon,
        profilePic: AppAssets.avatarImage,
        name: 'Alice Smith',
        sales: 100,
        demo: 15,
        closing: 5,
        appDownloads: 300,
        level: 2,
        achievement: 'Exceeded Targets',
      ),
      Employee(
        rank: AppAssets.trophyIcon,
        profilePic: AppAssets.avatarImage,
        name: 'John Doe',
        sales: 150,
        demo: 20,
        closing: 10,
        appDownloads: 500,
        level: 3,
        achievement: 'Top Performer',
      ),
      Employee(
        rank: AppAssets.trophyIcon,
        profilePic: AppAssets.avatarImage,
        name: 'Alice Smith',
        sales: 100,
        demo: 15,
        closing: 5,
        appDownloads: 300,
        level: 2,
        achievement: 'Exceeded Targets',
      ),
      Employee(
        rank: AppAssets.trophyIcon,
        profilePic: AppAssets.avatarImage,
        name: 'John Doe',
        sales: 150,
        demo: 20,
        closing: 10,
        appDownloads: 500,
        level: 3,
        achievement: 'Top Performer',
      ),
      Employee(
        rank: AppAssets.trophyIcon,
        profilePic: AppAssets.avatarImage,
        name: 'Alice Smith',
        sales: 100,
        demo: 15,
        closing: 5,
        appDownloads: 300,
        level: 2,
        achievement: 'Exceeded Targets',
      ),
    ];
  }
}

class EmployeeDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  EmployeeDataSource({required List<Employee> employeeData}) {
    _employeeData = employeeData.map<DataGridRow>(
      (e) {
        return DataGridRow(
          cells: [
            DataGridCell(
              columnName: AchieversTableHeadings.rank.value,
              value: ImageView(
                height: 24,
                width: 24,
                assetImage: '${e.rank}',
                margin: const EdgeInsets.only(),
              ),
            ),
            DataGridCell(
              columnName: AchieversTableHeadings.name.value,
              value: Row(
                children: [
                  ImageView(
                    height: 24,
                    width: 24,
                    assetImage: '${e.profilePic}',
                    margin: const EdgeInsets.only(right: 4),
                  ),
                  GridHeading(title: '${e.name}'),
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

class Employee {
  final String? rank;
  final String? profilePic;
  final String? name;
  final num? sales;
  final num? demo;
  final num? closing;
  final num? appDownloads;
  final num? level;
  final String? achievement;

  Employee(
      {required this.rank,
      required this.profilePic,
      required this.name,
      required this.sales,
      required this.demo,
      required this.closing,
      required this.appDownloads,
      required this.level,
      required this.achievement});
}
