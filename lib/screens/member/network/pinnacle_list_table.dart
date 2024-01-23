import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class NetworkPinnacleTable extends StatefulWidget {
  /// Creates the home page.
  const NetworkPinnacleTable({super.key});

  @override
  _NetworkPinnacleTableState createState() => _NetworkPinnacleTableState();
}

class _NetworkPinnacleTableState extends State<NetworkPinnacleTable> {
  List<PinnacleData> pinnacles = <PinnacleData>[];
  late EmployeeDataSource employeeDataSource;
  List<PinnacleData> getPinnacles = [
    PinnacleData(
      profilePic: 'JohnDoe.jpg',
      name: 'John Doe',
      target: 30,
      pending: 30,
      conversion: 85,
      leads: 12,
      demo: 6,
      training: 20,
      progress: 45,
      call: '+91 9876543210',
      achievement: '6A2',
    ),
    PinnacleData(
      profilePic: 'JaneSmith.jpg',
      name: 'Jane Smith',
      target: 40,
      pending: 25,
      conversion: 75,
      leads: 15,
      demo: 8,
      training: 18,
      progress: 50,
      call: '+91 9876543211',
      achievement: '5B1',
    ),
    PinnacleData(
      profilePic: 'BobJohnson.jpg',
      name: 'Bob Johnson',
      target: 35,
      pending: 20,
      conversion: 80,
      leads: 10,
      demo: 5,
      training: 22,
      progress: 40,
      call: '+91 9876543212',
      achievement: '7C3',
    ),
    PinnacleData(
      profilePic: 'AliceWilliams.jpg',
      name: 'Alice Williams',
      target: 50,
      pending: 15,
      conversion: 90,
      leads: 18,
      demo: 10,
      training: 25,
      progress: 55,
      call: '+91 9876543213',
      achievement: '8A1',
    ),
    PinnacleData(
      profilePic: 'CharlieBrown.jpg',
      name: 'Charlie Brown',
      target: 45,
      pending: 18,
      conversion: 78,
      leads: 14,
      demo: 7,
      training: 19,
      progress: 48,
      call: '+91 9876543214',
      achievement: '5B2',
    ),
    PinnacleData(
      profilePic: 'EvaMiller.jpg',
      name: 'Eva Miller',
      target: 32,
      pending: 22,
      conversion: 82,
      leads: 11,
      demo: 6,
      training: 21,
      progress: 42,
      call: '+91 9876543219',
      achievement: '4C1',
    ),
    PinnacleData(
      profilePic: 'JohnDoe.jpg',
      name: 'John Doe',
      target: 30,
      pending: 30,
      conversion: 85,
      leads: 12,
      demo: 6,
      training: 20,
      progress: 45,
      call: '+91 9876543210',
      achievement: '6A2',
    ),
    PinnacleData(
      profilePic: 'JaneSmith.jpg',
      name: 'Jane Smith',
      target: 40,
      pending: 25,
      conversion: 75,
      leads: 15,
      demo: 8,
      training: 18,
      progress: 50,
      call: '+91 9876543211',
      achievement: '5B1',
    ),
    PinnacleData(
      profilePic: 'BobJohnson.jpg',
      name: 'Bob Johnson',
      target: 35,
      pending: 20,
      conversion: 80,
      leads: 10,
      demo: 5,
      training: 22,
      progress: 40,
      call: '+91 9876543212',
      achievement: '7C3',
    ),
    PinnacleData(
      profilePic: 'AliceWilliams.jpg',
      name: 'Alice Williams',
      target: 50,
      pending: 15,
      conversion: 90,
      leads: 18,
      demo: 10,
      training: 25,
      progress: 55,
      call: '+91 9876543213',
      achievement: '8A1',
    ),
    PinnacleData(
      profilePic: 'CharlieBrown.jpg',
      name: 'Charlie Brown',
      target: 45,
      pending: 18,
      conversion: 78,
      leads: 14,
      demo: 7,
      training: 19,
      progress: 48,
      call: '+91 9876543214',
      achievement: '5B2',
    ),
    PinnacleData(
      profilePic: 'EvaMiller.jpg',
      name: 'Eva Miller',
      target: 32,
      pending: 22,
      conversion: 82,
      leads: 11,
      demo: 6,
      training: 21,
      progress: 42,
      call: '+91 9876543219',
      achievement: '4C1',
    ),
    PinnacleData(
      profilePic: 'JohnDoe.jpg',
      name: 'John Doe',
      target: 30,
      pending: 30,
      conversion: 85,
      leads: 12,
      demo: 6,
      training: 20,
      progress: 45,
      call: '+91 9876543210',
      achievement: '6A2',
    ),
    PinnacleData(
      profilePic: 'JaneSmith.jpg',
      name: 'Jane Smith',
      target: 40,
      pending: 25,
      conversion: 75,
      leads: 15,
      demo: 8,
      training: 18,
      progress: 50,
      call: '+91 9876543211',
      achievement: '5B1',
    ),
    PinnacleData(
      profilePic: 'BobJohnson.jpg',
      name: 'Bob Johnson',
      target: 35,
      pending: 20,
      conversion: 80,
      leads: 10,
      demo: 5,
      training: 22,
      progress: 40,
      call: '+91 9876543212',
      achievement: '7C3',
    ),
    PinnacleData(
      profilePic: 'AliceWilliams.jpg',
      name: 'Alice Williams',
      target: 50,
      pending: 15,
      conversion: 90,
      leads: 18,
      demo: 10,
      training: 25,
      progress: 55,
      call: '+91 9876543213',
      achievement: '8A1',
    ),
    PinnacleData(
      profilePic: 'CharlieBrown.jpg',
      name: 'Charlie Brown',
      target: 45,
      pending: 18,
      conversion: 78,
      leads: 14,
      demo: 7,
      training: 19,
      progress: 48,
      call: '+91 9876543214',
      achievement: '5B2',
    ),
    PinnacleData(
      profilePic: 'EvaMiller.jpg',
      name: 'Eva Miller',
      target: 32,
      pending: 22,
      conversion: 82,
      leads: 11,
      demo: 6,
      training: 21,
      progress: 42,
      call: '+91 9876543219',
      achievement: '4C1',
    ),
  ];

