import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mrwebbeast/utils/widgets/custom_back_button.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';

import '../../../core/constant/enums.dart';

class ViewDetail extends StatefulWidget {
 final String image;
 final String type;
  const ViewDetail({super.key,required this.image,required this.type});
  @override
  State<ViewDetail> createState() => _ViewDetailState();
}

class _ViewDetailState extends State<ViewDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if(widget.type==FeedsFileType.image.value)
          ImageView(
            networkImage:widget.image??'' ,
          )

        ],
      ),
    );
  }
}
