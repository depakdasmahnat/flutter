import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaas/controllers/dashboard_controller.dart';
import 'package:gaas/core/constant/shadows.dart';
import 'package:gaas/core/extensions/null_safe/null_safe_list_extensions.dart';
import 'package:gaas/utils/widgets/data_widget_builder.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../models/dashboard/coin_transactions.dart';
import '../../utils/widgets/widgets.dart';

class CoinTransactionsScreen extends StatefulWidget {
  const CoinTransactionsScreen({Key? key}) : super(key: key);

  @override
  State<CoinTransactionsScreen> createState() => _CoinTransactionsScreenState();
}

class _CoinTransactionsScreenState extends State<CoinTransactionsScreen> {
  TextEditingController searchController = TextEditingController();
  List<CoinTransactionsData>? coinTransactions;

  Future fetchCoinTransactions({bool? loadingNext}) async {
    DashboardController controller = Provider.of<DashboardController>(context, listen: false);

    return controller.fetchCoinTransactions(
      context: context,
      searchKey: searchController.text,
      isRefresh: loadingNext == true ? null : true,
      loadingNext: loadingNext,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      fetchCoinTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    DashboardController controller = Provider.of<DashboardController>(context);
    coinTransactions = controller.coinTransactions;
    return Scaffold(
      appBar: AppBar(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            backButton(context: context),
          ],
        ),
        leadingWidth: 50,
        centerTitle: true,
        title: const Text("Transactions"),
      ),
      body: SmartRefresher(
        key: widget.key,
        controller: controller.coinTransactionsController,
        enablePullUp: true,
        enablePullDown: true,
        onRefresh: () async {
          if (mounted) {
            await fetchCoinTransactions();
          }
        },
        onLoading: () async {
          if (mounted) {
            await fetchCoinTransactions(loadingNext: true);
          }
        },
        child: DataWidgetBuilder(
          isLoading: controller.loadingCoinTransactions,
          haveData: coinTransactions.haveData,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: coinTransactions?.length ?? 0,
            physics: const ScrollPhysics(),
            itemBuilder: (context, index) {
              return paymentsCard(
                index: index,
                data: coinTransactions?[index],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget paymentsCard({
    required int index,
    required CoinTransactionsData? data,
  }) {
    bool success = data?.paymentStatus == "Success";
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8, left: 16, right: 16),
            padding: const EdgeInsets.only(top: 4, bottom: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: defaultBoxShadow(),
            ),
            child: ListTile(
              leading: Icon(
                success ? CupertinoIcons.checkmark_alt_circle : CupertinoIcons.multiply_circle,
                color: success ? Colors.green : Colors.red,
                size: 36,
              ),
              title: Text(
                data?.title ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data?.remarks ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    data?.transactionFormatDateTime ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xff0EAD1E),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
