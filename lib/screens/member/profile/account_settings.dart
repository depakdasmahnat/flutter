import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mrwebbeast/controllers/member/member_auth_controller.dart';
import 'package:provider/provider.dart';

import '../../../core/config/app_assets.dart';
import '../../../core/constant/constant.dart';
import '../../../core/services/database/local_database.dart';

import '../../../utils/widgets/image_view.dart';
import '../../../utils/widgets/widgets.dart';
import '../../guest/guestProfile/guest_profile.dart';

class AccountSettings extends StatefulWidget {
 final bool? hideDeleteAccount;
  const AccountSettings({Key? key,this.hideDeleteAccount}) : super(key: key,);

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    LocalDatabase localDatabase = Provider.of<LocalDatabase>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: size.height * 0.1),
        physics: const BouncingScrollPhysics(),
        children: [
          if(widget.hideDeleteAccount==false)
          Padding(
            padding: const EdgeInsets.only(left: kPadding, right: kPadding, top: kPadding),
            child: GestureDetector(
              onTap: () {
                context.read<MemberAuthControllers>().deleteAccount(context);
              },
              child: Card(
                type: false,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, top: kPadding, bottom: kPadding),
                  child: Row(
                    children: [
                      const Icon(Icons.delete),
                      SizedBox(
                        width: size.width * 0.04,
                      ),
                      const Text(
                        'Delete Account',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: kPadding, right: kPadding, top: kPadding),
            child: GestureDetector(
              onTap: () {
                context.read<MemberAuthControllers>().logOutPopup(context);
              },
              child: Card(
                type: false,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, top: kPadding, bottom: kPadding),
                  child: IconAndText(
                    icon: AppAssets.logout,
                    title: 'Sign Out',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget profileButton({
    String? image,
    IconData? icon,
    required String text,
    bool? showDivider = true,
    double? dividerThickness,
    double? dividerPadding,
    required GestureTapCallback onClick,
  }) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    icon != null
                        ? Icon(
                            icon,
                            size: 20,
                            color: Colors.white,
                          )
                        : ImageView(
                            height: 20,
                            width: 20,
                            fit: BoxFit.cover,
                            borderRadiusValue: 0,
                            color: Colors.white,
                            margin: EdgeInsets.zero,
                            assetImage: image,
                            onTap: null,
                          ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Text(
                        text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  ],
                ),
                const Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Colors.white,
                  size: 16,
                )
              ],
            ),
            if (showDivider == true)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Divider(
                  height: 0,
                  color: Colors.grey.shade800,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class Card extends StatelessWidget {
  Widget? child;
  bool? type;

  Card({
    this.child,
    this.type,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      // width: 398,
      // height: 232,
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0.00, -1.00),
          end: const Alignment(0, 1),
          colors: type == true
              ? [const Color(0xFF3B3B3B), const Color(0xFF4A4A4A)]
              : [const Color(0xFF1B1B1B), const Color(0xFF282828)],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 28.40,
            offset: Offset(0, 2),
            spreadRadius: 0,
          )
        ],
      ),
      child: child,
    );
  }
}

class IconAndText extends StatelessWidget {
  String? icon;
  String? title;
  double? height;
  void Function()? onTap;

  IconAndText({
    this.icon,
    this.title,
    this.onTap,
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Image.asset(icon ?? '', height: height ?? size.height * 0.026, fit: BoxFit.contain),
          SizedBox(
            width: size.width * 0.04,
          ),
          Text(
            title ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
