import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/core/constant/shadows.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/partner/services/lead_details_model.dart';
import '../../../utils/widgets/image_view.dart';

class PartnerServicesCard extends StatelessWidget {
  const PartnerServicesCard({
    super.key,
    required this.leadDetails,
    this.padding,
    this.onTap,
  });

  final LeadData? leadDetails;

  final EdgeInsets? padding;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: leadDetails?.services?.length ?? 0,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        var data = leadDetails?.services?.elementAt(index);

        return CupertinoButton(
          padding: padding ?? const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          onPressed: onTap,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (data?.icon != null)
                ImageView(
                  height: 40,
                  width: 40,
                  borderRadiusValue: 30,
                  fit: BoxFit.cover,
                  backgroundColor: Colors.white,
                  boxShadow: defaultBoxShadow(),
                  networkImage: "${data?.icon}",
                  onTap: null,
                  margin: const EdgeInsets.all(6),
                ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "${data?.name}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontStyle: GoogleFonts.mulish().fontStyle,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
