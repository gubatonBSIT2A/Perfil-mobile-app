import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/normal_appbar.dart';

class ExamRecordDetails extends StatelessWidget {
  const ExamRecordDetails({Key? key, required this.results}) : super(key: key);
// declare results variable in array
  final Map<String, dynamic> results;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: NormalAppBar(title: 'Result Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text(results['examinationName']),
              subtitle: const Text('Examination Name'),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: Text(
                DateFormat("MM: dd : yyyy")
                    .format(
                  DateTime.fromMillisecondsSinceEpoch(
                      results['dateExamined'] * 1000),
                )
                    .toString(),
              ),
              subtitle: const Text('Date Examined'),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: Text(results['result']),
              subtitle: const Text('Result'),
            ),
            const SizedBox(height: 10),
            if (results['result'] == "Positive")
              ListTile(
                title:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: results['diagnosis'].length > 0
                        ? results['diagnosis']
                        .map<Widget>(
                          (e) => Row(
                            children: [
                              MyBullet(),
                              SizedBox(
                                width: 10,
                              ),
                              Text(e)

                            ],
                          ),
                    )
                        .toList()
                        : [],
                  )
                ,
                subtitle: const Text('Diagnosis'),
              ),
            const SizedBox(height: 10),
            ListTile(
              title: Text(results['remarks']),
              subtitle: const Text('Remarks'),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: Text(results['receipt']),
              subtitle: const Text('Medical Receipt'),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: Text(results['examinedBy']),
              subtitle: const Text('Examined By'),
            ),
            ListTile(
              title: Text(
                DateFormat("MM: dd : yyyy")
                    .format(
                  DateTime.fromMillisecondsSinceEpoch(results['dona'] * 1000),
                )
                    .toString(),
              ),
              subtitle: const Text('Date of Next Appointment'),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class MyBullet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5.0,
      width: 5.0,
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
    );
  }
}
