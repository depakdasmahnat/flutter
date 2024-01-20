import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class CustomBackButton extends StatefulWidget {
  double? iconSize;
   CustomBackButton({super.key,iconSize});

  @override
  State<CustomBackButton> createState() => _CustomBackButtonState();
}

class _CustomBackButtonState extends State<CustomBackButton> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return
      InkWell(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Container(
          decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.6000000238418579)
          ),

          child:   Center(child: Padding(
            padding: const EdgeInsets.all(9),
            child: Icon(AntDesign.left,color: Colors.black,size:widget.iconSize?? size.height*0.034,),
          )),
            ),
      ),
    );
  }
}
