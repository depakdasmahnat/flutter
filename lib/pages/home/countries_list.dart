import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import '../../models/localization/countries_data_model.dart';

Future<List<CountriesData>> loadCountries() async {
  String jsonString = await rootBundle.loadString('assets/json/world.json');
  List<dynamic> jsonList = json.decode(jsonString);
  return jsonList.map((json) => CountriesData.fromJson(json)).toList();
}

class CountriesList extends StatelessWidget {
  const CountriesList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CountriesData>>(
      future: loadCountries(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            cacheExtent: 100,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              CountriesData? data = snapshot.data?[index];

              return Column(
                children: [
                  ListTile(
                    leading: ImageView(
                      height: 45,
                      width: 45,
                      fullScreenMode: true,
                      assetImage: AppAssets.getCountryFlag(countryCode: '${data?.alpha2}'),
                    ),
                    title: Text('${data?.name}'),
                    subtitle: Text('${data?.alpha2}'),
                  ),
                  const Divider(
                    thickness: 1,
                    height: 0.5,
                  )
                ],
              );
            },
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
