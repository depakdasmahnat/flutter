import 'package:flutter/material.dart';
import 'package:mrwebbeast/utils/widgets/no_data_found.dart';

class NetworkProjection extends StatefulWidget {
  const NetworkProjection({super.key});

  @override
  State<NetworkProjection> createState() => _NetworkProjectionState();
}

class _NetworkProjectionState extends State<NetworkProjection> {
  @override
  Widget build(BuildContext context) {
    return const NoDataFound(message: 'Projection View');
  }
}
