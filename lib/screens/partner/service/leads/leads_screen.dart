import 'package:flutter/material.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../controllers/partner/service_provider_controller.dart';
import '../../../../core/services/database/local_database.dart';
import '../../../../models/partner/services/lead_details_model.dart';
import '../../../../utils/widgets/data_widget_builder.dart';
import '../../../dashboard/utils/leads_card.dart';
import '../../utils/partner_app_bar.dart';

class LeadsScreen extends StatefulWidget {
  const LeadsScreen({
    super.key,
    required this.partnerLeads,
  });

  final bool? partnerLeads;

  @override
  State<LeadsScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadsScreen> {
  late bool partnerLeads = widget.partnerLeads ?? false;
  LocalDatabase localDatabase = LocalDatabase();

  double imageRadius = 55;

  List<LeadData>? leads;
  TextEditingController searchCtrl = TextEditingController();
  RefreshController leadsController = RefreshController(initialRefresh: false);

  fetchServiceProviderDetail({bool? loadingNext}) {
    ServiceProviderController servicesController =
        Provider.of<ServiceProviderController>(context, listen: false);
    servicesController.fetchLeads(
      context: context,
      searchKey: searchCtrl.text,
      partnerLeads: partnerLeads,
      isRefresh: loadingNext == true ? null : true,
      loadingNext: loadingNext,
      leadsController: leadsController,
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchServiceProviderDetail();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ServiceProviderController servicesController = Provider.of<ServiceProviderController>(context);
    leads = servicesController.leads;

    return Scaffold(
      appBar: partnerAppBar(
        context: context,
        title: partnerLeads ? "Leads" : "Enquires",
        onBackPress: partnerLeads
            ? null
            : () {
                context.pop();
              },
        actions: [],
      ),
      body: SmartRefresher(
        controller: leadsController,
        enablePullUp: true,
        enablePullDown: true,
        onRefresh: () async {
          if (mounted) {
            await fetchServiceProviderDetail();
          }
        },
        onLoading: () async {
          if (mounted) {
            await fetchServiceProviderDetail(loadingNext: true);
          }
        },
        child: DataWidgetBuilder(
          isLoading: servicesController.loadingLeads,
          haveData: leads?.haveData == true,
          child: ListView(
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            children: [
              // Padding(
              //   padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              //   child: Text(
              //     "Today Leads",
              //     style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
              //   ),
              // ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: leads?.length ?? 0,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  var lead = leads?.elementAt(index);
                  return LeadsCard(
                    lead: lead,
                    partnerLeads: partnerLeads,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
