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
import 'package:mrwebbeast/core/route/route_paths.dart';

import '../../../core/constant/gradients.dart';
import '../../../utils/widgets/appbar.dart';
import '../../guest/guestProfile/guest_faq.dart';
import '../lead/lead.dart';

class MemberScreen extends StatefulWidget {
  const MemberScreen({super.key});

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  int tabIndex = 0;
  List tabItem = ['Today', 'This week', 'Month'];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(size.height * 0.5),
          child: CustomAppBar(
            title: 'Members',
            showLeadICon: true,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(size.height * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: double.infinity,
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment(0.00, -1.00),
                          end: Alignment(0, 1),
                          colors: [Color(0xFF3B3B3B), Color(0xFF4A4A4A)],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: SizedBox(
                          height: size.height * 0.07,
                          child: ListView.builder(
                            itemCount: tabItem.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  tabIndex = index;
                                  setState(() {});
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                                  child: Container(
                                    width: size.width * 0.3,
                                    height: size.width * 0.06,
                                    decoration: ShapeDecoration(
                                      gradient: index == tabIndex ? primaryGradient : null,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Center(
                                        child: CustomeText(
                                      text: tabItem[index],
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: index == tabIndex ? Colors.black : Colors.white,
                                    )),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: kPadding, right: kPadding, top: 8, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomeText(
                          text: 'Members Target',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        Container(
                          width: size.width * 0.27,
                          height: size.height * 0.04,
                          decoration: ShapeDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment(0.00, -1.00),
                              end: Alignment(0, 1),
                              colors: [Color(0xFF1B1B1B), Color(0xFF282828)],
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          child: DropdownSearch<String>(
                            dropdownButtonProps: const DropdownButtonProps(
                                // padding: EdgeInsets.only(bottom: 10),
                                icon: Icon(
                              CupertinoIcons.chevron_down,
                              size: 18,
                            )),
                            popupProps: PopupProps.menu(
                              menuProps: const MenuProps(
                                backgroundColor: Color(0xFF1B1B1B),
                              ),
                              fit: FlexFit.loose,
                              showSelectedItems: true,
                              disabledItemFn: (String s) => s.startsWith('p'),
                            ),
                            items: const ['Monthly', 'Weekly', 'Days'],
                            dropdownDecoratorProps: const DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: kPadding, top: 2),
                                  border: InputBorder.none,
                                  hintText: 'Select',
                                  hintStyle: TextStyle(
                                      fontSize: 14, color: Colors.white, fontWeight: FontWeight.w700)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomeContainer(
                        color: const [Color(0xFFF3F3F3), Color(0xFFE0E0E0)],
                        child: Padding(
                          padding: const EdgeInsets.only(left: kPadding, top: 8, bottom: 8, right: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomeText(
                                text: 'My sales target',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                                child: Row(
                                  children: [
                                    CustomeText(
                                      text: '06 ',
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                    CustomeText(
                                      text: 'pending',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  CustomeText(
                                    text: '60 ',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                  CustomeText(
                                    text: 'Target',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    height: size.height * 0.03,
                                    child: const VerticalDivider(
                                      thickness: 1,
                                      color: Colors.black,
                                    ),
                                  ),
                                  CustomeText(
                                    text: '54',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                  CustomeText(
                                    text: 'Achieved',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      CustomeContainer(
                        child: Padding(
                          padding: const EdgeInsets.only(left: kPadding, top: 8, bottom: 8, right: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: size.width * 0.43,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CustomeText(
                                          text: '6A',
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white.withOpacity(0.6000000238418579)),
                                          child: Center(
                                              child: Padding(
                                            padding: const EdgeInsets.all(1),
                                            child: Icon(
                                              AntDesign.right,
                                              color: Colors.black,
                                              size: size.height * 0.02,
                                            ),
                                          )),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        CustomeText(
                                          text: '6A2',
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                    CircleAvatar(
                                      backgroundImage: AssetImage(AppAssets.topIcon),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: CustomeText(
                                  text: 'Rank target',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              Row(
                                children: [
                                  CustomeText(
                                    text: '(40.5%)',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  CircleAvatar(
                                    maxRadius: size.height * 0.01,
                                    backgroundImage: AssetImage(
                                      AppAssets.toparrow,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 3, top: 12, right: 3),
                    child: CustomeContainer(
                      continerWidht: double.infinity,
                      color: [Color(0xFFF3F3F3), Color(0xFFE0E0E0)],
                      child: Padding(
                        padding: const EdgeInsets.only(left: kPadding, top: kPadding, bottom: kPadding),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomeText(
                              text: '56 %',
                              fontSize: 46,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                            CustomeText(
                              text: 'Lists Conversion Raito',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
      body: ListView.builder(
        itemCount: 10,
        padding: EdgeInsets.only(bottom: size.height * 0.13, top: size.height * 0.02),
        itemBuilder: (context, index) {
          return Padding(
              padding: const EdgeInsets.only(left: kPadding, right: kPadding),
              child: Container(
                decoration: decoration,
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: InkWell(
                      onTap: () {
                        context.pushNamed(Routs.memberEditProfile);
                      },
                      child: RowCart(
                        tabIndex: tabIndex,
                        listIndex: index,
                      ),
                    )),
              ));
        },
      ),
    );
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
