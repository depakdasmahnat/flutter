import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/constant/gradients.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import 'package:provider/provider.dart';

import '../../../controllers/guest_controller/guest_controller.dart';
import '../../../utils/widgets/appbar.dart';
import '../../../utils/widgets/gradient_button.dart';
import 'guest_faq.dart';

class FeedbackAndRating extends StatefulWidget {
  const FeedbackAndRating({super.key});

  @override
  State<FeedbackAndRating> createState() => _FeedbackAndRatingState();
}

class _FeedbackAndRatingState extends State<FeedbackAndRating> {
  TextEditingController commentController =TextEditingController();
  double? tabIndex =-1;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(size.height * 0.06),
          child: CustomAppBar(
            showLeadICon: true,
            title: 'Feedback',
          )),
      body: Padding(
        padding: const EdgeInsets.all(kPadding),
        child: Column(

          children: [
            CustomeText(
            text: 'Please rate your experience',
            fontWeight: FontWeight.w600,
            fontSize: 16,

          ),
            SizedBox(
              height: size.height*0.02,
            ),
            Align(
              alignment: Alignment.center,
              child: RatingBar.builder(
                minRating: 1,
                itemSize: size.height*0.07,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, index) =>  ImageView(
                  assetImage: tabIndex!<=index? AppAssets.basSmileStar :
                  AppAssets.smileStar,
                ) ,
                onRatingUpdate: (rating) {
                  print("Check rating $rating");
                  if(rating==1.0){
                    tabIndex =0;
                  }else{
                    tabIndex =rating;
                  }

                  setState(() {
                  });

                },
              ),
            ),
            SizedBox(
              height: size.height*0.02,
            ),
            CustomeText(
              text: 'Leave a comment',
              fontWeight: FontWeight.w600,
              fontSize: 16,

            ),
            SizedBox(
              height: size.height*0.02,
            ),
            Container(
              height: size.height*0.2,
              decoration:  BoxDecoration(
                  color: const Color(0xff3B3B3B),
                  borderRadius: BorderRadius.circular(16)
              ),
              child: TextFormField(
                controller: commentController,
                decoration:  InputDecoration(
                  contentPadding:EdgeInsets.only(left: size.width*0.07) ,
                  border: InputBorder.none,
                  hintText: 'Comment',
                  hintStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14
                  ),
                ),

                // margin: const EdgeInsets.only(bottom: 18),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GradientButton(
            height: 60,
            borderRadius: 18,
            blur: 10,
            backgroundGradient: primaryGradient,
            backgroundColor: Colors.transparent,
            boxShadow: const [],
            margin:  EdgeInsets.only(left: 16, right: 24,top: size.height*0.05),
            onTap: () async{
              await context.read<GuestControllers>().addRating(context: context, rating: tabIndex.toString(), comment: commentController.text);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: GoogleFonts.urbanist().fontFamily,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
           SizedBox(
            height: size.height*0.05,
          )
        ],
      ),

    );
  }
}
