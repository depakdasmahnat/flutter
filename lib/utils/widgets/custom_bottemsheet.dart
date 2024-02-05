import 'package:flutter/material.dart';
import 'package:mrwebbeast/utils/widgets/appbar.dart';

import '../../core/config/app_assets.dart';
import '../../core/constant/constant.dart';
import '../../screens/guest/guestProfile/guest_faq.dart';
import 'image_view.dart';

class CustomModelBottomSheet extends StatefulWidget {
  final String? title;
  final int? listItem;
  final int? tabIndex;

  const CustomModelBottomSheet({super.key, this.title, this.listItem, this.tabIndex});

  @override
  State<CustomModelBottomSheet> createState() => _CustomModelBottomSheetState();
}

class _CustomModelBottomSheetState extends State<CustomModelBottomSheet> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return SizedBox(
          height: size.height * 0.7,
          child: Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(size.height * 0.08),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomAppBar(
                    showLeadICon: true,
                    title: widget.title,
                  ),
                )),
            body: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(top: kPadding, bottom: kPadding),
              itemCount: widget.listItem,
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.only(left: kPadding, right: kPadding),
                    child: Container(
                      decoration: decoration,
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: InkWell(
                            onTap: () {
                              // context.push(Routs.memberProfile);
                            },
                            child: MyDashBoardCard(
                              tabIndex: widget.tabIndex,
                              listIndex: index,
                            ),
                          )),
                    ));
              },
            ),
          ),
        );
      },
    );
  }
}

class MyDashBoardCard extends StatelessWidget {
  final int? tabIndex;
  final int? listIndex;

