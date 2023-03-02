import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:perfil/screens/add_examination_screen.dart';
import 'package:perfil/screens/examination_details.dart';
import 'package:perfil/services/auth/auth_service.dart';
import 'package:perfil/services/cloud/events/appointments/appointment_firestore_service.dart';
import 'package:perfil/theme/theme_constant.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/cloud/events/appointments/app_appointment.dart';
import '../widgets/normal_appbar.dart';

final kNow = DateTime.now();
final kFirstDay = DateTime(kNow.year, kNow.month - 3, kNow.day);
final kLastDay = DateTime(kNow.year, kNow.month + 3, kNow.day);

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  String? _establishmentId;
  String get userId => AuthService.firebase().currentUser!.id;

  aFunction(userId) async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    DocumentSnapshot snapshot =
    await _firestore.collection('patients').doc(userId).get();
    String establishment = snapshot.get('establishment');
    return establishment.toString();
  }

  @override
  void initState() {
    aFunction(userId).then((value) {
      setState(() {
        _establishmentId = value;
      });
    });
    super.initState();
  }

  late LinkedHashMap<DateTime, List<AppAppointment>> _groupedEvents;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  _groupEvents(List<AppAppointment> events) {
    _groupedEvents = LinkedHashMap(equals: isSameDay, hashCode: getHashCode);
    events.forEach((event) {
      DateTime date = DateTime.utc(
        event.start.year,
        event.start.month,
        event.start.day,
        12,
      );
      if (_groupedEvents[date] == null)
        _groupedEvents[date] = [];
      _groupedEvents[date]?.add(event);
    });
  }

  List<dynamic> _getEventForDay(DateTime date) {
    return _groupedEvents[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   heroTag: 'btn10',
      //   onPressed: () {
      //     Navigator.of(context).push(MaterialPageRoute(
      //       builder: (context) => AddExamination(selectedDay: _selectedDay),
      //     ));
      //   },
      //   child: const Icon(Icons.add),
      // ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: NormalAppBar(title: 'Schedules'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: StreamBuilder(
          stream: appointmentDBS.streamQueryList(args: [
            QueryArgsV2(
              "establishment",
              isEqualTo: _establishmentId,
            ),
          ]),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              final events = snapshot.data;
              _groupEvents(events);
              DateTime selectedDate = _selectedDay;
              final _selectedEvents = _groupedEvents[selectedDate] ?? [];
              DateTime.utc(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                12,
              );
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: TableCalendar(
                      focusedDay: _focusedDay,
                      firstDay: kFirstDay,
                      lastDay: kLastDay,
                      eventLoader: (day) {
                        return _getEventForDay(day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        leftChevronIcon: Icon(
                          Icons.chevron_left,
                          color: primaryColor,
                        ),
                        rightChevronIcon: Icon(
                          Icons.chevron_right,
                          color: primaryColor,
                        ),
                      ),
                      calendarStyle: CalendarStyle(
                        todayTextStyle: const TextStyle(color: Colors.blue),
                        todayDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.blue),
                        ),
                        selectedDecoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.blue),
                      ),
                      calendarBuilders: const CalendarBuilders(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 8.0),
                    child: Text(
                      DateFormat('EEEE, dd MMMM, yyyy').format(selectedDate),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  if (_selectedEvents.isEmpty)
                    const ListTile(
                      title: Text("No Appointment on selected day"),
                    ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _selectedEvents.length,
                    itemBuilder: (BuildContext context, int index) {
                      AppAppointment event = _selectedEvents[index];
                      return Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        margin: const EdgeInsets.only(top: 10),
                        child: ListTile(
                            title: Text(event.title),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                             Row(
                               children: [
                                 const Text('From:'),
                                 const SizedBox(width: 5,),
                                 Text(DateFormat("MM, dd, yyyy")
                                     .format(event.start)),
                                  const SizedBox(width: 5,),
                                 const Text('-'),
                                 const  SizedBox(width: 5,),
                                 const Text('To:'),
                                 const SizedBox(width: 5,),
                                 Text(DateFormat("MM, dd, yyyy") //EEEE, dd MM, yyyy format if you want to be complete
                                     .format(event.end)),
                               ],
                             ),
                              ],
                            ),
                            // trailing: const Icon(Icons.chevron_right),
                        ),
                      );
                    },
                  ),
                ],
              );
            }
            return Center(
              child: Column(
                children: const [
                  CircularProgressIndicator(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
