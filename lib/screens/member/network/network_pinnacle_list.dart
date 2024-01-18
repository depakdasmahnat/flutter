import 'package:flutter/material.dart';
import 'package:mrwebbeast/utils/widgets/no_data_found.dart';

class NetworkPinnacleList extends StatefulWidget {
  const NetworkPinnacleList({super.key});

  @override
  State<NetworkPinnacleList> createState() => _NetworkPinnacleListState();
}

class _NetworkPinnacleListState extends State<NetworkPinnacleList> {
  @override
  Widget build(BuildContext context) {
    return const NoDataFound(message: 'Pinnacle List');
  }
}
