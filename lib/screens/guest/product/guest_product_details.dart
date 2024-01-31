import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/route/route_paths.dart';
import 'package:provider/provider.dart';

import '../../../controllers/guest_controller/guest_controller.dart';
import '../../../core/config/app_assets.dart';
import '../../../utils/widgets/custom_back_button.dart';
import '../../../utils/widgets/image_view.dart';

class GusetProductDetails extends StatefulWidget {
  String? productId;

  GusetProductDetails({super.key, this.productId});

  @override
  State<GusetProductDetails> createState() => _GusetProductDetailsState();
}

class _GusetProductDetailsState extends State<GusetProductDetails> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // await context.read<GuestControllers>().fetchResources(
      //     context: context, page: '1');
      await context.read<GuestControllers>().fetchProductDetail(
          context: context, productId: widget.productId ?? '');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Consumer<GuestControllers>(
        builder: (context, controller, child) {
          return controller.productLoader == false
              ? const Center(
                  child: CupertinoActivityIndicator(
                      animating: true,
                      radius: 20,
                      color: CupertinoColors.white),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        CarouselSlider(
                            options: CarouselOptions(
                              viewportFraction: 1,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              reverse: false,
                              autoPlay: true,
                              onPageChanged: (val, season) {
                                // bannerIndex = val;
                                setState(() {});
                              },
                              autoPlayInterval: const Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 1200),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: false,
                              enlargeFactor: 0.3,
                              scrollDirection: Axis.horizontal,
                            ),
                            items: List.generate(
                                controller.fetchproductDetail?.data?.images
                                        ?.length ??
                                    0, (bannerIndex) {
                              var data = controller
                                  .fetchproductDetail?.data?.images
                                  ?.elementAt(bannerIndex);

                              return Builder(
                                builder: (BuildContext context) {
                                  return ImageView(
                                    height: 400,
                                    width: size.width,
                                    networkImage: '$data',
                                    borderRadiusValue: 0,
                                    onTap: () {},
                                    fit: BoxFit.cover,
                                    margin:
                                        const EdgeInsets.only(bottom: kPadding),
                                  );
                                },
                              );
                            })),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: AppBar(
                            leading: const CustomBackButton(),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: kPadding, right: kPadding),
                        child: Text(
                          controller.fetchproductDetail?.data?.name ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: kPadding, right: kPadding),
                      child: DetailList(
                        leftTitle: 'Brand Kangen',
                        rightTitle: 'Water Machine Price',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: kPadding, right: kPadding),
                      child: DetailList(
                        leftTitle: 'Usage/Application',
                        rightTitle: 'Kangen Water Machine Price ',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: kPadding, right: kPadding),
                      child: DetailList(
                        leftTitle: 'Water Storage Capacity',
                        rightTitle: '4000 L',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: kPadding, right: kPadding),
                      child: DetailList(
                        leftTitle: 'Purification Capacity',
                        rightTitle: 'Kangen Water Machine Price',
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: kPadding),
                      child: Text(
                        'Product Description',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: kPadding, top: 10),
                      child: Text(
                        'CERTIFICATIONS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: kPadding, top: 5, right: kPadding),
                      child: Text(
                        controller.fetchproductDetail?.data?.description ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}

class DetailList extends StatelessWidget {
  String? leftTitle;
  String? rightTitle;

  DetailList({
    this.leftTitle,
    this.rightTitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              leftTitle ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              rightTitle ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        const Divider(
          thickness: 1,
          color: Color(0xFF1C1C1C),
        ),
      ],
    );
  }
}
