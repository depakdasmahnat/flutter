import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../controllers/location/location_controller.dart';
import '../../core/constant/colors.dart';
import '../../models/location/location_model.dart';
import '../../models/location/places_detail_model.dart';
import '../../utils/widgets/custom_text_field.dart';
import '../../utils/widgets/loading_screen.dart';
import '../../utils/widgets/no_data_screen.dart';

class SearchLocationCards extends StatefulWidget {
  const SearchLocationCards({
    Key? key,
    this.radius,
    this.padding,
    required this.onLocationSelected,
    required this.onSearchChanged,
  }) : super(key: key);

  final num? radius;
  final EdgeInsets? padding;
  final Function(String?) onSearchChanged;
  final Function(PlacesDetailModel?) onLocationSelected;

  @override
  State<SearchLocationCards> createState() => _SearchLocationCardsState();
}

class _SearchLocationCardsState extends State<SearchLocationCards> {
  double? latitude;
  double? longitude;
  LatLng? latLng;
  late num defaultRadius = widget.radius ?? 100;
  TextEditingController searchCtrl = TextEditingController();
  LocationModel? locationModel;
  PlacesDetailModel? placesDetailModel;

  searchLocation() {
    LocationController location = Provider.of<LocationController>(context, listen: false);
    location.searchLocation(
      context: context,
      query: searchCtrl.text,
      radius: defaultRadius * 100,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      LocationController location = Provider.of<LocationController>(context, listen: false);
      locationModel = location.locationModel;
      if (locationModel == null) {
        searchLocation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    LocationController controller = Provider.of<LocationController>(context);
    LocationController location = Provider.of<LocationController>(context, listen: false);

    latitude = controller.latitude;
    longitude = controller.longitude;
    latLng = (latitude != null && longitude != null) ? LatLng(latitude!, longitude!) : null;
    locationModel = controller.locationModel;
    return Padding(
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            controller: searchCtrl,
            hintText: "Search Location",
            onChanged: (val) {
              widget.onSearchChanged(val);
              searchLocation();
              setState(() {});
            },
            onFieldSubmitted: (val) {
              searchLocation();
            },
            prefixIcon: IconButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                searchLocation();
              },
              icon: const Icon(
                Icons.search,
                color: Colors.grey,
              ),
            ),
            suffixIcon: searchCtrl.text.isEmpty
                ? null
                : IconButton(
                    onPressed: () {
                      setState(() {
                        searchCtrl.clear();
                      });
                    },
                    icon: const Icon(
                      CupertinoIcons.multiply_circle_fill,
                      color: secondaryColor,
                    ),
                  ),
            borderColor: Colors.grey.shade200,
            margin: const EdgeInsets.only(bottom: 16),
          ),
          location.loadingSearchLocation == true
              ? SizedBox(
                  height: size.height * 0.4,
                  child: const LoadingScreen(
                    message: "Searching Location...",
                  ),
                )
              : (locationModel?.predictions?.haveData == true)
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: locationModel?.predictions?.length ?? 0,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var data = locationModel?.predictions?.elementAt(index);
                        return popularDestinations(
                          context: context,
                          text: data?.description,
                          placeId: data?.placeId,
                        );
                      },
                    )
                  : SizedBox(
                      height: size.height * 0.4,
                      child: const NoDataScreen(
                        color: primaryColor,
                        message: "No Locations Found",
                      ),
                    ),
        ],
      ),
    );
  }

  popularDestinations({
    required BuildContext context,
    required String? text,
    required String? placeId,
  }) {
    return InkWell(
      onTap: () async {
        LocationController location = Provider.of<LocationController>(context, listen: false);
        await location
            .fetchPlacesDetail(
          context: context,
          placeId: placeId,
        )
            .then((value) async {
          placesDetailModel = value;
          setState(() {});
          widget.onLocationSelected(placesDetailModel);

          return placesDetailModel;
        });
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 14, bottom: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(
                    CupertinoIcons.location_solid,
                    color: primaryColor,
                    size: 20,
                  ),
                ),
                Expanded(
                  child: Text(
                    "$text",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(color: Colors.grey.shade300, height: 1),
        ],
      ),
    );
  }
}
