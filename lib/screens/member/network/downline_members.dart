import 'package:flutter/material.dart';
import 'package:mrwebbeast/controllers/member/network/network_controller.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:provider/provider.dart';

import '../../../core/config/app_assets.dart';
import '../../../models/member/network/down_line_members_model.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/image_view.dart';
import '../../../utils/widgets/loading_screen.dart';
import '../../../utils/widgets/no_data_found.dart';

class DownLineMembers extends StatefulWidget {
  const DownLineMembers({super.key, this.memberId, this.parentId, this.level});

  final num? memberId;
  final num? parentId;
  final num? level;

  @override
  State<DownLineMembers> createState() => _DownLineMembersState();
}

class _DownLineMembersState extends State<DownLineMembers> {
  TextEditingController searchController = TextEditingController();
  List<DownLineMemberData>? downLineMemberData;
  late num? memberId = widget.memberId;
  late num? parentId = widget.parentId;

  Future fetchDownLineMemberList({bool? loadingNext}) async {
    return await context.read<NetworkControllers>().fetchDownLineMemberList(
          memberId: widget.memberId,
          level: widget.level,
          search: searchController.text,
        );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchDownLineMemberList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NetworkControllers>(
      builder: (context, controller, child) {
        downLineMemberData = controller.downLineMemberData;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: CustomTextField(
                hintText: 'Search',
                controller: searchController,
                hintStyle: const TextStyle(color: Colors.white),
                prefixIcon: ImageView(
                  height: 20,
                  width: 20,
                  borderRadiusValue: 0,
                  color: Colors.white,
                  margin: const EdgeInsets.only(left: kPadding, right: kPadding),
                  fit: BoxFit.contain,
                  assetImage: AppAssets.searchIcon,
                  onTap: () {
                    fetchDownLineMemberList();
                  },
                ),
                onEditingComplete: () {
                  fetchDownLineMemberList();
                },
                margin: const EdgeInsets.only(left: kPadding, right: kPadding, bottom: kPadding),
              ),
            ),
            if (controller.loadingDownLineMember)
              const LoadingScreen(
                heightFactor: 0.5,
                message: 'Loading Members...',
              )
            else if (downLineMemberData.haveData)
              ListView.builder(
                itemCount: downLineMemberData?.length ?? 0,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var data = downLineMemberData?.elementAt(index);
                  return InkWell(
                    onTap: () {
                      context.read<NetworkControllers>().selectProjectionABMembers(
                            context: context,
                            previousMemberId: memberId,
                            memberId: data?.id,
                            parentId: parentId,
                          );
                    },
                    child: ListTile(
                      title: Text('${data?.name}'),
                    ),
                  );
                },
              )
            else
              NoDataFound(
                heightFactor: 0.5,
                message: controller.downLineMembersModel?.message ?? 'No Members Found',
              ),
          ],
        );
      },
    );
  }
}
