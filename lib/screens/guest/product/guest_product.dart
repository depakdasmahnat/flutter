import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/core/route/route_paths.dart';

import '../../../utils/widgets/appbar.dart';

class GuestPoduct extends StatefulWidget {
  const GuestPoduct({super.key});

  @override
  State<GuestPoduct> createState() => _GuestPoductState();
}

class _GuestPoductState extends State<GuestPoduct> {
  int? value =0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(size.height * 0.06),
          child: CustomAppBar(
            showLeadICon: false,
            title: 'Products',
          )),
      body:
      GridView.count(
        crossAxisCount: 2,
        childAspectRatio: ((size.height - kToolbarHeight - 24) / (size.height - kToolbarHeight - 24) / 1.25),
        controller: ScrollController(keepScrollOffset: false),
        padding: const EdgeInsets.only(bottom: 100),
        shrinkWrap: true,

        scrollDirection: Axis.vertical,
        children: List.generate(
          20,
          (index) {
            return
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:  InkWell(
                  onTap: () {
                    value=index;

                    setState(() {

                    });
                    context.push(Routs.guestProductDetail);
                  },

                    child: ProductCard(
                      index: index,
                      value: value,
                    )),
              );
          },
        ),
      ),
    );
  }
}
class ProductCard extends StatelessWidget {
  int? index;
  int? value;
   ProductCard({
    this.index,
    this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return    Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration:  BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(22)),
              gradient:index==value? primaryGradient:const LinearGradient(
                begin: Alignment(0.00, -1.00),
                end: Alignment(0, 1),
                colors:[Color(0xFF1B1B1B), Color(0xFF282828)],
              )),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                SizedBox(
                  // height: size.height * 0.235,
                  child: ClipRRect(
                    clipBehavior: Clip.antiAlias,
                    borderRadius:
                    const BorderRadius.all(Radius.circular(17)),
                    child: Image.asset(AppAssets.geustProduct,
                        fit: BoxFit.cover),
                  ),
                ),
                SizedBox(
                  height: size.height*0.01,
                ),
                 Text(

                  'Reverse Osmosis PVC Kangen Water Mach...',
                  style: TextStyle(
                    color:index==value?Colors.black: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );

  }
}