  const MyDashBoardCard({
    this.tabIndex,
    this.listIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return tabIndex == 0
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Image.asset(AppAssets.u1),
                  const SizedBox(
                    width: 5,
                  ),
                  CustomeText(
                    text: 'Ayaan sha',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
              CustomeText(
                text: 'Raipur (C.G.)',
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  decoration: ShapeDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment(0.61, -0.79),
                      end: Alignment(-0.61, 0.79),
                      colors: [Color(0xFFFF2600), Color(0xFFFF6130)],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(39),
                    ),
                  ),
                  child: SizedBox(
                    width: size.width * 0.11,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 4),
                        child: CustomeText(
                          text: listIndex == 5 || listIndex == 4 ? 'Warm' : 'Hot',
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Icon(Icons.more_vert)
            ],
          )
        : tabIndex == 3
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Image.asset(AppAssets.u1),
                      const SizedBox(
                        width: 5,
                      ),
                      CustomeText(
                        text: 'Ayaan sha',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  CustomeText(
                    text: 'Raipur (C.G.)',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: ShapeDecoration(
                        gradient: LinearGradient(
                          begin: const Alignment(0.61, -0.79),
                          end: const Alignment(-0.61, 0.79),
                          colors: listIndex == 5 || listIndex == 4
                              ? [const Color(0xFFFDDC9C), const Color(0xFFDDA53B)]
                              : [const Color(0xFFFF2600), const Color(0xFFFF6130)],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(39),
                        ),
                      ),
                      child: SizedBox(
                        width: size.width * 0.11,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 4),
                            child: CustomeText(
                              text: listIndex == 5 || listIndex == 4 ? 'Warm' : 'Hot',
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: ShapeDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment(0.00, -1.00),
                          end: Alignment(0, 1),
                          colors: [Color(0xFFF3F3F3), Color(0xFFE0E0E0)],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18, right: 18, top: 4, bottom: 4),
                        child: CustomeText(
                          text: 'Close',
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : tabIndex == 4
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Image.asset(AppAssets.u1),
                          const SizedBox(
                            width: 5,
                          ),
                          CustomeText(
                            text: 'Ayaan sha',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      CustomeText(
                        text: 'Raipur (C.G.)',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      const Icon(Icons.more_vert)
                    ],
                  )
                : tabIndex == 5
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Image.asset(AppAssets.u1),
                              const SizedBox(
                                width: 5,
                              ),
                              CustomeText(
                                text: 'Ayaan sha',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                          CustomeText(
                            text: '12/01/24',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          CustomeText(
                            text: '04:30 PM',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          CustomeText(
                            text: 'Offline',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          const Icon(Icons.more_vert)
                        ],
                      )
                    : tabIndex == 6
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  Image.asset(AppAssets.u1),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  CustomeText(
                                    text: 'Ayaan sha',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                              CustomeText(
                                text: 'Raipur (C.G.)',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  decoration: ShapeDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment(0.00, -1.00),
                                      end: Alignment(0, 1),
                                      colors: [Color(0xFFF3F3F3), Color(0xFFE0E0E0)],
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                                    child: CustomeText(
                                      text: 'Close',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : tabIndex == 7
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(AppAssets.u1),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      CustomeText(
                                        text: 'Ayaan sha',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                  CustomeText(
                                    text: 'Raipur (C.G.)',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  InkWell(
                                    onTap: () {},
                                    child: Container(
                                      decoration: ShapeDecoration(
                                        gradient: const LinearGradient(
                                          begin: Alignment(0.61, -0.79),
                                          end: Alignment(-0.61, 0.79),
                                          colors: [Color(0xFFFF2600), Color(0xFFFF6130)],
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(39),
                                        ),
                                      ),
                                      child: SizedBox(
                                        width: size.width * 0.11,
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 4, bottom: 4),
                                            child: CustomeText(
                                              text: listIndex == 5 || listIndex == 4 ? 'Warm' : 'Hot',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {},
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: Color(0xFFD9D9D9), shape: BoxShape.circle),
                                      child: Padding(
                                        padding: const EdgeInsets.all(1),
                                        child: ImageView(
                                          assetImage: AppAssets.call,
                                          height: size.height * 0.02,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Icon(Icons.more_vert)
                                ],
                              )
                            : tabIndex == 8
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(AppAssets.u1),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          CustomeText(
                                            text: 'Ayaan sha',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ],
                                      ),
                                      CustomeText(
                                        text: '12/01/24',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      CustomeText(
                                        text: '04:30 PM',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        child: Container(
                                          decoration: ShapeDecoration(
                                            gradient: const LinearGradient(
                                              begin: Alignment(0.61, -0.79),
                                              end: Alignment(-0.61, 0.79),
                                              colors: [Color(0xFFFF2600), Color(0xFFFF6130)],
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(39),
                                            ),
                                          ),
                                          child: SizedBox(
                                            width: size.width * 0.11,
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 4, bottom: 4),
                                                child: CustomeText(
                                                  text: listIndex == 5 || listIndex == 4 ? 'Warm' : 'Hot',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 10,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Icon(Icons.more_vert)
                                    ],
                                  )
                                : tabIndex == 9
                                    ? Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(AppAssets.u1),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              CustomeText(
                                                text: 'Ayaan sha',
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ],
                                          ),
                                          CustomeText(
                                            text: '12/01/24',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          CustomeText(
                                            text: '04:30 PM',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          InkWell(
                                            onTap: () {},
                                            child: Container(
                                              decoration: ShapeDecoration(
                                                gradient: const LinearGradient(
                                                  begin: Alignment(0.61, -0.79),
                                                  end: Alignment(-0.61, 0.79),
                                                  colors: [Color(0xFFFF2600), Color(0xFFFF6130)],
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(39),
                                                ),
                                              ),
                                              child: SizedBox(
                                                width: size.width * 0.11,
                                                child: Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 4, bottom: 4),
                                                    child: CustomeText(
                                                      text: listIndex == 5 || listIndex == 4 ? 'Warm' : 'Hot',
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 10,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {},
                                            child: Container(
                                              decoration: ShapeDecoration(
                                                gradient: const LinearGradient(
                                                  begin: Alignment(0.00, -1.00),
                                                  end: Alignment(0, 1),
                                                  colors: [Color(0xFFF3F3F3), Color(0xFFE0E0E0)],
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(50),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 18, right: 18, top: 4, bottom: 4),
                                                child: CustomeText(
                                                  text: 'Close',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 10,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(AppAssets.u1),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              CustomeText(
                                                text: 'Ayaan sha',
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ],
                                          ),
                                          CustomeText(
                                            text: 'Raipur (C.G.)',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          InkWell(
                                            onTap: () {},
                                            child: Container(
                                              decoration: ShapeDecoration(
                                                gradient: const LinearGradient(
                                                  begin: Alignment(0.00, -1.00),
                                                  end: Alignment(0, 1),
                                                  colors: [Color(0xFFF3F3F3), Color(0xFFE0E0E0)],
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(50),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8, right: 8, top: 4, bottom: 4),
                                                child: CustomeText(
                                                  text: 'View Profile',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 10,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
  }
}
