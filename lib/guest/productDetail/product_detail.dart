import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/config/app_assets.dart';
import '../../../core/constant/constant.dart';
import '../../../core/constant/gradients.dart';
import '../../../utils/widgets/appbar.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/image_view.dart';
import '../home/home_screen.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  List details = [
    {
      'title': 'Aman Sahu',
      'image': AppAssets.guestProfile1,
      'subtitle': 'Clean and safe drinking water... ',
    },
    {
      'title': 'Raju',
      'image': AppAssets.guestProfile2,
      'subtitle': 'Clean and safe drinking water... ',
    },
    {
      'title': 'Raju',
      'image': AppAssets.guestProfile1,
      'subtitle': 'Clean and safe drinking water... ',
    },
    {
      'title': 'Aman Sahu',
      'image': AppAssets.guestProfile2,
      'subtitle': 'Clean and safe drinking water... ',
    },
  ];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(size.height * 0.06),
          child: CustomAppBar(
            showLeadICon: true,
            title: 'Details',
          )),
      body: ListView(
        children: [
          const FeedCardForDetail(
            index: 0,
          ),
          ListView.builder(
            itemCount: details.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(kPadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(details[index]['image']),
                    ),
                    SizedBox(
                      width: size.width * 0.02,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          details[index]['title'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          details[index]['subtitle'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
      bottomSheet: Padding(
        padding:
            const EdgeInsets.only(left: kPadding, right: kPadding, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage(AppAssets.guestProfile1),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Container(
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(width: 1, color: Color(0xFF383838)),
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: kPadding),
                        hintText: '',
                        border: InputBorder.none),
                  ),
                ),
              ),
            ),
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF1B1B1B), Color(0xFF282828)],
                  )),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Image.asset(
                  AppAssets.sendIcon,
                  height: size.height * 0.02,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeedCardForDetail extends StatelessWidget {
  const FeedCardForDetail({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.only(left: kPadding, right: kPadding, top: kPadding),
      decoration: BoxDecoration(
        gradient: feedsCardGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageView(
            height: MediaQuery.of(context).size.height * 0.25,
            borderRadiusValue: 16,
            margin: const EdgeInsets.all(12),
            fit: BoxFit.cover,
            assetImage: AppAssets.product1,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 12, right: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Best water purifier: 10 picks to ensure clean drinking water',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.start,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    '12 hr',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          FeedMenu(
                            icon: AppAssets.heartIcon,
                            value: '3',
                          ),
                          FeedMenu(
                            icon: AppAssets.chatIcon,
                            value: '12K',
                          ),
                          FeedMenu(
                            icon: AppAssets.shareIcon,
                          ),
                        ],
                      ),
                      FeedMenu(
                        lastMenu: true,
                        icon: AppAssets.bookmarkIcon,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class FeedMenu extends StatelessWidget {
  const FeedMenu({
    super.key,
    required this.icon,
    this.value,
    this.onTap,
    this.lastMenu,
  });

  final String icon;
  final String? value;
  final bool? lastMenu;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: lastMenu != true ? kPadding : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ImageView(
            height: 20,
            width: 20,
            borderRadiusValue: 0,
            color: Colors.white,
            margin: const EdgeInsets.only(right: 4),
            fit: BoxFit.contain,
            onTap: onTap,
            assetImage: icon,
          ),
          if (value != null)
            Text(
              '$value',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.start,
            ),
        ],
      ),
    );
  }
}
