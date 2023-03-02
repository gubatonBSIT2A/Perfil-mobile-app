import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:perfil/services/auth/auth_service.dart';
import 'package:perfil/theme/theme_constant.dart';

class AddExamination extends StatefulWidget {
  AddExamination({Key? key,
    // this.examination,
    this.selectedDay})
      : super(key: key);
  DateTime? selectedDay;
  // AppExamination? examination;
  @override
  State<AddExamination> createState() => _AddExaminationState();
}

class _AddExaminationState extends State<AddExamination> {
  String get userId => AuthService.firebase().currentUser!.id;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //   title: const Text(
      //     'Add Examination',
      //     style: TextStyle(
      //       color: newBlack,
      //     ),
      //   ),
      //   actions: [
      //     TextButton(
      //       child: const Text('Save'),
      //       onPressed: () async {
      //         //
      //         _formKey.currentState!.save();
      //         final data =
      //             Map<String, dynamic>.from(_formKey.currentState!.value);
      //         data["examinationDate"] = (data["examinationDate"] as DateTime).millisecondsSinceEpoch;
      //         data["examinationDONA"] = (data["examinationDONA"] as DateTime).millisecondsSinceEpoch;
      //         if (widget.examination != null) {
      //           await examDBS.updateData(widget.examination!.id, data);
      //         } else {
      //           //create
      //           await examDBS.create({
      //             ...data,
      //             "userId": userId,
      //           });
      //         }
      //         Navigator.pop(context);
      //       },
      //     )
      //   ],
      // ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              FormBuilderTextField(

                name: 'examinationName',
                // initialValue: widget.examination?.examinationName,
                decoration: const InputDecoration(
                  label: Text(
                    'Examination Name',
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FormBuilderTextField(
                // initialValue: widget.examination?.examinationResult ?? '',
                name: 'examinationResult',
                decoration: const InputDecoration(
                  label: Text(
                    'Examination Result',
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FormBuilderTextField(
                // initialValue: widget.examination?.examinationExaminedBy ?? '',
                name: 'examinationExaminedBy',
                decoration: const InputDecoration(
                  label: Text(
                    'Examined By',
                  ),
                ),
              ),
              FormBuilderSwitch(
                // initialValue: widget.examination?.examinationIsMissed ?? false,
                controlAffinity: ListTileControlAffinity.leading,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                name: 'examinationIsMissed',
                title: const Text('Missed?'),
              ),
              FormBuilderDateTimePicker(
                name: 'examinationDate',
                initialValue: widget.selectedDay ??
                    // widget.examination?.examinationDate ??
                    DateTime.now(),
                initialDate: DateTime.now(),
                inputType: InputType.date,
                initialDatePickerMode: DatePickerMode.day,
                format: DateFormat('EEE, dd MMMM, yyyy'),
                decoration: const InputDecoration(
                  label: Text('Examination Date')
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FormBuilderDateTimePicker(
                name: 'examinationDONA',
                initialValue: widget.selectedDay ??
                    // widget.examination?.examinationDate ??
                    DateTime.now(),
                initialDate: DateTime.now(),
                inputType: InputType.date,
                initialDatePickerMode: DatePickerMode.day,
                format: DateFormat('EEE, dd MMMM, yyyy'),
                decoration: const InputDecoration(
                    label: Text('Date of Next Appointment')
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