  @override
  void initState() {
    super.initState();
    pinnacles = getPinnacles;
    employeeDataSource = EmployeeDataSource(employeeData: pinnacles);
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      footerHeight: 100,
      footer: const SizedBox(),
      source: employeeDataSource,
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
    );
  }
}

class EmployeeDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  EmployeeDataSource({required List<PinnacleData> employeeData}) {
    _employeeData = employeeData.map<DataGridRow>(
      (data) {
        return DataGridRow(
          cells: [
            DataGridCell(
              columnName: PinnaclesHeadings.user.value,
              value: ImageView(
                height: 24,
                width: 24,
                isAvatar: true,
                assetImage: '${data.profilePic}',
                margin: const EdgeInsets.only(right: 4),
              ),
            ),
            DataGridCell(
              columnName: PinnaclesHeadings.name.value,
              value: GridHeading(title: '${data.name}'),
            ),
            DataGridCell(
              columnName: PinnaclesHeadings.target.value,
              value: GridHeading(title: '${data.target}'),
            ),
            DataGridCell(
              columnName: PinnaclesHeadings.pending.value,
              value: GridHeading(title: '${data.pending}'),
            ),
            DataGridCell(
              columnName: PinnaclesHeadings.conversion.value,
              value: GridHeading(title: '${data.conversion}%'),
            ),
            DataGridCell(
              columnName: PinnaclesHeadings.leads.value,
              value: GridHeading(title: '${data.leads}'),
            ),
            DataGridCell(
              columnName: PinnaclesHeadings.demo.value,
              value: GridHeading(title: '${data.demo}'),
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
                progressColor: statusColor(percentage: data.training),
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
                progressColor: statusColor(percentage: data.training),
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
                    onTap: () {},
                    padding: const EdgeInsets.all(8),
                  ),
                ],
              ),
            ),
            DataGridCell(
              columnName: PinnaclesHeadings.achievement.value,
              value: GridHeading(title: data.achievement),
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
