import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:perfil/constants/routes.dart';
import 'package:perfil/services/cloud/cloud_note.dart';
import 'package:perfil/services/cloud/firebase_cloud_storage.dart';
import 'package:perfil/theme/theme_constant.dart';
import 'package:perfil/utils/dialogs/delete_dialog.dart';
import 'package:perfil/widgets/primary_appbar.dart';
import 'package:perfil/services/auth/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _establishmentId;
  String get userId => AuthService.firebase().currentUser!.id;

  aFunction(userId) async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    DocumentSnapshot snapshot =
        await _firestore.collection('patients').doc(userId).get();

    String establishment = snapshot.get('establishment');
    return establishment.toString();
  }

  late final FirebaseCloudStorage _noteService;
  @override
  void initState() {
    aFunction(userId).then((value) {
      setState(() {
        _establishmentId = value;
      });
    });
    _noteService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream:
          _noteService.allNotes(establishmentId: _establishmentId.toString()),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.active:
            if (snapshot.hasData) {
              final allNotes = snapshot.data as Iterable<CloudNote>;

              return CustomScrollView(
                slivers: [
                  PrimaryAppBar(),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      childCount: allNotes.length,
                      (context, index) {
                        final note = allNotes.elementAt(index);
                        DateTime date = DateTime.fromMillisecondsSinceEpoch(
                            note.dateCreated * 1000);
                        String formattedDate =
                            DateFormat('MM:dd:yyyy').format(date);
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          color: Colors.white,
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      children: [
                                        const CircleAvatar(
                                          backgroundColor: primaryColor,
                                          radius: 20,
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Announcement',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                //convert dateCreated from unix to date format
                                                Text(
                                                  formattedDate,
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      note.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      note.description,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          default:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    ));
  }
}
