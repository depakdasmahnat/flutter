import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../core/constant/colors.dart';
import '../../../models/member/dashboard/dashboard_states_model.dart';

class PerformanceGraph extends StatelessWidget {
  const PerformanceGraph({super.key, this.analytics});

  final List<DashboardAnalytics>? analytics;

  @override
  Widget build(BuildContext context) {
    return analytics.haveData
        ? SfCartesianChart(
            plotAreaBorderWidth: 0,
            primaryXAxis: CategoryAxis(
              isVisible: true,
              axisLine: const AxisLine(width: 1, color: Colors.white),
              labelStyle: const TextStyle(color: Colors.white, fontSize: 8),
              majorGridLines: const MajorGridLines(color: Colors.white, width: 0),
              borderColor: Colors.white,
            ),
            // primaryYAxis: CategoryAxis(
            //   isVisible: true,
            //   arrangeByIndex: true,
            //   axisLine: const AxisLine(width: 1, color: Colors.transparent),
            //   labelStyle: const TextStyle(color: Colors.white, fontSize: 8),
            //   majorGridLines: const MajorGridLines(
            //     color: Colors.white,
            //   ),
            //   borderColor: Colors.white,
            // ),

            tooltipBehavior: TooltipBehavior(enable: true),
            backgroundColor: Colors.transparent,
            series: <CartesianSeries>[
              SplineSeries<DashboardAnalytics?, String>(
                dataSource: analytics!,
                splineType: SplineType.cardinal,
                cardinalSplineTension: 2,
                color: const Color(0xffD1F35A),
                width: 3,
                dataLabelMapper: (DashboardAnalytics? sales, _) => '${sales?.xaxis}',
                xValueMapper: (DashboardAnalytics? sales, _) => '${sales?.xaxis}',
                yValueMapper: (DashboardAnalytics? sales, _) => num.tryParse('${sales?.performance}') ?? 0,
                markerSettings: const MarkerSettings(
                  isVisible: true,
                  color: primaryColor,
                  borderColor: Colors.white,
                ),
                enableTooltip: true,
                dataLabelSettings: const DataLabelSettings(),
              ),
            ],
          )
        : const SizedBox();
  }
}

class ChartData {
  ChartData(this.day, this.value);

  final String? day;
  final double? value;
}
