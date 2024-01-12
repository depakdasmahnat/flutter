import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/services/location/location_controller.dart';
import 'package:mrwebbeast/pages/home/countries_list.dart';

import 'package:provider/provider.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //todo:- Required if Location based Application
      context.read<LocationController>().determinePosition(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Home Screen'),
      ),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: CountriesList(),
          ),
        ],
      ),
    );
  }
}
