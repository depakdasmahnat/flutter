import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/core/config/app_images.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/models/partner/services/lead_details_model.dart';
import 'package:gaas/route/route_paths.dart';
import 'package:gaas/screens/partner/utils/dashoard_order_card.dart';
import 'package:gaas/utils/widgets/image_view.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../controllers/partner/partner_controller.dart';
import '../../../controllers/partner/service_provider_controller.dart';
import '../../../core/constant/colors.dart';
import '../../../core/enums/enums.dart';
import '../../../core/services/database/local_database.dart';
import '../../../models/partner/auth/partner_model.dart';
import '../../../models/partner/services/partner_dashboard_states_model.dart';
import '../../../utils/widgets/data_widget_builder.dart';
import '../../dashboard/utils/leads_card.dart';
import '../signup/join_as_partner.dart';
import '../utils/partner_app_bar.dart';

class ServicePartner extends StatefulWidget {
  const ServicePartner({
    super.key,
  });

  @override
  State<ServicePartner> createState() => _ServicePartnerState();
}

class _ServicePartnerState extends State<ServicePartner> {
  LocalDatabase localDatabase = LocalDatabase();

  double imageRadius = 55;

  List<LeadData>? leads;
  TextEditingController searchCtrl = TextEditingController();
  RefreshController leadsController = RefreshController(initialRefresh: false);

  fetchLeads({bool? loadingNext}) {
    ServiceProviderController servicesController =
        Provider.of<ServiceProviderController>(context, listen: false);
    servicesController.fetchLeads(
      context: context,
      searchKey: searchCtrl.text,
      partnerLeads: true,
      todayReport: true,
      isRefresh: loadingNext == true ? null : true,
      loadingNext: loadingNext,
      leadsController: leadsController,
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ServiceProviderController servicesController =
          Provider.of<ServiceProviderController>(context, listen: false);
      servicesController.fetchPartnerDashboardStates(context: context);
      fetchLeads();
    });

    super.initState();
  }

  PartnerData? partnerData;
  ServiceType? serviceType;
  PartnerDashboardStatesData? partnerDashboardStates;

  @override
  Widget build(BuildContext context) {
    PartnerController partnerController = Provider.of<PartnerController>(context);
    partnerData = partnerController.partnerData;
    serviceType = partnerController.serviceType;

    ServiceProviderController servicesController = Provider.of<ServiceProviderController>(context);
    leads = servicesController.leads;
    partnerDashboardStates = servicesController.partnerDashboardStates;
    return Scaffold(
      appBar: partnerAppBar(context: context, title: "Service Partner"),
      body: SmartRefresher(
        controller: leadsController,
        enablePullUp: true,
        enablePullDown: true,
        onRefresh: () async {
          if (mounted) {
            await fetchLeads();
          }
        },
        onLoading: () async {
          if (mounted) {
            await fetchLeads(loadingNext: true);
          }
        },
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                context.read<PartnerController>().setDashBoardIndex(2);
              },
              child: Container(
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.15),
                  border: Border.all(color: primaryColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: ImageView(
                    height: imageRadius,
                    width: imageRadius,
                    borderRadiusValue: imageRadius,
                    networkImage: "${partnerData?.profilePhoto}",
                    isAvatar: true,
                    border: Border.all(color: primaryColor),
                    fit: BoxFit.cover,
                    margin: EdgeInsets.zero,
                  ),
                  title: Text(
                    "Hi ${partnerData?.name ?? "Partner"}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  subtitle: Text(
                    "${serviceType?.value}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  trailing: CircleAvatar(
                    radius: 16,
                    backgroundColor: primaryColor.withOpacity(0.2),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: primaryColor,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 130,
              margin: const EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DashboardOrderCard(
                    title: "Today's Leads",
                    value: "${partnerDashboardStates?.newLeads ?? 0}",
                    hike: "${partnerDashboardStates?.todaysLeadHike ?? 0}",
                    onTap: () {},
                  ),
                  DashboardOrderCard(
                    title: "Rating",
                    value: "${partnerDashboardStates?.rating ?? 0}",
                    onTap: () {},
                  ),
                  DashboardOrderCard(
                    title: "Total Leads",
                    value: "${partnerDashboardStates?.totalLeads ?? 0}",
                    onTap: () {},
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Text(
                "Today Leads",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
              ),
            ),
            DataWidgetBuilder(
              isLoading: servicesController.loadingLeads,
              haveData: leads?.haveData == true,
              heightFactor: 0.5,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: leads?.length ?? 0,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  var lead = leads?.elementAt(index);

                  return LeadsCard(
                    lead: lead,
                    partnerLeads: true,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
