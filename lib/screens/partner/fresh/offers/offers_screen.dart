import 'package:flutter/material.dart';
import 'package:gaas/route/route_paths.dart';
import 'package:gaas/screens/partner/fresh/offers/add_offer.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../controllers/partner/offers/offers_controller.dart';
import '../../../../models/partner/offers/partner_offers_model.dart';
import '../../../../utils/widgets/loading_screen.dart';
import '../../../../utils/widgets/no_data_screen.dart';
import '../../utils/partner_app_bar.dart';
import 'utils/offer_card.dart';

class PartnerOffersScreen extends StatefulWidget {
  const PartnerOffersScreen({Key? key}) : super(key: key);

  @override
  State<PartnerOffersScreen> createState() => _PartnerOffersScreenState();
}

class _PartnerOffersScreenState extends State<PartnerOffersScreen> {
  bool onlineStatus = true;
  int? maxNoOfTrainees = 5;

  TextEditingController searchKey = TextEditingController();
  List<PartnerOffersData>? gymOffersData;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      OffersController offersController = Provider.of<OffersController>(context, listen: false);
      offersController.fetchOffers(context: context, isRefresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    OffersController offersController = Provider.of<OffersController>(context);
    gymOffersData = offersController.gymOffersData;

    return Scaffold(
      appBar: partnerAppBar(
          context: context,
          title: "Offers",
          onBackPress: () {
            context.pop();
          }),
      body: SmartRefresher(
        controller: offersController.gymOffersController,
        enablePullUp: true,
        enablePullDown: true,
        onRefresh: () async {
          if (mounted) {
            offersController.fetchOffers(context: context, isRefresh: true, searchKey: searchKey.text);
          }
        },
        onLoading: () async {
          if (mounted) {
            offersController.fetchOffers(context: context, loadingNext: true, searchKey: searchKey.text);
          }
        },
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(bottom: size.height * 0.1),
          physics: const BouncingScrollPhysics(),
          children: [
            offersController.loadingOffers
                ? const LoadingScreen(
                    message: "Loading Offers",
                  )
                : (gymOffersData != null && gymOffersData?.isNotEmpty == true)
                    ? ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: gymOffersData?.length ?? 0,
                        itemBuilder: (context, index) {
                          var data = gymOffersData?.elementAt(index);

                          return GestureDetector(
                            onTap: () {
                              context.pushNamed(Routs.addOffer, extra: AddOffer(index: index, offersData: data));
                            },
                            child: OfferCard(
                              index: index,
                              offerData: data,
                            ),
                          );
                        },
                      )
                    : const NoDataScreen(message: "No Offers Found"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(Routs.addOffer);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
