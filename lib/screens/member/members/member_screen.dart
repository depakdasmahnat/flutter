// /// Package imports
// import 'package:flutter/material.dart';
//
// /// Barcode imports
// // ignore: depend_on_referenced_packages
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';
//
// /// Local imports
//
//
// /// Renders column type data grid
// class ColumnTypeDataGrid extends SampleView {
//   /// Creates column type data grid
//   const ColumnTypeDataGrid({Key? key}) : super(key: key);
//
//   @override
//   _ColumnTypesDataGridState createState() => _ColumnTypesDataGridState();
// }
//
// class _ColumnTypesDataGridState extends SampleViewState {
//   /// Required for SfDataGrid to obtain the row data.
//   late final CustomerDataGridSource columnTypesDataGridSource;
//
//   /// Determine to decide whether the device in landscape or in portrait
//   late bool isLandscapeInMobileView;
//
//   late bool isWebOrDesktop;
//
//   SfDataGrid _buildDataGrid(BuildContext context) {
//     return SfDataGrid(
//         source: columnTypesDataGridSource,
//         columnWidthMode: isWebOrDesktop
//             ? (isWebOrDesktop && model.isMobileResolution)
//             ? ColumnWidthMode.none
//             : ColumnWidthMode.fill
//             : ColumnWidthMode.none,
//         columns: <GridColumn>[
//           GridColumn(
//               columnName: 'dealer',
//               width: 90,
//               label: Container(
//                 padding: const EdgeInsets.all(8.0),
//                 alignment: Alignment.center,
//                 child: const Text(
//                   'Dealer',
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               )),
//           GridColumn(
//               columnName: 'id',
//               width: !isWebOrDesktop
//                   ? 50
//                   : (isWebOrDesktop && model.isMobileResolution)
//                   ? 110
//                   : double.nan,
//               label: Container(
//                 alignment: Alignment.centerRight,
//                 padding: const EdgeInsets.all(8.0),
//                 child: const Text(
//                   'ID',
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               columnWidthMode: isLandscapeInMobileView
//                   ? ColumnWidthMode.fill
//                   : ColumnWidthMode.none),
//           GridColumn(
//             columnName: 'name',
//             width:
//             (isWebOrDesktop && model.isMobileResolution) ? 110 : double.nan,
//             label: Container(
//               alignment: Alignment.centerLeft,
//               padding: const EdgeInsets.all(8.0),
//               child: const Text(
//                 'Name',
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ),
//           GridColumn(
//             columnName: 'freight',
//             width:
//             (isWebOrDesktop && model.isMobileResolution) ? 110 : double.nan,
//             columnWidthMode: isLandscapeInMobileView
//                 ? ColumnWidthMode.fill
//                 : ColumnWidthMode.none,
//             label: Container(
//               alignment: Alignment.center,
//               padding: const EdgeInsets.all(8.0),
//               child: const Text(
//                 'Freight',
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ),
//           GridColumn(
//             columnName: 'shippedDate',
//             width: 110,
//             label: Container(
//               alignment: Alignment.centerRight,
//               padding: const EdgeInsets.all(8.0),
//               child: const Text(
//                 'Shipped Date',
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             //dateFormat: DateFormat.yMd()
//           ),
//           GridColumn(
//             columnName: 'city',
//             width: isWebOrDesktop ? 110.0 : double.nan,
//             label: Container(
//               alignment: Alignment.centerLeft,
//               padding: const EdgeInsets.all(8.0),
//               child: const Text(
//                 'City',
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ),
//           GridColumn(
//               columnName: 'price',
//               width: (isWebOrDesktop && model.isMobileResolution)
//                   ? 120.0
//                   : double.nan,
//               columnWidthMode: ColumnWidthMode.lastColumnFill,
//               label: Container(
//                 alignment: Alignment.centerRight,
//                 padding: const EdgeInsets.all(8.0),
//                 child: const Text(
//                   'Price',
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ))
//         ]);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     isWebOrDesktop = model.isWeb || model.isDesktop;
//     columnTypesDataGridSource = CustomerDataGridSource(isWebOrDesktop: true);
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     isLandscapeInMobileView = !isWebOrDesktop &&
//         MediaQuery.of(context).orientation == Orientation.landscape;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return _buildDataGrid(context);
//   }
// }
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:mrwebbeast/core/config/app_assets.dart';
import 'package:mrwebbeast/core/constant/constant.dart';
import 'package:mrwebbeast/core/extensions/nullsafe/null_safe_list_extentions.dart';
import 'package:mrwebbeast/core/route/route_paths.dart';
import 'package:mrwebbeast/utils/widgets/image_view.dart';
import 'package:provider/provider.dart';

import '../../../controllers/member/network/network_controller.dart';
import '../../../core/constant/gradients.dart';
import '../../../models/member/network/pinnacle_list_model.dart';
import '../../../utils/custom_menu_popup.dart';
import '../../../utils/widgets/appbar.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../../../utils/widgets/gradient_button.dart';
import '../../../utils/widgets/loading_screen.dart';
import '../../../utils/widgets/no_data_found.dart';
import '../../guest/guestProfile/guest_faq.dart';
import '../home/duration_popup.dart';
import '../lead/lead.dart';
import '../network/pinnacle_list_table.dart';

class MemberScreen extends StatefulWidget {
  const MemberScreen({super.key});

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  List tabItem = ['Today', 'This week', 'Month'];
  late String currentTab = tabItem.first;
  PinnacleListModel? networkReportsModel;
  List<PinnacleListData>? pinnacleList;
  TextEditingController searchController = TextEditingController();

