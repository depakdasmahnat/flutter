import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../controllers/location/location_controller.dart';
import '../../../core/constant/colors.dart';
import '../../../core/constant/shadows.dart';
import '../../../models/dashboard/near_by_map_producers.dart';
import '../../../route/route_paths.dart';
import '../../../utils/widgets/image_view.dart';
import '../../home/view_producer.dart';

class MapProductCard extends StatefulWidget {
  const MapProductCard({
    Key? key,
    required this.isFirstCard,
    required this.data,
  }) : super(key: key);

  final bool? isFirstCard;
  final NearByMapProducersData? data;

  @override
  State<MapProductCard> createState() => _MapProductCardState();
}

class _MapProductCardState extends State<MapProductCard> {
  late bool isFirstCard = widget.isFirstCard ?? false;
  late NearByMapProducersData? data = widget.data;
  late bool? inWishList = true;

  animateToLocation() {
    LocationController controller = Provider.of<LocationController>(context, listen: false);
    debugPrint("Animating to ");

    double latitude = double.parse("${data?.latitude ?? 0}");
    double longitude = double.parse("${data?.longitude ?? 0}");
    debugPrint("Service Latitude => $latitude");
    debugPrint("Service Longitude => $longitude");
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 18,
    );

    if (controller.mapController != null) {
      controller.mapController?.showMarkerInfoWindow(MarkerId("$latitude$longitude"));
    }

    controller.setProducerMarkers(
      lat: latitude,
      long: longitude,
      id: data?.id,
      title: data?.name,
      snippet: data?.address,
      imageUrl: data?.profilePhoto,
      context: context,
    );

    controller.animateTo(context: context, cameraPosition: cameraPosition);
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const ObjectKey("nearByProducers"),
      onVisibilityChanged: (visibility) {
        var visiblePercentage = visibility.visibleFraction * 100;
        if (visiblePercentage >= 60 && mounted) {
          // animateToLocation();
          // debugPrint("Station Card Visible Fraction ${visibility.visibleFraction} of ${data?.name}");
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: CupertinoButton(
          padding: const EdgeInsets.only(top: 8),
          onPressed: () {
            animateToLocation();
            context.pushNamed(Routs.viewProducer, extra: ViewProducer(partnerId: "${data?.id}"));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageView(
                    height: 40,
                    width: 40,
                    borderRadiusValue: 70,
                    fit: BoxFit.contain,
                    backgroundColor: Colors.white,
                    networkImage: "${data?.profilePhoto}",
                    onTap: null,
                    boxShadow: primaryBoxShadow(),
                    margin: const EdgeInsets.only(right: 8),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data?.name ?? "",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontStyle: GoogleFonts.mulish().fontStyle,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 13,
                                color: Colors.grey.shade800,
                              ),
                              Expanded(
                                child: Text(
                                  "${data?.address}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "Pickup Available",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 22,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: [
                              if ((data?.reviews ?? 0) > 0)
                                storeDetail(
                                  icon: Icons.star,
                                  iconColor: Colors.amber,
                                  title: "${data?.rating} (${data?.reviews})",
                                ),
                              storeDetail(
                                icon: Icons.navigation_outlined,
                                iconColor: primaryColor,
                                title: "${data?.distanceLabel} Away",
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Divider(color: Colors.grey.shade100, height: 1, thickness: 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget storeDetail({
    required String? title,
    IconData? icon,
    Color? iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
      margin: const EdgeInsets.only(top: 6, right: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(
                (icon),
                size: 10,
                color: iconColor ?? Colors.grey.shade800,
              ),
            ),
          Text(
            "$title",
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade800,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
