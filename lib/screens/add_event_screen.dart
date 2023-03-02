import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:perfil/services/auth/auth_service.dart';
import 'package:perfil/services/cloud/events/app_event.dart';
import 'package:perfil/services/cloud/events/event_firestore_service.dart';
import 'package:perfil/theme/theme_constant.dart';

class AddEvent extends StatefulWidget {
   AddEvent({Key? key, this.event, this.selectedDay,}) : super(key: key);
   DateTime? selectedDay;
  AppEvent? event;
  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  String get userId => AuthService.firebase().currentUser!.id;
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Event'),
        titleTextStyle: const TextStyle(color: newBlack),
        elevation: 0,
        iconTheme: const IconThemeData(color: newBlack),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () async {
              //save
              _formKey.currentState!.save();
              final data = Map<String, dynamic>.from(_formKey.currentState!.value);
              data["date"] = (data["date"] as DateTime).millisecondsSinceEpoch;
              if (widget.event != null) {
                //update
                await eventDBS.updateData(widget.event!.id, data);
              } else {
                //create
                await eventDBS.create({
                  ...data,
                  "user_id": userId,
                });
              }
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        )
      ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          //add event form
          FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                FormBuilderTextField(
                  name: "title",
                  initialValue: widget.event?.title,
                  decoration: const InputDecoration(
                      hintText: "Add Title",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 48.0)),
                ),
                const Divider(),
                FormBuilderTextField(
                  name: "description",
                  initialValue: widget.event?.description ?? '',
                  minLines: 1,
                  maxLines: 5,
                  decoration: const InputDecoration(
                      hintText: "Add Details",
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.short_text)),
                ),
                const Divider(),
                FormBuilderSwitch(
                  name: "public",
                  initialValue: widget.event?.public ?? false,
                  title: const Text("Public"),
                  controlAffinity: ListTileControlAffinity.leading,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
                const Divider(),
                FormBuilderDateTimePicker(
                  name: "date",
                  initialValue: widget.selectedDay ??
                      widget.event?.date ??
                      DateTime.now(),
                  initialDate: DateTime.now(),
                  fieldHintText: "Add Date",
                  initialDatePickerMode: DatePickerMode.day,
                  inputType: InputType.date,
                  format: DateFormat('EEEE, dd MMMM, yyyy'),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.calendar_today_sharp),
                  ),
                ),
                const Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
