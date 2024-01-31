import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/screens/guest/guestProfile/guest_faq.dart';

import '../../core/config/app_assets.dart';
import '../../core/route/route_paths.dart';

class GtpVideo extends StatefulWidget {
  const GtpVideo({super.key});

  @override
  State<GtpVideo> createState() => _GtpVideoState();
}

class _GtpVideoState extends State<GtpVideo> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 10000)).then((value) => context.pushNamed(
          Routs.dashboard,
        ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AppAssets.firstScreenVideo),
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
              isAntiAlias: true),
        ),
      ),
    );
  }
}
