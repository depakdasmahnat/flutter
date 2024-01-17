import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

import '../../../core/config/app_assets.dart';
import '../../../core/route/route_paths.dart';
import '../../../utils/widgets/appbar.dart';
import '../product/guest_product.dart';

class Mainresource extends StatefulWidget {
  const Mainresource({super.key});

  @override
  State<Mainresource> createState() => _MainresourceState();
}

class _MainresourceState extends State<Mainresource> {
  List item =[
    {
    'image':AppAssets.resources,
    'title':'Business Images'
  },
    {
    'image':AppAssets.pdf,
    'title':'Business Images'
  },
    {
    'image':AppAssets.pdf,
    'title':'Demo Video'
  },
    {
    'image':AppAssets.pdf,
    'title':'Trainings PDFs'
  }
  ];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(size.height * 0.06),
          child: CustomAppBar(
            showLeadICon: false,
            title: 'Resources',
          )),
      body:  GridView.count(
        crossAxisCount: 2,

        childAspectRatio: ((size.height - kToolbarHeight - 24) / (size.height - kToolbarHeight - 24) / 0.85),
        controller: ScrollController(keepScrollOffset: false),
        padding: const EdgeInsets.only(bottom: 100),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: List.generate(
          item.length, (index) {
            return
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:  InkWell(
                    onTap: () {
                      context.push(Routs.resourceAndDemo);
                    },
                    child:Container(
                      decoration:  const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(18))
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
                              child: Image.asset(item[index]['image'],fit: BoxFit.cover,),
                            ),
                             Text(
                              item[index]['title'],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                height: 2
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                    )),
              );
          },
        ),
      ),
    );
  }
}
