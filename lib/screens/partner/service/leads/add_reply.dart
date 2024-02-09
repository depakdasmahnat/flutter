import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gaas/controllers/partner/service_provider_controller.dart';
import 'package:gaas/models/partner/services/lead_details_model.dart';
import 'package:gaas/utils/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/services_controller.dart';
import '../../../../core/services/database/local_database.dart';
import '../../../../utils/widgets/custom_button.dart';

class AddReply extends StatefulWidget {
  const AddReply({
    Key? key,
    required this.onSuccess,
    required this.lead,
  }) : super(key: key);

  final LeadData? lead;
  final GestureTapCallback? onSuccess;

  @override
  State<AddReply> createState() => _AddReplyState();
}

class _AddReplyState extends State<AddReply> {
  late LeadData? lead = widget.lead;

  late VoidCallback? onSuccess = widget.onSuccess;
  LocalDatabase localDatabase = LocalDatabase();

  TextEditingController replyCtrl = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ServicesController controller = Provider.of<ServicesController>(context);

    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 24, 18, 16),
                    child: Text(
                      "Add Lead Reply",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  CustomTextField(
                    controller: replyCtrl,
                    hintText: "Reply",
                    labelText: "Reply",
                    autofocus: true,
                    minLines: 3,
                    maxLines: 8,
                    margin: const EdgeInsets.only(top: 14, bottom: 14),
                    validator: (val) {
                      if (val?.isEmpty == true) {
                        return "Reply is Required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  CustomButton(
                      height: 45,
                      width: size.width * 0.7,
                      mainAxisAlignment: MainAxisAlignment.center,
                      text: "Add",
                      fontSize: 16,
                      margin: const EdgeInsets.only(bottom: 16, top: 24),
                      onPressed: () {
                        addReply(onSuccess: onSuccess);
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future addReply({required GestureTapCallback? onSuccess}) async {
    if (formKey.currentState?.validate() == true) {
      context.read<ServiceProviderController>().addReply(
            context: context,
            leadId: lead?.id,
            reply: replyCtrl.text,
            onSuccess: onSuccess,
          );
    } else {}
  }
}
