import 'package:flutter/material.dart';

import 'package:perfil/widgets/normal_appbar.dart';
import 'package:perfil/services/cloud/results/cloud_results.dart';
import '../services/auth/auth_service.dart';
import '../services/cloud/results/results_cloud_storage.dart';
import 'exam_record_details.dart';

class ExamRecordScreen extends StatefulWidget {
  const ExamRecordScreen({Key? key}) : super(key: key);

  @override
  State<ExamRecordScreen> createState() => _ExamRecordScreenState();
}

class _ExamRecordScreenState extends State<ExamRecordScreen> {
  String get userId => AuthService.firebase().currentUser!.id;
  late final ResultsCloudStorage _resultsService;

  @override
  void initState() {
    _resultsService = ResultsCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: NormalAppBar(
          title: 'Exam Records',
        ),
      ),
      body: StreamBuilder(
          stream: _resultsService.allResults(patientId: userId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allResults = snapshot.data as Iterable<CloudResults>;

                  return CustomScrollView(slivers: [
                    SliverList(
                        delegate: SliverChildBuilderDelegate(
                            childCount: allResults.length, (context, index) {
                      final result = allResults.elementAt(index);
                      print('this is the result ' + result.diagnosis.toString());
                      DateTime newDateExamined =
                          DateTime.fromMillisecondsSinceEpoch(
                              result.dateExamined * 1000);
                      DateTime newDona = DateTime.fromMillisecondsSinceEpoch(
                          result.dona * 1000);
                      String formattedDateExamined =
                          newDateExamined.toString().substring(0, 10);
                      String formattedDona =
                          newDona.toString().substring(0, 10);

                      return Container(
                        margin:
                            const EdgeInsets.only(top: 10, left: 10, right: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                            title: Text(result.examinationName),
                            subtitle: Text(result.result),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () async {
                              await Navigator.of(context)
                                  .push(MaterialPageRoute(
                                builder: (context) =>
                                    ExamRecordDetails(results: result.toJson()),
                              ));
                            }),
                      );
                    }))
                  ]);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              default:
                return const Center(
                  child: Text('No data'),
                );
            }
          }),
    );
  }
}
