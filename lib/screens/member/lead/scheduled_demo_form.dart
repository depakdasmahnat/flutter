import 'package:flutter/material.dart';
import 'package:mrwebbeast/screens/guest/guestProfile/guest_faq.dart';
import 'package:mrwebbeast/utils/widgets/appbar.dart';

import '../../guest/guestProfile/guest_edit_profile.dart';

class ScheduledDemoForm extends StatefulWidget {
  const ScheduledDemoForm({super.key});

  @override
  State<ScheduledDemoForm> createState() => _ScheduledDemoFormState();
}

class _ScheduledDemoFormState extends State<ScheduledDemoForm> {
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height * 0.07),
        child: CustomAppBar(
          title: 'Create a demos',
          showLeadICon: true,
        ),
      ),
      body: ListView(
        children: [
          CustomDropdown(
            context: context,
            title: 'Type of demo*',
            listItem: ['Online', 'Offline'],
            hintText: 'Select',
          ),
          CustomTextFieldApp(
            title: 'Start Date',
            hintText: 'dd/mm/yy',
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2101),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      popupMenuTheme: PopupMenuThemeData(
                          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                      cardColor: Colors.white,

                      colorScheme: Theme.of(context).colorScheme.copyWith(
                            primary: Colors.white, // <-- SEE HERE
                            onPrimary: Colors.black, // <-- SEE HERE
                            onSurface: Colors.white,
                          ),

                      // Input
                      inputDecorationTheme: const InputDecorationTheme(
                          // labelStyle: GoogleFonts.greatVibes(), // Input label
                          ),
                    ),
                    child: child!,
                  );
                },
              );

              if (pickedDate != null) {
                timeController.text =
                    "${pickedDate.day.toString().padLeft(2, "0")}/${pickedDate.month.toString().padLeft(2, "0")}/${pickedDate.year}";
              }
            },
          ),
          CustomTextFieldApp(
            title: 'Time',
            hintText: 'hh:mm',
            controller: timeController,
            onTap: () async {
              Future<TimeOfDay?> selectedTime24Hour = showTimePicker(
                context: context,
                initialTime: const TimeOfDay(hour: 10, minute: 47),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      popupMenuTheme: PopupMenuThemeData(
                          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                      cardColor: Colors.white,

                      colorScheme: Theme.of(context).colorScheme.copyWith(
                            primary: Colors.white, // <-- SEE HERE
                            onPrimary: Colors.black, // <-- SEE HERE
                            onSurface: Colors.white,
                          ),

                      // Input
                      inputDecorationTheme: const InputDecorationTheme(
                          // labelStyle: GoogleFonts.greatVibes(), // Input label
                          ),
                    ),
                    child: child!,
                  );
                },
              );
              if (selectedTime24Hour != null) {
                timeController.text = selectedTime24Hour.toString() ?? '';
              }
            },
          ),
          CustomeText(
            text: 'Select your lists',
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          CustomeText(
            text: 'Select Members to add',
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          CustomTextFieldApp(
            title: 'Search',
            hintText: 'hh:mm',
          ),
        ],
      ),
    );
  }
}
