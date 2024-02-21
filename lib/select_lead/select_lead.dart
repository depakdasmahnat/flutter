import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';

import '../../core/config/app_assets.dart';
import '../../core/constant/constant.dart';
import '../../utils/widgets/appbar.dart';
import '../../utils/widgets/custom_text_field.dart';
import '../../utils/widgets/image_view.dart';
import '../screens/guest/guestProfile/guest_faq.dart';

class SelectLead extends StatefulWidget {
  const SelectLead({super.key});
  @override
  State<SelectLead> createState() => _SelectLeadState();
}

class _SelectLeadState extends State<SelectLead> {
  final switch1 = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(size.height * 0.18),
          child: CustomAppBar(
            showLeadICon: true,
            title: 'Resources',
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(size.height * 0.06),
              child: const CustomTextField(
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
            ),
          )),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: kPadding, right: kPadding),
            child: Container(
              decoration: decoration,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
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
                    AdvancedSwitch(
                      height: size.height * 0.028,
                      width: size.height * 0.06,
                      activeColor: const Color(0xFFFDDC9C),
                      inactiveColor: const Color(0xFFF3F3F3),
                      controller: switch1,
                      enabled: true,
                      thumb: Container(
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            backgroundColor: Colors.white,
                            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
                            title: CustomeText(
                              text: 'Do you want to Attend this event',
                              fontWeight: FontWeight.w600,
                              fontSize: 32,
                              color: Colors.black,
                              textAlign: TextAlign.center,
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  decoration: ShapeDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment(0.00, -1.00),
                                      end: Alignment(0, 1),
                                      colors: [Color(0xFF1B1B1B), Color(0xFF282828)],
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: CustomeText(
                                        text: 'I Will  Attend',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: ShapeDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment(0.00, -1.00),
                                      end: Alignment(0, 1),
                                      colors: [Color(0xFF1B1B1B), Color(0xFF282828)],
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: CustomeText(
                                        text: 'Attend with other',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: ShapeDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment(0.00, -1.00),
                            end: Alignment(0, 1),
                            colors: [Color(0xFFF3F3F3), Color(0xFFE0E0E0)],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.58),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18, right: 18, top: 8, bottom: 8),
                          child: CustomeText(
                            text: 'Join',
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
