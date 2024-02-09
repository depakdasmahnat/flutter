import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth/auth_controller.dart';
import '../../core/constant/colors.dart';
import '../../core/constant/shadows.dart';
import '../../core/services/database/local_database.dart';
import '../../utils/widgets/image_view.dart';
import '../../utils/widgets/widgets.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  bool isAuthenticated = LocalDatabase().accessToken != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            backButton(context: context),
          ],
        ),
        leadingWidth: 50,
        title: const Text("Settings"),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          if (isAuthenticated)
            Container(
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: defaultBoxShadow(),
                borderRadius: BorderRadius.circular(12),
              ),
              child: profileButton(
                icon: Icons.delete,
                color: Colors.red,
                text: "Delete Account",
                onClick: () {
                  context.read<AuthControllers>().deleteAccount(context);
                },
                showDivider: true,
              ),
            ),
          if (isAuthenticated)
            Container(
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: defaultBoxShadow(),
                borderRadius: BorderRadius.circular(12),
              ),
              child: profileButton(
                icon: Icons.logout,
                text: "Logout",
                onClick: () {
                  context.read<AuthControllers>().signOut(context: context);
                },
                showDivider: true,
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
    Color? color,
    required GestureTapCallback onClick,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onClick,
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
                            color: color ?? primaryColor,
                          )
                        : ImageView(
                            height: 20,
                            width: 20,
                            fit: BoxFit.cover,
                            borderRadiusValue: 0,
                            color: color ?? primaryColor,
                            margin: EdgeInsets.zero,
                            assetImage: image,
                            onTap: null,
                          ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Text(
                        text,
                        style: TextStyle(
                          color: Colors.grey.shade900,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: color ?? primaryColor,
                  size: 16,
                )
              ],
            ),
            if (showDivider == true)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Divider(
                  height: 0,
                  color: Colors.grey.shade300,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
