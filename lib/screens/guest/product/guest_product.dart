import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/core/route/route_paths.dart';
import 'package:provider/provider.dart';

import '../../../controllers/guest_controller/guest_controller.dart';
import '../../../utils/widgets/appbar.dart';
import 'guest_product_details.dart';

class GuestPoduct extends StatefulWidget {
  const GuestPoduct({super.key});

  @override
  State<GuestPoduct> createState() => _GuestPoductState();
}

class _GuestPoductState extends State<GuestPoduct> {
  int? value = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.read<GuestControllers>().guestProductLoader = false;
      await context.read<GuestControllers>().fetchProduct(context: context, page: '1');
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height * 0.06),
        child: CustomAppBar(
          showLeadICon: false,
          title: 'Products',
        ),
      ),
      body: Consumer<GuestControllers>(
        builder: (context, controller, child) {
          return GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: ((size.height - kToolbarHeight -20) / (size.height - kToolbarHeight - 20) / 1.4),
            // controller: ScrollController(keepScrollOffset: false),
            padding: const EdgeInsets.only(bottom: 100),
            shrinkWrap: true,
            // scrollDirection: Axis.vertical,
            children: List.generate(
              controller.fetchguestProduct?.data?.length ?? 0,
              (index) {
                return InkWell(
                    onTap: () {
                      value = index;
                      setState(() {});
                      context.push(Routs.guestProductDetail,
                          extra: GusetProductDetails(
                            productId: controller.fetchguestProduct?.data?[index].id.toString() ?? '',
                          ));
                    },
                    child: controller.guestProductLoader == false
                        ? const Center(
                            child: CupertinoActivityIndicator(radius: 15, color: CupertinoColors.white),
                          )
                        : ProductCard(
                            index: index,
                            value: value,
                            title: controller.fetchguestProduct?.data?[index].name,
                            subTitle: controller.fetchguestProduct?.data?[index].subHeading,
                            image: controller.fetchguestProduct?.data?[index].productImage,
                          ));
              },
            ),
          );
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  int? index;
  int? value;
  String? image;
  String? title;
  String? subTitle;

  ProductCard({
    this.index,
    this.value,
    this.image,
    this.title,
    this.subTitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(22)),
              gradient: index == value
                  ? primaryGradient
                  : const LinearGradient(
                      begin: Alignment(0.00, -1.00),
                      end: Alignment(0, 1),
                      colors: [Color(0xFF1B1B1B), Color(0xFF282828)],
                    )),
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                // height: size.height * 0.235,
                child: ClipRRect(
                  clipBehavior: Clip.antiAlias,
                  borderRadius: const BorderRadius.all(Radius.circular(17)),
                  child: Image.network(image ?? '',
                      fit: BoxFit.cover, height: size.height * 0.22,width: double.infinity,),
                ),
              ),
              // ImageView(
              //   borderRadiusValue: 16,
              //   margin: const EdgeInsets.all(12),
              //   fit:  BoxFit.contain,
              //   networkImage: image??'',
              // ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Text(
               title??'Purifier',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: index == value ? Colors.black : Colors.white,
                  fontSize: 14,

                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),

              Text(
                subTitle ?? '',
                style: TextStyle(
                  color: index == value ? Colors.black : Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
