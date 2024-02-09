import 'package:flutter/material.dart';
import 'package:gaas/core/constant/colors.dart';
import 'package:provider/provider.dart';

import '../controllers/dashboard_controller.dart';
import '../utils/widgets/custom_button.dart';
import '../utils/widgets/custom_text_field.dart';
import '../utils/widgets/widgets.dart';

class ReportBug extends StatefulWidget {
  const ReportBug({Key? key}) : super(key: key);

  @override
  State<ReportBug> createState() => _ReportBugState();
}

class _ReportBugState extends State<ReportBug> {
  int? selectedIndex;
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  GlobalKey<FormState> reportKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            backButton(context: context),
          ],
        ),
        leadingWidth: 50,
        title: const Text("Report & Feedback"),
      ),
      body: Form(
        key: reportKey,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 18, bottom: 18, left: 24, right: 24),
              margin: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(3, 1),
                    color: Colors.grey.shade50,
                    blurRadius: 1,
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    offset: const Offset(-2, 2),
                    color: Colors.grey.shade300,
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Text(
                        "Title",
                        style: TextStyle(fontSize: 16, color: primaryColor),
                      ),
                    ],
                  ),
                  CustomTextField(
                    controller: title,
                    isCollapsed: true,
                    autofocus: true,
                    isDense: true,
                    keyboardType: TextInputType.multiline,
                    contentPadding: EdgeInsets.zero,
                    hintText: "Write here...",
                    margin: const EdgeInsets.only(top: 8, bottom: 12),
                    borderColor: Colors.transparent,
                    border: InputBorder.none,
                    minLines: 2,
                    maxLines: 4,
                    validator: (val) {
                      if (val?.isEmpty == true) {
                        return "Enter Feedback Title";
                      }
                      return null;
                    },
                  ),
                  const Row(
                    children: [
                      Text(
                        "Report Any Bug / Give feedback ?",
                        style: TextStyle(fontSize: 16, color: primaryColor),
                      ),
                    ],
                  ),
                  CustomTextField(
                    controller: description,
                    isCollapsed: true,
                    autofocus: true,
                    isDense: true,
                    keyboardType: TextInputType.multiline,
                    contentPadding: EdgeInsets.zero,
                    hintText: "Write here...",
                    margin: const EdgeInsets.only(top: 8),
                    borderColor: Colors.transparent,
                    border: InputBorder.none,
                    minLines: 5,
                    maxLines: 8,
                  ),
                ],
              ),
            ),
            CustomButton(
              height: 45,
              text: "Report",
              mainAxisAlignment: MainAxisAlignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              onPressed: () {
                if (reportKey.currentState?.validate() == true) {
                  context.read<DashboardController>().addFeedback(
                        context: context,
                        title: title.text,
                        description: description.text,
                      );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