  Future fetchPinnacleList() async {
    pinnacleList = await context.read<NetworkControllers>().fetchNetworkReports(
          search: searchController.text,
          filter: filter,
        );
  }

  String? filter;
  String? selectedDuration = DurationFilterMenu.monthly.label;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        fetchPinnacleList();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer<NetworkControllers>(builder: (context, controller, child) {
      networkReportsModel = controller.networkReportsModel;
      pinnacleList = controller.networkReports;
      return Scaffold(
        appBar: AppBar(
          title: const Text('Partners'),
        ),
        body: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: kPadding, right: kPadding, top: 12, bottom: 12),
                  decoration: BoxDecoration(
                    gradient: inActiveGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: tabItem.map(
                      (e) {
                        bool isSelected = currentTab == e;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              currentTab = e;

                              setState(() {});
                            },
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: isSelected ? primaryGradient : null,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  e,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isSelected ? Colors.black : Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: kPadding, right: kPadding, top: 8, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomeText(
                        text: 'Partners Target',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                      GraphDurationFilter(
                        value: selectedDuration,
                        onChange: (String? val) {
                          selectedDuration = val;
                          setState(() {});
                          fetchPinnacleList();
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 16, top: 8, bottom: 8, right: 16),
                  decoration: BoxDecoration(
                    gradient: greyGradient,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: kPadding, right: kPadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: CustomeText(
                                    text: 'Partners target',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Text(
                                        '${networkReportsModel?.pendingTarget ?? 0}',
                                        style: const TextStyle(
                                          fontSize: 60,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 18),
                                      child: Text(
                                        'Pending',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: SizedBox(
                                    height: 78,
                                    child: VerticalDivider(),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 8),
                                          child: Text(
                                            '${networkReportsModel?.salesTarget ?? 0}',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        const Text(
                                          'Target',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 8),
                                            child: Text(
                                              '${networkReportsModel?.achievedTarget ?? 0}',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          const Text(
                                            'Achieved',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 16,
                        child: CustomPopupMenu(
                          items: [
                            CustomPopupMenuEntry(
                              label: 'Edit',
                              onPressed: () {},
                            ),
                            CustomPopupMenuEntry(
                              label: 'Delete',
                              color: Colors.red,
                              onPressed: () {},
                            ),
                          ],
                          onChange: (String? val) {},
                          child: const Icon(
                            Icons.more_vert,
                            size: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: kPadding),
                  child: Row(
                    children: [
                      Flexible(
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
                              fetchPinnacleList();
                            },
                          ),
                          onEditingComplete: () {
                            fetchPinnacleList();
                          },
                          margin: const EdgeInsets.only(left: kPadding, right: kPadding, bottom: kPadding),
                        ),
                      ),
                      CustomPopupMenu(
                        items: [
                          CustomPopupMenuEntry(
                            value: '',
                            label: 'All',
                            onPressed: () {
                              filter = null;
                            },
                          ),
                          CustomPopupMenuEntry(
                            label: 'Level',
                            onPressed: null,
                          ),
                          CustomPopupMenuEntry(
                            label: 'Achievement',
                            onPressed: null,
                          ),
                          CustomPopupMenuEntry(
                            label: 'Conversion Ratio',
                            onPressed: null,
                          ),
                          CustomPopupMenuEntry(
                            label: 'Progress',
                            onPressed: null,
                          ),
                          CustomPopupMenuEntry(
                            label: 'Training',
                            onPressed: null,
                          ),
                          CustomPopupMenuEntry(
                            label: 'Demo',
                            onPressed: null,
                          ),
                          CustomPopupMenuEntry(
                            label: 'Target',
                            onPressed: null,
                          ),
                        ],
                        onChange: (String? val) {
                          filter = val;
                          setState(() {});
                          fetchPinnacleList();
                        },
                        child: GradientButton(
                          height: 60,
                          width: 60,
                          margin: const EdgeInsets.only(left: 8, right: kPadding, bottom: kPadding),
                          backgroundGradient: blackGradient,
                          child: const ImageView(
                            height: 28,
                            width: 28,
                            assetImage: AppAssets.filterIcons,
                            margin: EdgeInsets.zero,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                if (controller.loadingNetworkReports)
                  const LoadingScreen(
                    heightFactor: 0.5,
                    message: 'Loading Partners',
                  )
                else if (pinnacleList.haveData)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kPadding),
                    child: NetworkPinnacleTable(
                      pinnacleList: pinnacleList,
                      verticalScrollPhysics: const NeverScrollableScrollPhysics(),
                    ),
                  )
                else
                  const NoDataFound(
                    heightFactor: 0.5,
                    message: 'No Partners Found',
                  ),
              ],
            )
          ],
        ),
      );
    });
  }
}

class CustomeContainer extends StatelessWidget {
  List<Color>? color;
  Widget? child;
  double? continerWidht;

  CustomeContainer({
    this.child,
    this.color,
    this.continerWidht,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
        width: continerWidht ?? size.width * 0.48,
        decoration: ShapeDecoration(
          gradient: LinearGradient(
            begin: const Alignment(0.00, -1.00),
            end: const Alignment(0, 1),
            colors: color ?? [const Color(0xFF3B3B3B), const Color(0xFF4A4A4A)],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(27.79),
          ),
        ),
        child: child);
  }
}
