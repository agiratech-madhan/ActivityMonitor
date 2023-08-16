import 'package:activity_monitor/src/features/NewEvent/Presentation/widgets/even_textfield.dart';
import 'package:activity_monitor/src/ui_utils/app_snack_bar.dart';
import 'package:activity_monitor/src/utils/src/helpers/ui_dimens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../Repository/add_new_event_repository.dart';

class AddNewEvent extends HookConsumerWidget {
  const AddNewEvent({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startEventController = useTextEditingController();
    final endEventController = useTextEditingController();
    final summaryController = useTextEditingController();
    final descriptionController = useTextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade100,
        title: const Text("Add New Event"),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () {
              _showDialog(
                  CupertinoDatePicker(
                    initialDateTime: DateTime.now(),
                    onDateTimeChanged: (time) {
                      ref.read(addEventControllerProvider.notifier).startTime =
                          time;
                      startEventController.text = time.toString();
                    },
                    mode: CupertinoDatePickerMode.dateAndTime,
                  ),
                  context);
            },
            child: TextField(
              enabled: false,
              decoration: InputDecoration(
                  hintText: "Start Date",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)),
                  fillColor: Colors.white,
                  filled: true),
              controller: startEventController,
            ),
          ),
          EventTextFiled(
              controller: startEventController, hintText: "Start Date"),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () async {
              _showDialog(
                  CupertinoDatePicker(
                    initialDateTime: DateTime.now(),
                    onDateTimeChanged: (time) {
                      ref.read(addEventControllerProvider.notifier).endTime =
                          time;
                      endEventController.text = time.toString();
                    },
                    mode: CupertinoDatePickerMode.dateAndTime,
                  ),
                  context);
            },
            child: EventTextFiled(
                controller: endEventController, hintText: "End Date"),
          ),
          const SizedBox(
            height: 20,
          ),
          EventTextFiled(controller: summaryController, hintText: "summary"),
          const SizedBox(
            height: 20,
          ),
          EventTextFiled(
              controller: descriptionController, hintText: "description"),
          const SizedBox(
            height: 20,
          ),
          CupertinoButton.filled(
            child: const Text("AddEvent"),
            onPressed: () async {
              final result =
                  await ref.read(addEventControllerProvider).addevent(
                        summary: summaryController.text,
                        description: descriptionController.text,
                        location: "Agira Tech",
                      );
              if (result) {
                if (context.mounted) {
                  const AppSnackBar(
                          message: "Successfully Added", isPositive: true)
                      .showAppSnackBar(context);
                  startEventController.clear();
                  endEventController.clear();
                  summaryController.clear();
                  descriptionController.clear();
                  if (context.mounted) Navigator.of(context).pop();
                }
              } else {
                if (context.mounted) {
                  AppSnackBar(
                    message: ref
                        .read(addEventControllerProvider)
                        .errorModel
                        ?.error
                        .toString(),
                  ).showAppSnackBar(context);
                }
              }
            },
          )
        ],
      ).paddingAll(10),
    );
  }
}

void _showDialog(Widget child, BuildContext context) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => Container(
      height: 216,
      padding: const EdgeInsets.only(top: 6.0),
      // The bottom margin is provided to align the popup above the system
      // navigation bar.
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      // Provide a background color for the popup.
      color: CupertinoColors.systemBackground.resolveFrom(context),
      // Use a SafeArea widget to avoid system overlaps.
      child: SafeArea(
        top: false,
        child: child,
      ),
    ),
  );
}
