import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/screens/partner/service/leads/leads_detail.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constant/colors.dart';
import '../../../core/constant/shadows.dart';
import '../../../models/partner/services/lead_details_model.dart';
import '../../../route/route_paths.dart';
import '../../../utils/widgets/image_view.dart';

class LeadsCard extends StatelessWidget {
  const LeadsCard({
    super.key,
    required this.partnerLeads,
    required this.lead,
    this.padding,
    this.onTap,
  });

  final LeadData? lead;
  final bool? partnerLeads;
  final EdgeInsets? padding;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: defaultBoxShadow(),
      ),
      child: CupertinoButton(
        padding: padding ?? const EdgeInsets.only(left: 16, right: 16, bottom: 12),
        onPressed: onTap ??
            () {
              if (lead?.id != null) {
                context.push(Routs.partnerLeadsDetail,
                    extra: LeadsDetail(
                      id: lead?.id,
                      partnerLeads: partnerLeads,
                    ));
              }
            },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageView(
              height: 35,
              width: 35,
              borderRadiusValue: 30,
              fit: BoxFit.cover,
              networkImage: "${lead?.profilePhoto}",
              isAvatar: true,
              boxShadow: defaultBoxShadow(),
              backgroundColor: Colors.white,
              onTap: null,
              margin: EdgeInsets.zero,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${lead?.name}",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontStyle: GoogleFonts.mulish().fontStyle,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      "${lead?.email}",
                      style: TextStyle(
                        fontSize: 14,
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                        fontStyle: GoogleFonts.mulish().fontStyle,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      "Date :-${lead?.createdAt}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontStyle: GoogleFonts.mulish().fontStyle,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      "${lead?.comment}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 8),
                  //   child: Divider(color: Colors.grey.shade400, height: 1),
                  // ),
                ],
              ),
            ),
            const CircleAvatar(
              radius: 14,
              backgroundColor: primaryColor,
              child: Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
