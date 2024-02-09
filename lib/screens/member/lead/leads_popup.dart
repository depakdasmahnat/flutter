import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/core/constant/enums.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/utils/widgets/appbar.dart';
import 'package:mrwebbeast/utils/widgets/custom_back_button.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controllers/member/leads/leads_controllers.dart';
import '../../../core/config/app_assets.dart';
import '../../../core/constant/constant.dart';
import '../../../core/route/route_paths.dart';
import '../../../models/member/leads/leads_model.dart';
import '../../../utils/custom_menu_popup.dart';
import '../../../utils/widgets/image_view.dart';
import '../../../utils/widgets/loading_screen.dart';
import '../../../utils/widgets/no_data_found.dart';
import '../../guest/guestProfile/guest_faq.dart';

class LeadsPopup extends StatefulWidget {
  final String? title;
  final String? status;
  final String? priority;

  const LeadsPopup({super.key, this.title, this.status, this.priority});

  @override
  State<LeadsPopup> createState() => _LeadsPopupState();
}

class _LeadsPopupState extends State<LeadsPopup> {
  late String? status = widget.status;
  TextEditingController searchController = TextEditingController();
  List<LeadsData>? leads;

  Future fetchLeads({bool? loadingNext}) async {
    return await context.read<ListsControllers>().fetchLeads(
          context: context,
          isRefresh: loadingNext == true ? false : true,
          loadingNext: loadingNext ?? false,
          searchKey: searchController.text,
          status: widget.status,
          priority: widget.priority,
        );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchLeads();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<ListsControllers>(builder: (context, controller, child) {
      leads = controller.leads;
      return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: SizedBox(
          height: size.height * 0.7,
          child: Scaffold(
            appBar: AppBar(
              leading: const Column(
                children: [
                  CustomBackButton(),
                ],
              ),
              title: Text('${widget.title}'),
              centerTitle: true,
            ),
            body: SmartRefresher(
              controller: controller.leadsController,
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
                physics: const BouncingScrollPhysics(),
                children: [
                  (controller.loadingLeads)
                      ? const LoadingScreen(
                          heightFactor: 0.6,
                          message: 'Loading Leads...',
                        )
                      : (leads.haveData)
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(top: kPadding, bottom: kPadding),
                              itemCount: leads?.length ?? 0,
                              itemBuilder: (context, index) {
                                var lead = leads?.elementAt(index);

                                return (status == LeadsStatus.followUp.value)
                                    ? ClosedLeadsCard(lead: lead)
                                    : (status == LeadsStatus.closed.value)
                                        ? ClosedLeadsCard(lead: lead)
                                        : (status == LeadsStatus.demoScheduled.value)
                                            ? ScheduledLeadsCard(lead: lead)
                                            : (status == LeadsStatus.newLead.value)
                                                ? NewLeadsCard(lead: lead)
                                                : LeadsCard(lead: lead);
                              },
                            )
                          : NoDataFound(
                              heightFactor: 0.6,
                              message: controller.leadsModel?.message ?? 'No Feeds Found',
                            )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class CompletedLeadsCard extends StatelessWidget {
  final int? index;
  final LeadsData? lead;

  const CompletedLeadsCard({
    this.index,
    this.lead,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const String defaultText = '--';
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        context.push(Routs.memberProfile);
      },
      child: Container(
        decoration: decoration,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(left: kPadding, right: kPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ImageView(
                  height: 28,
                  width: 28,
                  isAvatar: true,
                  borderRadiusValue: 30,
                  networkImage: '${lead?.profilePhoto}',
                  margin: const EdgeInsets.only(left: 8, right: 8),
                ),
                const SizedBox(
                  width: 5,
                ),
                // if (lead?.firstName != null)
                CustomeText(
                  text: lead?.firstName ?? defaultText,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            CustomeText(
              text: lead?.address ?? defaultText,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            if (lead?.priority != null)
              InkWell(
                onTap: () {},
                child: Container(
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      begin: const Alignment(0.61, -0.79),
                      end: const Alignment(-0.61, 0.79),
                      colors: lead?.priority == LeadPriorityFilters.hot.value
                          ? [const Color(0xFFFF2600), const Color(0xFFFF6130)]
                          : lead?.priority == LeadPriorityFilters.warm.value
                              ? [const Color(0xFFFDDC9C), const Color(0xFFDDA53B)]
                              : [const Color(0xFF3CDCDC), const Color(0xFF12BCBC)],
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
                          text: '${lead?.priority}',
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            if (lead?.mobile != null)
              ImageView(
                height: 28,
                width: 28,
                isAvatar: true,
                borderRadiusValue: 30,
                backgroundColor: Colors.white,
                assetImage: AppAssets.call,
                color: Colors.black,
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.only(left: 8),
                onTap: () {
                  launchUrl(Uri.parse('tel:${lead?.mobile}'));
                },
              ),
            CustomPopupMenu(
              items: [
                CustomPopupMenuEntry(
                  label: 'Interested',
                  onPressed: null,
                ),
                CustomPopupMenuEntry(
                  label: 'Not confirm',
                  onPressed: null,
                ),
              ],
              onChange: (String? val) {},
              child: const Icon(Icons.more_vert),
            )
          ],
        ),
      ),
    );
  }
}

class ScheduledLeadsCard extends StatelessWidget {
  final int? index;
  final LeadsData? lead;

  const ScheduledLeadsCard({
    this.index,
    this.lead,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const String defaultText = '--';
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        context.push(Routs.memberProfile);
      },
      child: Container(
        decoration: decoration,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(left: kPadding, right: kPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ImageView(
                  height: 28,
                  width: 28,
                  borderRadiusValue: 30,
                  isAvatar: true,
                  networkImage: '${lead?.profilePhoto}',
                  margin: const EdgeInsets.only(left: 8, right: 8),
                ),
                const SizedBox(
                  width: 5,
                ),
                // if (lead?.firstName != null)
                CustomeText(
                  text: lead?.firstName ?? defaultText,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            CustomeText(
              text: lead?.demoDate ?? defaultText,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            CustomeText(
              text: lead?.demoTime ?? defaultText,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            if (lead?.priority != null)
              InkWell(
                onTap: () {},
                child: Container(
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      begin: const Alignment(0.61, -0.79),
                      end: const Alignment(-0.61, 0.79),
                      colors: lead?.priority == LeadPriorityFilters.hot.value
                          ? [const Color(0xFFFF2600), const Color(0xFFFF6130)]
                          : lead?.priority == LeadPriorityFilters.warm.value
                              ? [const Color(0xFFFDDC9C), const Color(0xFFDDA53B)]
                              : [const Color(0xFF3CDCDC), const Color(0xFF12BCBC)],
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
                          text: '${lead?.priority}',
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            // CustomPopupMenu(
            //   items: [
            //     CustomPopupMenuEntry(
            //       label: 'Interested',
            //       onPressed: null,
            //     ),
            //     CustomPopupMenuEntry(
            //       label: 'Not confirm',
            //       onPressed: null,
            //     ),
            //   ],
            //   onChange: (String? val) {},
            //   child: const Icon(Icons.more_vert),
            // )
          ],
        ),
      ),
    );
  }
}

class NewLeadsCard extends StatelessWidget {
  final int? index;
  final LeadsData? lead;

  const NewLeadsCard({
    this.index,
    this.lead,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const String defaultText = '--';
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        context.push(Routs.memberProfile);
      },
      child: Container(
        decoration: decoration,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(left: kPadding, right: kPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ImageView(
                  height: 28,
                  width: 28,
                  isAvatar: true,
                  borderRadiusValue: 30,
                  networkImage: '${lead?.profilePhoto}',
                  margin: const EdgeInsets.only(left: 8, right: 8),
                ),
                const SizedBox(
                  width: 5,
                ),
                // if (lead?.firstName != null)
                CustomeText(
                  text: lead?.firstName ?? defaultText,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            CustomeText(
              text: lead?.address ?? defaultText,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            if (lead?.priority != null)
              InkWell(
                onTap: () {},
                child: Container(
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      begin: const Alignment(0.61, -0.79),
                      end: const Alignment(-0.61, 0.79),
                      colors: lead?.priority == LeadPriorityFilters.hot.value
                          ? [const Color(0xFFFF2600), const Color(0xFFFF6130)]
                          : lead?.priority == LeadPriorityFilters.warm.value
                              ? [const Color(0xFFFDDC9C), const Color(0xFFDDA53B)]
                              : [const Color(0xFF3CDCDC), const Color(0xFF12BCBC)],
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
                          text: '${lead?.priority}',
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            if (lead?.mobile != null)
              ImageView(
                height: 28,
                width: 28,
                isAvatar: true,
                borderRadiusValue: 30,
                backgroundColor: Colors.white,
                assetImage: AppAssets.call,
                color: Colors.black,
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.only(left: 8),
                onTap: () {
                  launchUrl(Uri.parse('tel:${lead?.mobile}'));
                },
              ),
            // CustomPopupMenu(
            //   items: [
            //     CustomPopupMenuEntry(
            //       label: 'Interested',
            //       onPressed: null,
            //     ),
            //     CustomPopupMenuEntry(
            //       label: 'Not confirm',
            //       onPressed: null,
            //     ),
            //   ],
            //   onChange: (String? val) {},
            //   child: const Icon(Icons.more_vert),
            // )
          ],
        ),
      ),
    );
  }
}

class LeadsCard extends StatelessWidget {
  final int? index;
  final LeadsData? lead;

  const LeadsCard({
    this.index,
    this.lead,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const String defaultText = '--';
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        context.push(Routs.memberProfile);
      },
      child: Container(
        decoration: decoration,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(left: kPadding, right: kPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ImageView(
                  height: 28,
                  width: 28,
                  isAvatar: true,
                  borderRadiusValue: 30,
                  networkImage: '${lead?.profilePhoto}',
                  margin: const EdgeInsets.only(left: 8, right: 8),
                ),
                const SizedBox(
                  width: 5,
                ),
                // if (lead?.firstName != null)
                CustomeText(
                  text: lead?.firstName ?? defaultText,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            CustomeText(
              text: lead?.demoDate ?? defaultText,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            CustomeText(
              text: lead?.demoTime ?? defaultText,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            // CustomeText(
            //   text: lead?.address ?? defaultText,
            //   fontSize: 12,
            //   fontWeight: FontWeight.w500,
            // ),
            if (lead?.priority != null)
              InkWell(
                onTap: () {},
                child: Container(
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      begin: const Alignment(0.61, -0.79),
                      end: const Alignment(-0.61, 0.79),
                      colors: lead?.priority == LeadPriorityFilters.hot.value
                          ? [const Color(0xFFFF2600), const Color(0xFFFF6130)]
                          : lead?.priority == LeadPriorityFilters.warm.value
                              ? [const Color(0xFFFDDC9C), const Color(0xFFDDA53B)]
                              : [const Color(0xFF3CDCDC), const Color(0xFF12BCBC)],
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
                          text: '${lead?.priority}',
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            if (lead?.mobile != null)
              ImageView(
                height: 28,
                width: 28,
                isAvatar: true,
                borderRadiusValue: 30,
                backgroundColor: Colors.white,
                assetImage: AppAssets.call,
                color: Colors.black,
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.only(left: 8),
                onTap: () {
                  launchUrl(Uri.parse('tel:${lead?.mobile}'));
                },
              ),
            CustomPopupMenu(
              items: [
                CustomPopupMenuEntry(
                  label: 'Interested',
                  onPressed: null,
                ),
                CustomPopupMenuEntry(
                  label: 'Not confirm',
                  onPressed: null,
                ),
              ],
              onChange: (String? val) {},
              child: const Icon(Icons.more_vert),
            )
          ],
        ),
      ),
    );
  }
}

class ClosedLeadsCard extends StatelessWidget {
  final int? index;
  final LeadsData? lead;

  const ClosedLeadsCard({
    this.index,
    this.lead,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const String defaultText = '--';
    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        context.push(Routs.memberProfile);
      },
      child: Container(
        decoration: decoration,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(left: kPadding, right: kPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ImageView(
                  height: 28,
                  width: 28,
                  isAvatar: true,
                  networkImage: '${lead?.profilePhoto}',
                  borderRadiusValue: 30,
                  margin: const EdgeInsets.only(left: 8, right: 8),
                ),
                CustomeText(
                  text: lead?.firstName ?? defaultText,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            CustomeText(
              text: lead?.address ?? defaultText,
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
                    colors: lead?.priority == LeadPriorityFilters.hot.value
                        ? [const Color(0xFFFF2600), const Color(0xFFFF6130)]
                        : lead?.priority == LeadPriorityFilters.warm.value
                            ? [const Color(0xFFFDDC9C), const Color(0xFFDDA53B)]
                            : [const Color(0xFF3CDCDC), const Color(0xFF12BCBC)],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                  child: CustomeText(
                    text: lead?.status ?? defaultText,
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
