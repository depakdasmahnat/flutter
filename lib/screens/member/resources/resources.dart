import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_assets.dart';
import '../../../core/constant/constant.dart';
import '../../../core/constant/gradients.dart';
import '../../../core/route/route_paths.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/image_view.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  List item = [
    {'image': AppAssets.resources, 'title': 'Business Images'},
    {'image': AppAssets.pdf, 'title': 'Business Images'},
    {'image': AppAssets.pdf, 'title': 'Demo Video'},
    {'image': AppAssets.pdf, 'title': 'Trainings PDFs'}
  ];

  double? trainingProgress = 75;

  int dashBoardIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resources'),
      ),
      body: ListView(
        children: [
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: kPadding, right: kPadding, bottom: kPadding),
                child: Text(
                  'Products',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 300,
            child: ListView.builder(
              itemCount: 8,
              shrinkWrap: true,
              padding: const EdgeInsets.only(left: kPadding),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return ProductCard(index: index);
              },
            ),
          ),
          const CustomTextField(
            hintText: 'Search',
            readOnly: true,
            hintStyle: TextStyle(color: Colors.white),
            prefixIcon: ImageView(
              height: 20,
              width: 20,
              borderRadiusValue: 0,
              color: Colors.white,
              margin: EdgeInsets.only(left: kPadding, right: kPadding),
              fit: BoxFit.contain,
              assetImage: AppAssets.searchIcon,
            ),
            margin: EdgeInsets.only(left: kPadding, right: kPadding, top: kPadding, bottom: kPadding),
          ),
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: kPadding, right: kPadding, bottom: kPadding),
                child: Text(
                  'All Videos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio:
                ((size.height - kToolbarHeight - 24) / (size.height - kToolbarHeight - 24) / 0.85),
            controller: ScrollController(keepScrollOffset: false),
            padding: const EdgeInsets.only(bottom: 100, left: 16, right: 16, top: 8),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: List.generate(
              item.length,
              (index) {
                return InkWell(
                    onTap: () {
                      context.push(Routs.resourceAndDemo);
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(18))
                          // image: DecorationImage(
                          //   image: AssetImage(AppAssets.geustProduct,),
                          //       fit: BoxFit.contain
                          // )
                          ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: Image.asset(
                                item[index]['image'],
                                fit: BoxFit.cover,
                              ),
                            ),
                            Text(
                              item[index]['title'],
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500, height: 2),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final int? index;

  const ProductCard({
    this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 200,
          margin: const EdgeInsets.only(right: kPadding),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(22)),
            gradient: index == 0 ? primaryGradient : inActiveGradient,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const ImageView(
                  assetImage: AppAssets.geustProduct,
                  margin: EdgeInsets.zero,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Reverse Osmosis PVC Kangen Water Mach...',
                    style: TextStyle(
                      color: index == 0 ? Colors.black : Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '₹ 3,43,000/',
                        style: TextStyle(
                          color: index == 0 ? Colors.black : Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Unit',
                        style: TextStyle(
                          color: index == 0 ? Colors.black : Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
